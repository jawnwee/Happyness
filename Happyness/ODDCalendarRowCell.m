//
//  ODDCalendarRowCell.m
//  Happyness
//
//  Created by John Lee on 6/25/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarRowCell.h"

@implementation ODDCalendarRowCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIImage *)backgroundImage;
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"CalendarRow%@.png", self.bottomRow ? @"Bottom" : @""]];
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
