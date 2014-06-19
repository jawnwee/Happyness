//
//  ODDLandscapeAnalysisViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/17/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDLandscapeAnalysisViewController.h"
#import "ODDStatisticsGraphViewController.h"
#import "ODDLandscapeAnalysisView.h"

@interface ODDLandscapeAnalysisViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

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

#pragma mark - Scroll View Logic

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initialize and add custom scroll view
    CGRect scrollFrame = CGRectMake(0, 0, 568, 320);
    self.scrollView = [[ODDLandscapeAnalysisView alloc] initWithFrame:scrollFrame];
    self.scrollView.contentSize = CGSizeMake(568 * 2, 320);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delaysContentTouches = NO;
    [self.view addSubview:self.scrollView];
    
    // Initialize and add StatisticsGraphViews to scroll view
    ODDStatisticsGraphViewController *firstGraph = [[ODDStatisticsGraphViewController alloc] init];
    firstGraph.view.backgroundColor = [UIColor blackColor];
    firstGraph.view.transform = CGAffineTransformMakeRotation( ( 180 * M_PI ) / 360 );
    CGRect firstGraphFrame = firstGraph.view.frame;
    firstGraphFrame.origin.x = 0;
    firstGraphFrame.origin.y = 0;
    firstGraph.view.frame = firstGraphFrame;
    ODDStatisticsGraphViewController *secondGraph = [[ODDStatisticsGraphViewController alloc] init];
    secondGraph.view.backgroundColor = [UIColor lightGrayColor];
    secondGraph.view.transform = CGAffineTransformMakeRotation( ( 180 * M_PI ) / 360 );
    CGRect secondGraphFrame = secondGraph.view.frame;
    secondGraphFrame.origin.x = 568;
    secondGraphFrame.origin.y = 0;
    secondGraph.view.frame = secondGraphFrame;
    [self.scrollView addSubview:firstGraph.view];
    [self.scrollView addSubview:secondGraph.view];

    // Initialize and add page control
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(0, 295, 568, 25);
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage = 0;
    self.pageControl.backgroundColor = [UIColor lightGrayColor];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
