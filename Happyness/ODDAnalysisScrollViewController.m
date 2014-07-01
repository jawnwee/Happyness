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
        UIImage *analysisScrollSelected = [UIImage imageNamed:@"GraphTabSelected60.png"];
        UIImage *analysisScrollUnselected = [UIImage imageNamed:@"GraphTabUnselected60.png"];
        analysisScrollSelected = [analysisScrollSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        analysisScrollUnselected = [analysisScrollUnselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *analysisScrollTabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:analysisScrollUnselected selectedImage:analysisScrollSelected];
        self.tabBarItem = analysisScrollTabBarItem;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scroll View Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    // Variables below used for autolayout.
    // Everything should depend on the rootFrame and tabBarFrame
    CGRect rootFrame = self.view.bounds;
    CGSize rootSize = rootFrame.size;
    CGRect tabBarFrame = self.tabBarController.tabBar.frame;
    CGSize tabBarSize = tabBarFrame.size;
    CGPoint tabBarPosition = tabBarFrame.origin;
    NSUInteger numberOfScreens = 2;
	
    // Initialize and add custom scroll view
    CGRect scrollFrame = CGRectMake(0, 0, rootSize.width, rootSize.height);
    self.scrollView = [[ODDAnalysisScrollView alloc] initWithFrame:scrollFrame];
    self.scrollView.contentSize = CGSizeMake(rootSize.width * numberOfScreens, rootSize.height);
    [self.scrollView setPagingEnabled:YES];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    // Initialize and add AnalysisView and LandscapeAnalysisView to scroll view
    self.analysis = [[ODDAnalysisViewController alloc] init];
    self.landscapeAnalysis = [[ODDLandscapeAnalysisViewController alloc] init];
    CGRect landscapeFrame = self.landscapeAnalysis.view.frame;
    landscapeFrame.origin.x = rootSize.width;
    landscapeFrame.origin.y = 0;
    self.landscapeAnalysis.view.frame = landscapeFrame;
    [self.scrollView addSubview:self.analysis.view];
    [self.scrollView addSubview:self.landscapeAnalysis.view];
    
    // Initialize and add page control
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(tabBarPosition.x,
                                        tabBarPosition.y - (tabBarSize.height / 3),
                                        tabBarSize.width,
                                        tabBarSize.height / 3);
    self.pageControl.numberOfPages = numberOfScreens;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.userInteractionEnabled = NO;
    [self.view addSubview:self.pageControl];
    
    // Set up notification detection for when device rotates
    // Needed to properly hide dotes on LandscapeAnalysisView
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:[UIDevice currentDevice]];
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
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationSlide];
    } else {
        self.tabBarController.tabBar.hidden = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:UIStatusBarAnimationSlide];
        if (UIInterfaceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            [UIView transitionWithView:self.pageControl
                              duration:0.17
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished){
                                if (finished) {
                                    [UIView transitionWithView:self.landscapeAnalysis.pageControl
                                                      duration:0.17
                                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                                    animations:nil
                                                    completion:nil];
                                    self.landscapeAnalysis.pageControl.hidden = NO;
                                }
                            }];
            self.pageControl.hidden = YES;

        }
    }
}

#pragma mark - Hide page control dots

- (void)viewWillAppear:(BOOL)animated {
    if (self.pageControl.currentPage == 0) {
        self.landscapeAnalysis.pageControl.hidden = YES;
    }
}

- (void)orientationChanged:(NSNotification *)notification {
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (self.pageControl.currentPage == 1) {
        if (UIInterfaceOrientationLandscapeRight == deviceOrientation) {
            [UIView transitionWithView:self.pageControl
                              duration:0.17
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished){
                                if (finished) {
                                    [UIView transitionWithView:self.landscapeAnalysis.pageControl
                                                      duration:0.17
                                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                                    animations:nil
                                                    completion:nil];
                                    self.landscapeAnalysis.pageControl.hidden = NO;
                                }
                            }];
            self.pageControl.hidden = YES;
        } else if (UIInterfaceOrientationIsPortrait(deviceOrientation)) {
            [UIView transitionWithView:self.landscapeAnalysis.pageControl
                              duration:0.17
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished){
                                if (finished) {
                                    [UIView transitionWithView:self.pageControl
                                                      duration:0.17
                                                       options:UIViewAnimationOptionTransitionCrossDissolve
                                                    animations:nil
                                                    completion:nil];
                                    self.pageControl.hidden = NO;
                                }
                            }];
            self.landscapeAnalysis.pageControl.hidden = YES;
        }
    }
}

@end
