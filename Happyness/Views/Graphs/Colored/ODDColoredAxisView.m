//
//  ODDColoredAxisView.m
//  Happyness
//
//  Created by Yujun Cho on 7/5/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDColoredAxisView.h"

@implementation ODDColoredAxisView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.frame.size.width);
    for (NSUInteger i = 0; i < 5; i++) {
        CGContextSetStrokeColorWithColor(context, [self chooseColorForNumber:i].CGColor);
        CGContextMoveToPoint(context, CGRectGetMidX(self.bounds), i * (self.bounds.size.height / 5));
        CGContextAddLineToPoint(context,
                                CGRectGetMidX(self.bounds),
                                (i + 1) * (self.bounds.size.height / 5));
        CGContextStrokePath(context);
    }
}

- (UIColor *)chooseColorForNumber:(NSUInteger)number {
    return [super chooseColorForNumber:number];
}

@end
