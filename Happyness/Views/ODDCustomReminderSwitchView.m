//
//  ODDCustomReminderSwitchView.m
//  Happyness
//
//  Created by Matthew Chiang on 7/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCustomReminderSwitchView.h"
#import "ODDCustomColor.h"

@interface ODDCustomReminderSwitchView ()

//@property (nonatomic, strong) UIView *slider;

@end

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
    self.slider = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              0, 
                                                              self.frame.size.width / 2 + 5,
                                                              self.frame.size.height)];
    self.slider.backgroundColor = [ODDCustomColor textColor];
    self.slider.layer.cornerRadius = 5.0f;
    [self addSubview:self.slider];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return self;
    }
    return nil;
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
