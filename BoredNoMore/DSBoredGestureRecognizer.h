//
//  DSBoredGestureRecognizer.m
//  Shelby.tv
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
