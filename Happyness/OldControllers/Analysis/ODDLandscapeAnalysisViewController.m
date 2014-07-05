//
//  ODDLandscapeAnalysisViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/17/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDLandscapeAnalysisViewController.h"
#import "ODDLandscapeAnalysisView.h"
#import "ODDCurveFittingViewController.h"
#import "ODDDayAveragesViewController.h"

@interface ODDLandscapeAnalysisViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) ODDLandscapeAnalysisView *scrollView;
@property (nonatomic,strong) ODDCurveFittingViewController *happynessTrends;
@property (nonatomic,strong) ODDDayAveragesViewController *dailyAverages;

@end

@implementation ODDLandscapeAnalysisViewController
@synthesize pageControl = _pageControl;

#pragma mark - Init/Alloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scroll View Setup

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Variables below used for autolayout.
    // Everything should depend on the rootFrame
    CGRect rootFrame = self.view.bounds;
    CGSize rootSize = rootFrame.size;
    NSUInteger numberOfScreens = 2;
    
    CGRect landscapeFrame = CGRectMake(0, 0, rootSize.height, rootSize.width);
    self.view.frame = landscapeFrame;
    self.view.transform = CGAffineTransformMakeRotation( ( 180 * M_PI ) / 360 );
    rootFrame = self.view.bounds;
    rootSize = rootFrame.size;
    
    // Initialize and add custom scroll view
    CGRect scrollFrame = CGRectMake(0, 0, rootSize.width, rootSize.height);
    self.scrollView = [[ODDLandscapeAnalysisView alloc] initWithFrame:scrollFrame];
    self.scrollView.contentSize = CGSizeMake(rootSize.width * numberOfScreens, rootSize.height);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delaysContentTouches = NO;
    [self.view addSubview:self.scrollView];
    
    // Initialize and add graphViews
    self.happynessTrends = [[ODDCurveFittingViewController alloc] init];
    CGRect happynessTrendsFrame = self.happynessTrends.view.frame;
    happynessTrendsFrame.origin.x = 0;
    happynessTrendsFrame.origin.y = 0;
    self.happynessTrends.view.frame = happynessTrendsFrame;
    self.happynessTrends.graphTitle.text = @"Trending Happyness";
    self.dailyAverages = [[ODDDayAveragesViewController alloc] init];
    CGRect dailyAveragesFrame = self.dailyAverages.view.frame;
    dailyAveragesFrame.origin.x = rootSize.width;
    dailyAveragesFrame.origin.y = 0;
    self.dailyAverages.view.frame = dailyAveragesFrame;
    self.dailyAverages.graphTitle.text = @"Daily Averages";
    self.dailyAverages.numberOfBars = 7;
    [self.scrollView addSubview:self.happynessTrends.view];
    [self.scrollView addSubview:self.dailyAverages.view];

    // Initialize and add page control
    self.pageControl = [[UIPageControl alloc] init];
    CGFloat pageControlHeightPadding = 25;
    self.pageControl.frame = CGRectMake(0,
                                        rootSize.height - pageControlHeightPadding,
                                        rootSize.width,
                                        pageControlHeightPadding);
    self.pageControl.numberOfPages = numberOfScreens;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.userInteractionEnabled = NO;
    [self.view addSubview:self.pageControl];
}

/*
 Handles page control logic such that the dots update with the correct current page
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

@end
