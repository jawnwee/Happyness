//
//  ODDNoteModalViewController.m
//  Happyness
//
//  Created by John Lee on 7/23/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDNoteModalViewController.h"
#import "ODDHappynessHeader.h"

@interface ODDNoteModalViewController () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ODDNoteModalViewController

@synthesize text = _text;

- (void)viewDidLoad {
    UIView *windowView = (UIView *)([[UIApplication sharedApplication] windows].firstObject);
    CGRect windowFrame = windowView.frame;
    CGRect frame;
    if (IS_IPHONE_5) {
        frame = CGRectMake(0.0, 0.0,
                           windowFrame.size.width - 40.0,
                           windowFrame.size.height * SCROLLVIEW_HEIGHT_RATIO - 30.0);
    } else {
        frame = CGRectMake(0.0, 15.0,
                           windowFrame.size.width - 40.0,
                           windowFrame.size.height * SCROLLVIEW_HEIGHT_RATIO - 90.0);
    }
    self.view = [[UIView alloc] initWithFrame:frame];

    // This frame is adjusted for the text view frame
    frame.size.height -= 70.0;

    _textView = [[UITextView alloc] initWithFrame:frame];
    _textView.delegate = self;
    if ([self.text isEqualToString:@""] || !self.text) {
        _textView.text = @"Hey! How was your day today?";
        _textView.textColor = [UIColor lightGrayColor];
    } else {
        _textView.text = self.text;
    }
    _textView.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
    _textView.layer.cornerRadius = 8.f;
    [self.view addSubview: _textView];
    self.view.layer.cornerRadius = 8.f;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addDismissButton];
    [self addClearButton];
}

#pragma mark - Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Hey! How was your day today?"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Hey! How was your day today?";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

#pragma mark - Private Instance methods

- (void)addDismissButton
{
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;

    [dismissButton setImage:[UIImage imageNamed:@"complete_note.png"] 
                   forState:UIControlStateNormal];

    [dismissButton addTarget:self 
                      action:@selector(submit:)
            forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:dismissButton];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dismissButton
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.f
                                                           constant:-32.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dismissButton
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.f
                                                           constant:-15.f]];

}

- (void)addClearButton {

    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.translatesAutoresizingMaskIntoConstraints = NO;

    [clearButton setImage:[UIImage imageNamed:@"clear_note.png"]
                   forState:UIControlStateNormal];

    [clearButton addTarget:self
                      action:@selector(dismissNote)
            forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:clearButton];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:clearButton
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.f
                                                           constant:-32.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:clearButton
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.f
                                                           constant:15.f]];
}

- (void)dismissNote {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)submit:(id)sender
{
    if ([self.textView.text isEqualToString:@"Hey! How was your day today?"]) {
        _text = @"";
    } else {
        _text = self.textView.text;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
