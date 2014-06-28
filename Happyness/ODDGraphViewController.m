//
//  ODDGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/21/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDGraphViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ODDGraphViewController ()

@end

@implementation ODDGraphViewController
@synthesize graphAll = _graphAll;
@synthesize graphMedium = _graphMedium;
@synthesize graphShortTerm = _graphShortTerm;
@synthesize graphTitle = _graphTitle;
@synthesize topFrame = _topFrame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _graphTitle = [[UILabel alloc] init];
        _graphAll = [[UIButton alloc] init];
        _graphMedium = [[UIButton alloc] init];
        _graphShortTerm = [[UIButton alloc] init];
        _topFrame = [[UIView alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    [self initializeTopPortionOfFrame];
    [self initializeGraphTitle];
    [self initializeButtons];
}

- (void)initializeGraphTitle {
    CGRect rootFrame = self.view.frame;
    CGSize rootSize = rootFrame.size;
    self.graphTitle.frame = CGRectMake(rootSize.width / 10,
                                       0,
                                       rootSize.width / 2,
                                       rootSize.height / 8);
    self.graphTitle.text = @"Placeholder";
    self.graphTitle.textColor = [UIColor whiteColor];
    [self.view addSubview:self.graphTitle];
}

- (void)initializeButtons {
    CGRect rootFrame = self.view.frame;
    CGSize rootSize = rootFrame.size;
    CGRect titleFrame = self.graphTitle.frame;
    CGSize titleSize = titleFrame.size;
    CGPoint titlePosition = titleFrame.origin;
    self.graphAll.frame = CGRectMake(rootSize.width - titlePosition.x - rootSize.width / 8,
                                     titlePosition.y,
                                     rootSize.width / 8,
                                     titleSize.height + (titleSize.height / 6));
    CGRect graphAllFrame = self.graphAll.frame;
    CGSize graphAllSize = graphAllFrame.size;
    CGPoint graphAllPosition = graphAllFrame.origin;
    self.graphMedium.frame = CGRectMake(graphAllPosition.x - graphAllSize.width,
                                        graphAllPosition.y,
                                        graphAllSize.width,
                                        graphAllSize.height);
    self.graphShortTerm.frame = CGRectMake(graphAllPosition.x - (graphAllSize.width * 2),
                                           graphAllPosition.y,
                                           graphAllSize.width,
                                           graphAllSize.height);
    self.graphAll.layer.cornerRadius = 8;
    self.graphMedium.layer.cornerRadius = 8;
    self.graphShortTerm.layer.cornerRadius = 8;
    self.graphAll.backgroundColor = [UIColor grayColor];
    self.graphMedium.backgroundColor = [UIColor grayColor];
    self.graphShortTerm.backgroundColor = [UIColor grayColor];
    [self.graphAll setTitle:@"All" forState:UIControlStateNormal];
    [self.graphMedium setTitle:@"30 Days" forState:UIControlStateNormal];
    [self.graphShortTerm setTitle:@"7 Days" forState:UIControlStateNormal];
    [self.view addSubview:self.graphAll];
    [self.view addSubview:self.graphShortTerm];
    [self.view addSubview:self.graphMedium];
}

- (void)initializeTopPortionOfFrame {
    self.topFrame.backgroundColor = [UIColor blackColor];
    CGSize rootSize = self.view.frame.size;
    self.topFrame.frame = CGRectMake(0, 0, rootSize.width, rootSize.height / 8);
    [self.view addSubview:self.topFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)graphShortTerm:(id)sender {
    
}

- (IBAction)graphMedium:(id)sender {
    
}

- (IBAction)graphAll:(id)sender {
    
}

@end
