//
//  DSBoredGestureRecognizer.m
//  Built at Shelby.tv in NYC
//
//  The gesture recognizer Apple forgot.  Maybe they don't get bored, but maybe your users do.
//  Finally, you can detect boredom and fix it by showing pictures of Unircorns (or whatever
//  floats your boat).
//
//  The DSBoredGestureRecognizer looks for the classic waterfall from pinky to index finger.  By default,
//  it waits for two of these sequences before signaling recognized.  You can customize the number of
//  required sequences with -[DSBoredGestureRecognizer setNumberOfSequencesRequired:(NSUInteger)].
//
//  Want to detect that a user is more impatient than bored?  You can also reduce the grace period allotted
//  between waterfall sequences via -[DSBoredGestureRecognizer setGraceBetweenSequences:(NSTimeInterval)].
//
//  Accessiblity is important.  If your users have more or fewer fingers, adjust the minimum number of fingers
//  required in the waterfall with -[DSBoredGestureRecognizer setNumberOfTouchesRequired:(NSUInteger)];
//
//  PS You should attach this gesture to a full window root view.  Want to know why?  Read the code and comments.
//
//
//  Created by Daniel Spinosa on 3/28/13.
//  Copyright (c) 2013 Daniel Spinosa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface DSBoredGestureRecognizer : UIGestureRecognizer

// default: 4 (ie. thumb not required)
@property (nonatomic) NSUInteger numberOfTouchesRequired;
// default: 1
@property (nonatomic) NSUInteger numberOfSequencesRequired;
// Amount of time that may pass between valid sequences.  Default: 1.25 seconds
@property (nonatomic) NSTimeInterval graceBetweenSequences;

typedef NS_OPTIONS(NSUInteger, DSBoredGestureRecognizerDirection) {
    DSBoredGestureRecognizerDirectionRight = 1 << 0,
    DSBoredGestureRecognizerDirectionLeft  = 1 << 1
};

@property (readonly) DSBoredGestureRecognizerDirection direction;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)reset;

@end
