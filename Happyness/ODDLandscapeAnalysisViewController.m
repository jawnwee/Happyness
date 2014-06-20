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

    CGRect landscapeFrame = CGRectMake(0, 0, 568, 320);
    self.view.frame = landscapeFrame;
    self.view.transform = CGAffineTransformMakeRotation( ( 180 * M_PI ) / 360 );
    
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
    self.firstGraph = [[ODDLineGraphViewController alloc] init];
    self.firstGraph.view.backgroundColor = [UIColor whiteColor];
    CGRect firstGraphFrame = self.firstGraph.view.frame;
    firstGraphFrame.origin.x = 0;
    firstGraphFrame.origin.y = 0;
    self.firstGraph.view.frame = firstGraphFrame;
    self.secondGraph = [[ODDBarGraphViewController alloc] init];
    self.secondGraph.view.backgroundColor = [UIColor lightGrayColor];
    CGRect secondGraphFrame = self.secondGraph.view.frame;
    secondGraphFrame.origin.x = 568;
    secondGraphFrame.origin.y = 0;
    self.secondGraph.view.frame = secondGraphFrame;
    [self.scrollView addSubview:self.firstGraph.view];
    [self.scrollView addSubview:self.secondGraph.view];

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

@end
