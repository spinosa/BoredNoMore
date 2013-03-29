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

@property (strong, nonatomic) DSBoredGestureRecognizer *impatientGesture;
@property (strong, nonatomic) DSBoredGestureRecognizer *boredGesture;

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
