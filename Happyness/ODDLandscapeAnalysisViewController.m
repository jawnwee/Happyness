//
//  ODDLandscapeAnalysisViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/17/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDLandscapeAnalysisViewController.h"
#import "ODDLandscapeAnalysisView.h"
#import "ODDLineGraphViewController.h"
#import "ODDBarGraphViewController.h"

@interface ODDLandscapeAnalysisViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) ODDLineGraphViewController *firstGraph;
@property (nonatomic,strong) ODDBarGraphViewController *secondGraph;

@end

@implementation ODDLandscapeAnalysisViewController
@synthesize pageControl = _pageControl;

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
    self.firstGraph = [[ODDLineGraphViewController alloc] init];
    CGRect firstGraphFrame = self.firstGraph.view.frame;
    firstGraphFrame.origin.x = 0;
    firstGraphFrame.origin.y = 0;
    self.firstGraph.view.frame = firstGraphFrame;
    self.firstGraph.graphTitle.text = @"Trending Happyness";
    self.secondGraph = [[ODDBarGraphViewController alloc] init];
    CGRect secondGraphFrame = self.secondGraph.view.frame;
    secondGraphFrame.origin.x = rootSize.width;
    secondGraphFrame.origin.y = 0;
    self.secondGraph.view.frame = secondGraphFrame;
    self.secondGraph.graphTitle.text = @"Daily Averages";
    [self.scrollView addSubview:self.firstGraph.view];
    [self.scrollView addSubview:self.secondGraph.view];

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
