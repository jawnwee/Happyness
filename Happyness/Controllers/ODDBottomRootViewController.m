//
//  ODDBottomRootViewController.m
//  Happyness
//
//  Created by John Lee on 7/7/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDBottomRootViewController.h"
#import "POP.h"

@interface ODDBottomRootViewController ()

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic)         NSInteger currentPage;

@end

@implementation ODDBottomRootViewController

/* This init is loading the first scroll view's bottom screen; for some reason
 viewDidLoad gets called before this init and the viewControllers array is empty
 so this is loaded here */
- (instancetype)initWithViewControllers:(NSArray *)bottomViewControllers {
    self = [super init];
    if (self) {
        CGRect frame = self.view.frame;
        frame.origin.y += (frame.size.height * SCROLLVIEW_HEIGHT_RATIO);
        self.view.frame = frame;
        _viewControllers = bottomViewControllers;
        [self.view addSubview:[[self.viewControllers objectAtIndex:0] view]];
        _currentPage = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView:(NSInteger)index {
    UIView *current = [[self.viewControllers objectAtIndex: self.currentPage] view];
    UIView *incoming = [[self.viewControllers objectAtIndex:index] view];
    CGRect adjustedFrame = incoming.frame;

    if (index > self.currentPage) {

        adjustedFrame.origin.x += 420;
        incoming.frame = adjustedFrame;
        [self animate:current nextView:incoming toRight:NO];
    } else if (index < self.currentPage) {
        adjustedFrame.origin.x -= 420;
        incoming.frame = adjustedFrame;
        [self animate:current nextView:incoming toRight:YES];
    }
    self.currentPage = index;
}

- (void)animate:(UIView *)currentView nextView:(UIView *)incomingView toRight:(BOOL)isMovingRight {

    CGRect resultFrame = currentView.frame;

    POPSpringAnimation *onScreenAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    onScreenAnimation.toValue = [NSValue valueWithCGRect:resultFrame];
    onScreenAnimation.springBounciness = 5.0f;
    CGRect leaveToFrame = currentView.frame;

    if (isMovingRight) {
        leaveToFrame.origin.x += 420.0;
    } else {
        leaveToFrame.origin.x -= 420.0;
    }

    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation easeInAnimation];
    offscreenAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    offscreenAnimation.toValue = [NSValue valueWithCGRect:leaveToFrame];
    offscreenAnimation.duration = 0.3f;

    [onScreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [currentView removeFromSuperview];
        incomingView.frame = resultFrame;
    }];
    [currentView pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];

    [self.view addSubview:incomingView];
    [incomingView pop_addAnimation:onScreenAnimation forKey:@"onscreenAnimation"];

}

@end
