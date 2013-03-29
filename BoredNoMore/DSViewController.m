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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) DSBoredGestureRecognizer *impatientGesture;
@property (strong, nonatomic) DSBoredGestureRecognizer *boredGesture;

@end

@implementation DSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(showMrBurns) userInfo:nil repeats:NO];
    
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

-(void) showMrBurns
{
    UIImage *burns = [UIImage animatedImageWithImages:@[[UIImage imageNamed:@"burns0.gif"],
                      [UIImage imageNamed:@"burns1.gif"],
                      [UIImage imageNamed:@"burns2.gif"],
                      [UIImage imageNamed:@"burns3.gif"],
                      [UIImage imageNamed:@"burns4.gif"],
                      [UIImage imageNamed:@"burns5.gif"],
                      [UIImage imageNamed:@"burns6.gif"],
                      [UIImage imageNamed:@"burns7.gif"]]
                                             duration:1.25];
    [self.imageView setImage:burns];
}

@end
