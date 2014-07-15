//
//  ODDColoredLinesView.m
//  Happyness
//
//  Created by Yujun Cho on 7/10/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDColoredLinesView.h"

@implementation ODDColoredLinesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 0.5);
    CGFloat linesWidth = 1.0f;
    CGContextSetLineWidth(context, linesWidth);
    for (NSUInteger i = 0; i < 5; i++) {
        CGContextSetStrokeColorWithColor(context, [self chooseColorForNumber:i].CGColor);
        CGContextMoveToPoint(context, 0, (i * (self.bounds.size.height / 5)) + (linesWidth / 2));
        CGContextAddLineToPoint(context,
                                self.bounds.size.width,
                                (i * (self.bounds.size.height / 5)) + (linesWidth / 2));
        CGContextStrokePath(context);
    }
}

- (UIColor *)chooseColorForNumber:(NSUInteger)number {
    return [super chooseColorForNumber:number];
}

@end
