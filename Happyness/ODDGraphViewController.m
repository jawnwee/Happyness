//
//  ODDGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/21/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDGraphViewController.h"
#import "ODDHappynessEntryStore.h"
#import <QuartzCore/QuartzCore.h>

@interface ODDGraphViewController ()

@property (nonatomic,strong) IBOutlet UILabel *notEnoughDataLabel;

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _graphTitle = [[UILabel alloc] init];
        _notEnoughDataLabel = [[UILabel alloc] init];
        _graphAll = [UIButton buttonWithType:UIButtonTypeCustom];
        _graphMedium = [UIButton buttonWithType:UIButtonTypeCustom];
        _graphShortTerm = [UIButton buttonWithType:UIButtonTypeCustom];
        _topFrame = [[UIView alloc] init];
        _entries = [[ODDHappynessEntryStore sharedStore] sortedStore];
        _currentAmountOfData = ODDGraphAmountAll;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    [self initializeTopPortionOfFrame];
    [self initializeLabels];
    [self initializeButtons];
}

- (void)initializeLabels {
    CGRect rootFrame = self.view.frame;
    CGSize rootSize = rootFrame.size;
    self.graphTitle.frame = CGRectMake(rootSize.width / 10,
                                       0,
                                       rootSize.width / 2,
                                       rootSize.height / 8);
    self.graphTitle.text = @"Placeholder";
    CGFloat graphTitleFontSize = self.graphTitle.frame.size.height / 1.8;
    [self.graphTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:graphTitleFontSize]];
    self.graphTitle.textColor = [UIColor whiteColor];
    [self.view addSubview:self.graphTitle];
    
    self.notEnoughDataLabel.text = @"Not Enough Data :(";
    self.notEnoughDataLabel.frame = CGRectMake(rootSize.width / 4,
                                       rootSize.height / 4,
                                       rootSize.width / 2,
                                       rootSize.height / 2);
    [self.notEnoughDataLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:graphTitleFontSize]];
    self.notEnoughDataLabel.textColor = [UIColor blackColor];
    self.notEnoughDataLabel.textAlignment = NSTextAlignmentCenter;
    if (self.entries.count == 0) {
        [self.view addSubview:self.notEnoughDataLabel];
    }
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
    self.graphAll.backgroundColor = [UIColor whiteColor];
    self.graphMedium.backgroundColor = [UIColor clearColor];
    self.graphShortTerm.backgroundColor = [UIColor clearColor];
    CGFloat buttonFontSize = self.graphAll.frame.size.height / 3;
    [self.graphAll.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light"
                                                      size:buttonFontSize]];
    [self.graphMedium.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light"
                                                         size:buttonFontSize]];
    [self.graphShortTerm.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light"
                                                            size:buttonFontSize]];
    [self.graphAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.graphMedium setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.graphShortTerm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.graphAll setTitle:@"All" forState:UIControlStateNormal];
    [self.graphMedium setTitle:@"30 Days" forState:UIControlStateNormal];
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
    self.graphAll.backgroundColor = [UIColor clearColor];
    self.graphMedium.backgroundColor = [UIColor clearColor];
    self.graphShortTerm.backgroundColor = [UIColor whiteColor];
    [self.graphAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.graphMedium setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.graphShortTerm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)graphMedium:(id)sender {
    self.graphAll.backgroundColor = [UIColor clearColor];
    self.graphMedium.backgroundColor = [UIColor whiteColor];
    self.graphShortTerm.backgroundColor = [UIColor clearColor];
    [self.graphAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.graphMedium setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.graphShortTerm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)graphAll:(id)sender {
    self.graphAll.backgroundColor = [UIColor whiteColor];
    self.graphMedium.backgroundColor = [UIColor clearColor];
    self.graphShortTerm.backgroundColor = [UIColor clearColor];
    [self.graphAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.graphMedium setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.graphShortTerm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

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
