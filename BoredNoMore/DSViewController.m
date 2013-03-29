//
//  DSViewController.m
//  BoredNoMore
//
//  Created by Daniel Spinosa on 3/29/13.
//  Copyright (c) 2013 Dan Spinosa. All rights reserved.
//

#import "DSViewController.h"
#import "DSBoredGestureRecognizer.h"

@interface DSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headLabel;

@end

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // TAP
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapRecognized)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
    
    // IMPATIENT
    DSBoredGestureRecognizer *impatientGesture = [[DSBoredGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(impatientRecognized)];
    impatientGesture.numberOfSequencesRequired = 3;
    impatientGesture.graceBetweenSequences = 0.4;
    [self.view addGestureRecognizer:impatientGesture];
    
    // BORED
    DSBoredGestureRecognizer *boredGesture = [[DSBoredGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(boredRecognized)];
    boredGesture.numberOfSequencesRequired = 1;
    [boredGesture requireGestureRecognizerToFail:impatientGesture];
    [self.view addGestureRecognizer:boredGesture];
}

-(void) boredRecognized
{
    self.headLabel.text = @"You seem bored...";
}

-(void) impatientRecognized
{
    self.headLabel.text = @"Ok... relax... INTERNET, GO!";
}

-(void) tapRecognized
{
    self.headLabel.text = @"do something";
}

@end
