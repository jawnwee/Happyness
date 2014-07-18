//
//  ODDGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/21/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDGraphViewController.h"
#import "ODDHappynessEntryStore.h"
#import "ODDCustomColor.h"
#import <QuartzCore/QuartzCore.h>

@interface ODDGraphViewController ()

@end

@implementation ODDGraphViewController
@synthesize graphAll = _graphAll;
@synthesize graphMedium = _graphMedium;
@synthesize graphShortTerm = _graphShortTerm;
@synthesize graphTitle = _graphTitle;
@synthesize topFrame = _topFrame;
@synthesize shortTermCount = _shortTermCount;
@synthesize mediumCount = _mediumCount;
@synthesize entries = _entries;
@synthesize currentAmountOfData = _currentAmountOfData;
@synthesize allData = _allData;
@synthesize mediumeData = _mediumData;
@synthesize shortData = _shortData;
@synthesize colors = _colors;
@synthesize notEnoughDataLabel = _notEnoughDataLabel;

#pragma mark - Init/Alloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _notEnoughDataLabel = [[UILabel alloc] init];
        _graphAll = [UIButton buttonWithType:UIButtonTypeCustom];
        _graphMedium = [UIButton buttonWithType:UIButtonTypeCustom];
        _graphShortTerm = [UIButton buttonWithType:UIButtonTypeCustom];
        _topFrame = [[UIView alloc] init];
        _entries = [[ODDHappynessEntryStore sharedStore] sortedStore];
        _currentAmountOfData = ODDGraphAmountShortTerm;
        _colors = [ODDCustomColor customColorDictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}



#pragma mark - Setters

- (void)setFrameSize:(CGSize)size {
    CGRect originalFrame = self.view.frame;
    CGRect frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, size.width, size.height - 20);
    [self.view setFrame:frame];
    [self initializeTopPortionOfFrame];
    [self initializeLabels];
    [self initializeButtons];
}

- (void)setFramePosition:(CGPoint)point {
    CGRect originalFrame = self.view.frame;
    CGRect frame = CGRectMake(point.x, point.y, originalFrame.size.width, originalFrame.size.height);
    [self.view setFrame:frame];
}

#pragma mark - Subviews Init/Layout

- (void)initializeTopPortionOfFrame {
    self.topFrame.backgroundColor = [UIColor clearColor];
    CGSize rootSize = self.view.frame.size;
    CGFloat topHeight = 30;
    self.topFrame.frame = CGRectMake(0, 0, rootSize.width, topHeight);
    [self.view addSubview:self.topFrame];
}

- (void)initializeLabels {
    self.notEnoughDataLabel.text = @"Not Enough Data :(";
    [self.notEnoughDataLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.notEnoughDataLabel sizeToFit];
    self.notEnoughDataLabel.center = self.view.center;
    self.notEnoughDataLabel.textColor = [UIColor blackColor];
    self.notEnoughDataLabel.textAlignment = NSTextAlignmentCenter;
    if (self.entries.count == 0) {
        [self.view addSubview:self.notEnoughDataLabel];
    }
}

- (void)initializeButtons {
    CGRect topFrame = self.topFrame.frame;
    CGSize topSize = topFrame.size;
    CGFloat width = 70;
    CGFloat sidePadding = width / 4;
    self.graphShortTerm.frame = CGRectMake(sidePadding,
                                     0,
                                     width,
                                     topSize.height);
    CGRect graphShortFrame = self.graphShortTerm.frame;
    CGSize graphShortSize = graphShortFrame.size;
    CGPoint graphShortPosition = graphShortFrame.origin;
    self.graphMedium.frame = CGRectMake((topSize.width / 2) - (graphShortSize.width / 2),
                                        graphShortPosition.y,
                                        graphShortSize.width,
                                        graphShortSize.height);
    self.graphAll.frame = CGRectMake(topSize.width - sidePadding - graphShortSize.width,
                                     graphShortPosition.y,
                                     graphShortSize.width,
                                     graphShortSize.height);
    self.graphAll.layer.cornerRadius = 8;
    self.graphMedium.layer.cornerRadius = 8;
    self.graphShortTerm.layer.cornerRadius = 8;
    self.graphAll.backgroundColor = [UIColor clearColor];
    self.graphMedium.backgroundColor = [UIColor clearColor];
    self.graphShortTerm.backgroundColor = self.colors[@"oddLook_textcolor"];
    CGFloat buttonFontSize = 18;
    [self.graphAll.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light"
                                                      size:buttonFontSize]];
    [self.graphMedium.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light"
                                                         size:buttonFontSize]];
    [self.graphShortTerm.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light"
                                                            size:buttonFontSize]];
    [self.graphAll setTitleColor:self.colors[@"oddLook_textcolor"] forState:UIControlStateNormal];
    [self.graphMedium setTitleColor:self.colors[@"oddLook_textcolor"] forState:UIControlStateNormal];
    [self.graphShortTerm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.graphAll setTitle:@"All" forState:UIControlStateNormal];
    [self.graphMedium setTitle:@"35 Days" forState:UIControlStateNormal];
    [self.graphShortTerm setTitle:@"7 Days" forState:UIControlStateNormal];
    [self.graphAll addTarget:self
                      action:@selector(graphAll:)
            forControlEvents:UIControlEventTouchDown];
    [self.graphMedium addTarget:self
                         action:@selector(graphMedium:)
               forControlEvents:UIControlEventTouchDown];
    [self.graphShortTerm addTarget:self
                            action:@selector(graphShortTerm:)
                  forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.graphAll];
    [self.view addSubview:self.graphShortTerm];
    [self.view addSubview:self.graphMedium];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setup Datastore

// Need to re-sort?
- (void)reloadDataStore {
    [[ODDHappynessEntryStore sharedStore] sortStore:YES];
    self.entries = [[ODDHappynessEntryStore sharedStore] sortedStore];
}

#pragma mark - Button IBActions

- (IBAction)graphShortTerm:(id)sender {
    self.graphAll.backgroundColor = [UIColor clearColor];
    self.graphMedium.backgroundColor = [UIColor clearColor];
    self.graphShortTerm.backgroundColor = self.colors[@"oddLook_textcolor"];
    [self.graphAll setTitleColor:self.colors[@"oddLook_textcolor"] forState:UIControlStateNormal];
    [self.graphMedium setTitleColor:self.colors[@"oddLook_textcolor"] forState:UIControlStateNormal];
    [self.graphShortTerm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)graphMedium:(id)sender {
    self.graphAll.backgroundColor = [UIColor clearColor];
    self.graphMedium.backgroundColor = self.colors[@"oddLook_textcolor"];
    self.graphShortTerm.backgroundColor = [UIColor clearColor];
    [self.graphAll setTitleColor:self.colors[@"oddLook_textcolor"] forState:UIControlStateNormal];
    [self.graphMedium setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.graphShortTerm setTitleColor:self.colors[@"oddLook_textcolor"] forState:UIControlStateNormal];
}

- (IBAction)graphAll:(id)sender {
    self.graphAll.backgroundColor = self.colors[@"oddLook_textcolor"];
    self.graphMedium.backgroundColor = [UIColor clearColor];
    self.graphShortTerm.backgroundColor = [UIColor clearColor];
    [self.graphAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.graphMedium setTitleColor:self.colors[@"oddLook_textcolor"] forState:UIControlStateNormal];
    [self.graphShortTerm setTitleColor:self.colors[@"oddLook_textcolor"] forState:UIControlStateNormal];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disableScroll" object:self];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableScroll" object:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enableScroll" object:self];
}

@end
