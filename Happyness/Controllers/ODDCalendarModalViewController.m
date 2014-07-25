//
//  ODDCalendarModalViewController.m
//  Happyness
//
//  Created by John Lee on 7/24/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarModalViewController.h"
#import "ODDHappynessHeader.h"
#import "ODDSelectionModalViewController.h"
#import "ODDPresentingAnimator.h"
#import "ODDDismissingAnimator.h"

@interface ODDCalendarModalViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation ODDCalendarModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeHappynessButton];
}

- (void)changeHappynessButton {
    UIButton *changeHappyness = [UIButton buttonWithType:UIButtonTypeCustom];
    changeHappyness.translatesAutoresizingMaskIntoConstraints = NO;

    [changeHappyness setImage:[UIImage imageNamed:@"change_happyness.png"]
                   forState:UIControlStateNormal];

    [changeHappyness addTarget:self
                      action:@selector(updateHappyness)
            forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:changeHappyness];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:changeHappyness
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.f
                                                           constant:-30.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:changeHappyness
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.0]];
}

- (void)updateHappyness {
    ODDSelectionModalViewController *cardsViewController =
            [[ODDSelectionModalViewController alloc] initWithHappynessEntry:self.selectedHappyness];
    cardsViewController.selectedDate = self.selectedDate;

    UIView *cardsView = cardsViewController.view;
    CGRect adjustBounds = cardsView.frame;
    adjustBounds.origin.y += 50.0f;
    cardsView.frame = adjustBounds;
    cardsView.layer.cornerRadius = 8.0f;
    cardsViewController.view = cardsView;

    cardsViewController.transitioningDelegate = self;
    cardsViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:cardsViewController
                       animated:YES
                     completion:NULL];
    
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [ODDPresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.selectedHappyness = ((ODDSelectionModalViewController *)dismissed).currentEntry;
    return [ODDDismissingAnimator new];
}

@end
