//
//  ODDPresentingAnimator.m
//  Happyness
//
//  Created by John Lee on 7/23/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDPresentingAnimator.h"
#import "Pop.h"

@implementation ODDPresentingAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    fromView.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
    fromView.userInteractionEnabled = NO;

    UIView *window = (UIView *)([[UIApplication sharedApplication] windows].firstObject);

    UIView *dimmingView = [[UIView alloc] initWithFrame:window.frame];
    dimmingView.backgroundColor = [UIColor colorWithRed:84.0 / 255.0 green:84.0 / 255.0 blue:84.0 / 255.0 alpha:1];
    dimmingView.layer.opacity = 0.0;

    UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
//    toView.frame = CGRectMake(0,
//                              0,
//                              CGRectGetWidth(transitionContext.containerView.bounds) - 104.f,
//                              CGRectGetHeight(transitionContext.containerView.bounds) - 288.f);
    toView.center = CGPointMake(window.center.x, -window.center.y);

    [transitionContext.containerView addSubview:dimmingView];
    [transitionContext.containerView addSubview:toView];

    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(window.center.y - 90);
    positionAnimation.springBounciness = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [transitionContext completeTransition:YES];
    }];

    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.2, 1.4)];

    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.5);

    [toView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [toView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [dimmingView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}


@end
