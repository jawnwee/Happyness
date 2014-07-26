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
#import "ODDCustomColor.h"

@interface ODDCalendarModalViewController () <UIViewControllerTransitioningDelegate,
                                              UIAlertViewDelegate>

@end

@implementation ODDCalendarModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self deleteEntryButton];
}

- (void)deleteEntryButton {
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    deleteButton.backgroundColor = [UIColor whiteColor];
    deleteButton.translatesAutoresizingMaskIntoConstraints = NO;
    deleteButton.tintColor = [ODDCustomColor textColor];
    deleteButton.titleLabel.font = [UIFont fontWithName:@"GothamRounded-Bold" size:18];
    deleteButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [deleteButton setTitle:@"Delete Entry" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteEntry) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:deleteButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:-5.f]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:deleteButton
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.f
                                                           constant:-30.f]];


}

- (void)deleteEntry {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Happyness"
                                                    message:@"Are you sure you want to delete your entry?"
                                                   delegate:nil
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    alert.delegate = self;
    [alert show];
}


#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Yes"]) {
        ODDHappynessEntry *entry = self.selectedHappyness;
        [[ODDHappynessEntryStore sharedStore] removeEntry:entry];
        self.selectedHappyness = NULL;
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
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
