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
        _viewControllers = bottomViewControllers;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = self.view.frame;
    frame.origin.y += (frame.size.height * SCROLLVIEW_HEIGHT_RATIO);
    self.view.frame = frame;
    [self.view addSubview:[[self.viewControllers objectAtIndex:0] view]];
    CGRect adjustedFrame = [[self.viewControllers objectAtIndex:0] view].frame;
    adjustedFrame.origin.x += 420;
    for (int i = 1; i < [self.viewControllers count]; i++) {
        [[self.viewControllers objectAtIndex:i] view].frame = adjustedFrame;
        [self.view addSubview:[[self.viewControllers objectAtIndex:i] view]];
    }
    _currentPage = 0;
}

- (void)updateView:(NSInteger)index {
    UIView *current = [[self.viewControllers objectAtIndex: self.currentPage] view];
    UIView *incoming = [[self.viewControllers objectAtIndex:index] view];

    if (index > self.currentPage) {
        [self animate:current nextView:incoming toRight:NO];
    } else if (index < self.currentPage) {
        [self animate:current nextView:incoming toRight:YES];
    }
    self.currentPage = index;
}

- (void)animate:(UIView *)currentView nextView:(UIView *)incomingView toRight:(BOOL)isMovingRight {

    CGRect resultFrame = currentView.frame;

    POPSpringAnimation *onScreenAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    onScreenAnimation.toValue = [NSValue valueWithCGRect:resultFrame];
    onScreenAnimation.springBounciness = 3.0f;
    CGRect leaveToFrame = currentView.frame;

    if (isMovingRight) {
        leaveToFrame.origin.x += 420.0;
    } else {
        leaveToFrame.origin.x -= 420.0;
    }

    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation easeInAnimation];
    offscreenAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    offscreenAnimation.toValue = [NSValue valueWithCGRect:leaveToFrame];
    offscreenAnimation.duration = 0.2f;

    [onScreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        incomingView.frame = resultFrame;
    }];
    [currentView pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
    [incomingView pop_addAnimation:onScreenAnimation forKey:@"onscreenAnimation"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
