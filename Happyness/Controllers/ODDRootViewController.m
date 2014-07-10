//
//  ODDRootViewController.m
//  Happyness
//
//  Created by Yujun Cho on 7/5/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDRootViewController.h"
#import "ODDRootScrollView.h"

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
    self.scrollView.backgroundColor = [UIColor blackColor];
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
                                        PAGECONTROL_HEIGHT);
    CGRect pageControlFrame = CGRectMake(0,
                                         self.scrollView.frame.size.height - pageControlSize.height,
                                         pageControlSize.width,
                                         pageControlSize.height);
    self.pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    self.pageControl.numberOfPages = self.numberOfPages;
    self.pageControl.currentPage = 0;
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.backgroundColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    [self.view addSubview:self.pageControl];
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSUInteger currentPage = self.pageControl.currentPage;
    NSUInteger lastPage = self.numberOfPages - 1;
    if (self.numberOfPages > 1) {
        if (currentPage == 0) {
            UIViewController *currentController =
                                              (UIViewController *)self.viewControllers[currentPage];
            UIViewController *rightController = (UIViewController *)self.viewControllers[1];
            [rightController viewWillAppear:YES];
            [currentController viewWillDisappear:YES];
        } else if (currentPage == lastPage) {
            UIViewController *currentController =
                                             (UIViewController *)self.viewControllers[currentPage];
            UIViewController *leftController =
                                            (UIViewController *)self.viewControllers[lastPage - 1];
            [leftController viewWillAppear:YES];
            [currentController viewWillDisappear:YES];
        } else {
            UIViewController *currentController =
                                              (UIViewController *)self.viewControllers[currentPage];
            UIViewController *rightController =
                                          (UIViewController *)self.viewControllers[currentPage + 1];
            UIViewController *leftController =
                                          (UIViewController *)self.viewControllers[currentPage - 1];
            [rightController viewWillAppear:YES];
            [leftController viewWillAppear:YES];
            [currentController viewWillDisappear:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
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
