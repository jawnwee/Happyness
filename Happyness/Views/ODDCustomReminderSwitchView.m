//
//  ODDCustomReminderSwitchView.m
//  Happyness
//
//  Created by Matthew Chiang on 7/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCustomReminderSwitchView.h"
#import "ODDCustomColor.h"

@implementation ODDCustomReminderSwitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)setup {
    self.layer.cornerRadius = 5.0f;
    self.backgroundColor = [ODDCustomColor customReminderOffColor];
    UIView *slider = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0, 
                                                              self.frame.size.width / 2 + 5,
                                                              self.frame.size.height)];
    slider.backgroundColor = [ODDCustomColor textColor];
    slider.layer.cornerRadius = 5.0f;
    [self addSubview:slider];
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
