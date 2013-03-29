//
//  DSViewController.m
//  BoredNoMore
//
//  Created by Daniel Spinosa on 3/29/13.
//  Copyright (c) 2013 Dan Spinosa. All rights reserved.
//

#import "DSViewController.h"
#import "DSBoredGestureRecognizer.h"
#import "DS4ChanImageFetcher.h"

@interface DSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) UIImage *burns;
@property (strong, nonatomic) NSTimer *burnsTimer;
@property (strong, nonatomic) NSTimer *impatientTimer;

@property (strong, nonatomic) DSBoredGestureRecognizer *impatientGesture;
@property (strong, nonatomic) DSBoredGestureRecognizer *boredGesture;

@property (strong, nonatomic) DS4ChanImageFetcher *imgFetcher;

@end

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imgFetcher = [[DS4ChanImageFetcher alloc] init];
    
    _burnsTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(showMrBurns) userInfo:nil repeats:NO];
    
    // Double TAP resets to Burns
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(tapRecognized)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    
    // Single TAP kills timers
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(cancelImageTimers)];
    singleTapGesture.numberOfTapsRequired = 1;
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self.view addGestureRecognizer:singleTapGesture];
    
    // IMPATIENT
    self.impatientGesture = [[DSBoredGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(impatientRecognized)];
    self.impatientGesture.numberOfSequencesRequired = 3;
    self.impatientGesture.graceBetweenSequences = 0.4;
    [self.view addGestureRecognizer:self.impatientGesture];
    
    // BORED
    self.boredGesture = [[DSBoredGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(boredRecognized)];
    self.boredGesture.numberOfSequencesRequired = 1;
    [self.boredGesture requireGestureRecognizerToFail:self.impatientGesture];
    [self.view addGestureRecognizer:self.boredGesture];
}

-(void) boredRecognized
{
    if(self.boredGesture.direction == DSBoredGestureRecognizerDirectionLeft){
        self.headLabel.text = @"<--bored you seem---";
    } else {
        self.headLabel.text = @"---you seem bored-->";
    }
    
    [self cancelImageTimers];
    [self nextImage];
}

-(void) impatientRecognized
{
    self.headLabel.text = @"INTERNET, GO!";
    
    [self cancelImageTimers];
    if(!_impatientTimer){
        _impatientTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    }
}

-(void) tapRecognized
{
    [self cancelImageTimers];
    self.headLabel.text = nil;
    [self showMrBurns];
}

-(void) nextImage
{
    [self.imgFetcher updateImageViewWithNextImage:self.imageView andActivityIndicator:self.activityIndicator];
}

-(void) cancelImageTimers;
{
    [_burnsTimer invalidate];
    _burnsTimer = nil;
    [_impatientTimer invalidate];
    _impatientTimer = nil;
}

-(void) showMrBurns
{
    if(!self.burns){
        self.burns = [UIImage animatedImageWithImages:@[[UIImage imageNamed:@"burns0.gif"],
                      [UIImage imageNamed:@"burns1.gif"],
                      [UIImage imageNamed:@"burns2.gif"],
                      [UIImage imageNamed:@"burns3.gif"],
                      [UIImage imageNamed:@"burns4.gif"],
                      [UIImage imageNamed:@"burns5.gif"],
                      [UIImage imageNamed:@"burns6.gif"],
                      [UIImage imageNamed:@"burns7.gif"]]
                                             duration:1.25];
    }
    [self.imageView setImage:self.burns];
}

@end
