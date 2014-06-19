//
//  ODDAnalysisScrollViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/18/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDAnalysisScrollViewController.h"
#import "ODDAnalysisViewController.h"
#import "ODDLandscapeAnalysisViewController.h"
#import "ODDAnalysisScrollView.h"

@interface ODDAnalysisScrollViewController () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) ODDLandscapeAnalysisViewController *landscapeAnalysis;
@property (nonatomic,strong) ODDAnalysisViewController *analysis;

@end

@implementation ODDAnalysisScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Analysis";
    }
    return self;
}

#pragma mark - Scroll View logic

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize and add custom scroll view
    CGRect scrollFrame = CGRectMake(0, 0, 320, 568);
    self.scrollView = [[ODDAnalysisScrollView alloc] initWithFrame:scrollFrame];
    self.scrollView.contentSize = CGSizeMake(320 * 2, 568);
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // Initialize and add AnalysisView and LandscapeAnalysisView to scroll view
    self.analysis = [[ODDAnalysisViewController alloc] init];
    self.landscapeAnalysis = [[ODDLandscapeAnalysisViewController alloc] init];
    self.landscapeAnalysis.view.transform = CGAffineTransformMakeRotation( ( 180 * M_PI ) / 360 );
    CGRect landscapeFrame = self.landscapeAnalysis.view.frame;
    landscapeFrame.origin.x = 320;
    landscapeFrame.origin.y = 0;
    self.landscapeAnalysis.view.frame = landscapeFrame;
    [self.scrollView addSubview:self.analysis.view];
    [self.scrollView addSubview:self.landscapeAnalysis.view];
    
    // Initialize and add page control
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(0, 500, 320, 25);
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage = 0;
    self.pageControl.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.pageControl];
    
    // Set up notification detection for when device rotates
    // Needed to properly hide dotes on LandscapeAnalysisView
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.pageControl.currentPage == 0) {
        self.landscapeAnalysis.pageControl.hidden = YES;
    }
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

#pragma mark - Hide tab bar

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.pageControl.currentPage == 0) {
        self.tabBarController.tabBar.hidden = NO;
        self.pageControl.hidden = NO;
        self.landscapeAnalysis.pageControl.hidden = YES;
    } else {
        self.tabBarController.tabBar.hidden = YES;
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            self.pageControl.hidden = YES;
            self.landscapeAnalysis.pageControl.hidden = NO;
        }
    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (self.pageControl.currentPage == 0) {
//        self.tabBarController.tabBar.hidden = NO;
//    } else {
//        self.tabBarController.tabBar.hidden = YES;
//    }
//}

#pragma mark - Hide page control dots

- (void)orientationChanged:(NSNotification *)notification {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (self.pageControl.currentPage == 1) {
        if (UIInterfaceOrientationIsLandscape(deviceOrientation)) {
            self.landscapeAnalysis.pageControl.hidden = NO;
            self.pageControl.hidden = YES;
        } else if (UIInterfaceOrientationIsPortrait(deviceOrientation)) {
            self.landscapeAnalysis.pageControl.hidden = YES;
            self.pageControl.hidden = NO;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
