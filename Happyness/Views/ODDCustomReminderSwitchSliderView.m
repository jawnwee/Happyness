//
//  ODDCustomReminderSwitchSliderView.m
//  Happyness
//
//  Created by Matthew Chiang on 7/17/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCustomReminderSwitchSliderView.h"
#import "ODDCustomColor.h"

@interface ODDCustomReminderSwitchSliderView ()

@property (nonatomic) CGPoint currentPoint;

@end

@implementation ODDCustomReminderSwitchSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [ODDCustomColor textColor];
        self.layer.cornerRadius = 5.0f;
    }
    return self;
}

/* Dragging slider
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.currentPoint = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint activePoint = [[touches anyObject] locationInView:self];

    CGPoint newPoint = CGPointMake(self.center.x + (activePoint.x - self.currentPoint.x),
                                   self.center.y + (activePoint.y - self.currentPoint.y));

    // Stay within bounds of the switch
    float midPointX = CGRectGetMidX(self.bounds);
    if (newPoint.x > self.superview.bounds.size.width - midPointX) {
        newPoint.x = self.superview.bounds.size.width - midPointX;
    } else if (newPoint.x < midPointX) {
        newPoint.x = midPointX;
    }

    float midPointY = CGRectGetMidY(self.bounds);
    if (newPoint.y > self.superview.bounds.size.height - midPointY) {
        newPoint.y = self.superview.bounds.size.height - midPointY;
    } else if (newPoint.y < midPointY) {
        newPoint.y = midPointY;
    }
    self.center = newPoint;
}
*/

@end
