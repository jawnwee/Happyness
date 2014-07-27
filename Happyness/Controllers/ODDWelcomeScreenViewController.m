//
//  ODDWelcomeScreenViewController.m
//  Happyness
//
//  Created by John Lee on 7/17/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDWelcomeScreenViewController.h"
#import "ODDMainViewController.h"

@interface ODDWelcomeScreenViewController () <UIScrollViewDelegate, 
                                              UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) ODDMainViewController *mainVC;


@end

@implementation ODDWelcomeScreenViewController

#pragma mark - Initialization
- (instancetype)initWithMainController:(ODDMainViewController *)mainViewController {
    if (self = [super init]) {
        // Make some custom initializations
        _mainVC = mainViewController;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPageViews];
    [self setupPageControl];
}

- (void)setupPageViews {
    CGSize scrollSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.contentSize = CGSizeMake(scrollSize.width * 4, scrollSize.height);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self addWelcomeViews];
    [self.view addSubview:self.scrollView];
}

- (void)addWelcomeViews {
    for (int i = 0; i < 4; i++) {
        NSString *imageName = [NSString stringWithFormat:@"welcome_page_%d", i + 1];
        UIImage *image = [UIImage imageNamed: imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGRect adjustedFrame = imageView.frame;
        adjustedFrame.size.width *= 0.88;
        adjustedFrame.size.height *= 0.85;
        imageView.frame = adjustedFrame;

        imageView.center = CGPointMake(self.view.center.x + (i * self.view.frame.size.width),
                                       self.view.center.y);
        if (i == 3) {
            imageView.center = CGPointMake(self.view.center.x + (i * self.view.frame.size.width),
                                           self.view.center.y - imageView.frame.size.height / 2.5);
            UIButton *complete = [UIButton buttonWithType:UIButtonTypeCustom];
            CGRect completeFrame = CGRectMake(0, 0, 100, 50);
            complete.frame = completeFrame;
            [complete addTarget:self action:@selector(transitionToMain) 
               forControlEvents:UIControlEventTouchUpInside];
            complete.center = CGPointMake(imageView.center.x, imageView.center.y + 90.0);
            [complete setImage:[UIImage imageNamed:@"complete.png"] forState:UIControlStateNormal];
            [self.scrollView addSubview:complete];
        }
        [self.scrollView addSubview:imageView];
    }
}

- (void)setupPageControl {
    CGSize pageControlSize = CGSizeMake(self.view.frame.size.width, 40);
    CGRect frame = CGRectMake(0.0,
                                  self.scrollView.frame.size.height - pageControlSize.height,
                                      pageControlSize.width,
                                      pageControlSize.height);
    _pageControl = [[UIPageControl alloc] initWithFrame:frame];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    [self.view addSubview:self.pageControl];
}

#pragma mark - ScrollView Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

- (void)transitionToMain {
    self.mainVC.transitioningDelegate = self;
    self.mainVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:self.mainVC animated:YES completion: ^{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"tutorialComplete"];
        [[[UIApplication sharedApplication] delegate] window].rootViewController = self.mainVC;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
