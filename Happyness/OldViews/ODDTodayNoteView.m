//
//  ODDTodayNoteView.m
//  Happyness
//
//  Created by Matthew Chiang on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDTodayNoteView.h"

@implementation ODDTodayNoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpTextView];
    }
    return self;
}

// Set up textView
- (void)setUpTextView {
    self.isScrollable = NO;
    self.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);

    self.minNumberOfLines = 1;
    self.maxNumberOfLines = 6;
    self.returnKeyType = UIReturnKeyDone;
    self.font = [UIFont systemFontOfSize:15.0f];
    self.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.backgroundColor = [UIColor whiteColor];
    self.placeholder = @"Add a note about your day!";
//    self.animateHeightChange = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
