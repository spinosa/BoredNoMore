//
//  DSBoredGestureRecognizer.m
//  Built at Shelby.tv in NYC
//
//  Created by Daniel Spinosa on 3/28/13.
//  Copyright (c) 2013 Daniel Spinosa. All rights reserved.
//

#import "DSBoredGestureRecognizer.h"
#import <math.h>

@interface DSBoredGestureRecognizer()

@property (nonatomic) NSUInteger sequencesSeen;
@property (nonatomic, strong) NSTimer *nextSequenceBeginGraceTimer;
@property (nonatomic, strong) NSMutableArray *touchPath;

@end

@implementation DSBoredGestureRecognizer

-(id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if(self){
        _numberOfTouchesRequired = 4;
        _numberOfSequencesRequired = 2;
        _graceBetweenSequences = 1.25;
        _touchPath = [NSMutableArray arrayWithCapacity:[self numberOfTouchesRequired]];
        [self reset];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if([touches count] != 1){
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
    // locationInView:nil returns location relative to UIWindow's coordinate system
    // this is nice and useful if you care about absolute movement of fingers, but
    // NB: That coordinate system is always in standard portrait mode!
    // Just make sure to attach this gesture to a full screen root view
    [self.touchPath addObject:[NSValue valueWithCGPoint:[[touches anyObject] locationInView:self.view]]];
    [self.nextSequenceBeginGraceTimer invalidate];
    self.nextSequenceBeginGraceTimer = nil;
    
    if([self.touchPath count] == self.numberOfTouchesRequired){
        if(![self touchPathIsValid]){
            self.state = UIGestureRecognizerStateFailed;
            return;
        }
        _sequencesSeen++;

        if(self.sequencesSeen == self.numberOfSequencesRequired){
            DLog(@"-------RECOGNIZED(%d)--------", self.numberOfSequencesRequired);
            self.state = UIGestureRecognizerStateRecognized;
        } else {
            DLog(@"Waiting for another bored sequence...");
            self.nextSequenceBeginGraceTimer = [NSTimer scheduledTimerWithTimeInterval:self.graceBetweenSequences
                                                                                target:self
                                                                              selector:@selector(nextSequenceFailed)
                                                                              userInfo:nil
                                                                               repeats:NO];
        }
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    //don't care
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
 
    if(self.nextSequenceBeginGraceTimer){
        //waiting for next sequence, perfect time to reset the current one
        [_touchPath removeAllObjects];
    } else {
        // not waiting for next sequence means a finger was removed mid-gesture,
        // this is not a continous waterfall of fingers; fail.
        self.state = UIGestureRecognizerStateFailed;
    }
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    self.state = UIGestureRecognizerStateFailed;
}

-(void) reset
{
    [super reset];
    [_touchPath removeAllObjects];
    _sequencesSeen = 0;
    [_nextSequenceBeginGraceTimer invalidate];
    _nextSequenceBeginGraceTimer = nil;
    
    DLog(@"RESET (%d)", self.numberOfSequencesRequired);
}

#pragma mark - Helpers

-(void) nextSequenceFailed
{
    DLog(@"Didn't receive another sequence, failing...");
    self.state = UIGestureRecognizerStateFailed;
}

// Moving anti-clockwise in quadrant I (top right), atan moves from 0 to 90
// Continuing anti-clockwise in quad II (top left), atan moves from 90 to 180
// Moving anti-clockwise in quadrant IV (bot right), atan moves from -0 to -90
// Continuing anti-clockwise in quad III (bot left), atan moves from -90 to -180
//
// NB: Vectors with small dY in quadrants II and III are similar but atan differs by 360.
// We take this into account when checking angles for similarity
CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat dY = second.y - first.y;
    CGFloat dX = first.x - second.x;
    CGFloat rads = atan2f(dY, dX);
    return rads * 180 / M_PI;
}

// returns x and y in set [-1,1] to indicate absolute direction relative to screen coordinate system
// ie. Returning {-1,1} means moving left (negative X) and down (positive Y)
CGPoint directionBetweenPoints(CGPoint start, CGPoint end) {
    DLog(@"determining direction for %@ -> %@", NSStringFromCGPoint(start), NSStringFromCGPoint(end));
    return CGPointMake(MIN(1, MAX(-1, end.x-start.x)), MIN(1, MAX(-1, end.y-start.y)));
}

#define MAX_ANGLE_DIFF 60.0f

// a valid path proceeds in the same general direction without altering heading too greatly
// fails if the heading changes too sharply or absolute direction in both X and Y change simultaneously
-(BOOL)touchPathIsValid
{
    CGPoint curPoint, lastPoint, curDirection, lastDirection;
    CGFloat lastAngle, curAngle;
    
    for (NSUInteger i = 0; i < [self.touchPath count]; ++i) {
        curPoint = [self.touchPath[i] CGPointValue];
        if(i > 0){
            curAngle = angleBetweenPoints(curPoint, lastPoint);
            curDirection = directionBetweenPoints(lastPoint, curPoint);
            if(i > 1){
                //cancel if angles aren't close enough
                DLog(@"last angle: %f, cur angle: %f, diff: %f", lastAngle, curAngle, fabs(lastAngle-curAngle));
                if(fabs(lastAngle-curAngle) > MAX_ANGLE_DIFF){
                    // vectors in quadrant II and III are actually close, account for that by converting quad III
                    if(lastAngle < 0){
                        lastAngle += 360;
                    } else if(curAngle < 0){
                        curAngle += 360;
                    }
                    if(fabs(lastAngle-curAngle) > MAX_ANGLE_DIFF){
                        DLog(@"KILL B/C ANGLE");
                        return NO;
                    }
                }
                
                //cancel if both X and Y change direction
                DLog(@"(%d) - Cur Direction %@, last direction %@", self.numberOfSequencesRequired, NSStringFromCGPoint(curDirection), NSStringFromCGPoint(lastDirection));
                if(curDirection.x != lastDirection.x && curDirection.y != lastDirection.y){
                    DLog(@"KILL B/C DIRECTION");
                    return NO;
                } else {
                    _direction = (lastDirection.x > 0 ? DSBoredGestureRecognizerDirectionRight : DSBoredGestureRecognizerDirectionLeft);
                }
            }
            lastAngle = curAngle;
            lastDirection = curDirection;
        }
        lastPoint = curPoint;
    }
    DLog(@"BORED (%d)...", self.numberOfSequencesRequired);
    return YES;
}

@end
