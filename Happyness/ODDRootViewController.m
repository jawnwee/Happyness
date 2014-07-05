//
//  ODDRootViewController.m
//  Happyness
//
//  Created by Yujun Cho on 7/5/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDRootViewController.h"
#import "ODDRootScrollView.h"

#define SCROLLVIEW_HEIGHT_RATIO     3/5
#define PAGECONTROL_HEIGHT_RATIO    1/8

@interface ODDRootViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) ODDRootScrollView *scrollView;
// Name clear enough?
// TODO: create a class for this
@property (nonatomic, strong) id bottomViewController;

@property NSUInteger numberOfPages;

@end

@implementation ODDRootViewController

@synthesize viewControllers = _viewControllers;

#pragma mark - Alloc/Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - Subviews Layout

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScrollView];
    [self setupPageControl];
}

- (void)setupScrollView {
    CGSize rootViewSize = self.view.frame.size;
    CGSize scrollViewSize = CGSizeMake(rootViewSize.width,
                                       rootViewSize.height * SCROLLVIEW_HEIGHT_RATIO);
    CGRect scrollViewFrame = CGRectMake(0,
                                       0,
                                       scrollViewSize.width,
                                       scrollViewSize.height);
    self.scrollView = [[ODDRootScrollView alloc] initWithFrame:scrollViewFrame];
    self.scrollView.contentSize = CGSizeMake(scrollViewSize.width * self.numberOfPages,
                                             scrollViewSize.height);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor darkGrayColor];
    [self addViewsToScrollView];
    [self.view addSubview:self.scrollView];
}

- (void)addViewsToScrollView {
    for (NSUInteger i = 0; i < self.numberOfPages; i++) {
        UIViewController *newViewController = (UIViewController *)self.viewControllers[i];
        UIView *newView = newViewController.view;
        CGRect newViewFrame = newView.frame;
        newViewFrame.origin.x += self.scrollView.frame.size.width * i;
        newViewController.view.frame = newViewFrame;
        [self.scrollView addSubview:((UIViewController *)self.viewControllers[i]).view];
    }
}

- (void)setupPageControl {
    CGSize rootViewSize = self.view.frame.size;
    CGSize pageControlSize = CGSizeMake(rootViewSize.width,
                                        self.scrollView.frame.size.height * PAGECONTROL_HEIGHT_RATIO);
    CGRect pageControlFrame = CGRectMake(0,
                                         self.scrollView.frame.size.height - pageControlSize.height,
                                         pageControlSize.width,
                                         pageControlSize.height);
    self.pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    self.pageControl.numberOfPages = self.numberOfPages;
    self.pageControl.currentPage = 0;
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.pageControl];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Setters

- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    self.numberOfPages = viewControllers.count;
}

@end
