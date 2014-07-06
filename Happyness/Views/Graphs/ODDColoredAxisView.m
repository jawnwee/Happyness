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
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0f);
    for (NSUInteger i = 0; i < 5; i++) {
        CGContextSetStrokeColorWithColor(context, [self chooseColorForNumber:i].CGColor);
        CGContextMoveToPoint(context, self.bounds.size.width, i * (self.bounds.size.height / 5));
        CGContextAddLineToPoint(context, self.bounds.size.width, (i + 1) * (self.bounds.size.height / 5));
        CGContextStrokePath(context);
    }
}

- (UIColor *)chooseColorForNumber:(NSUInteger)number {
    switch (number) {
        case 0:
            return [UIColor greenColor];
        case 1:
            return [UIColor blueColor];
        case 2:
            return [UIColor yellowColor];
        case 3:
            return [UIColor purpleColor];
        case 4:
            return [UIColor redColor];
        default:
            return [UIColor blackColor];
    }
}

@end
