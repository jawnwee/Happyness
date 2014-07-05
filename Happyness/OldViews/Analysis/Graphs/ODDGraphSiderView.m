//
//  ODDGraphSiderView.m
//  Happyness
//
//  Created by Yujun Cho on 6/24/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDGraphSiderView.h"

@interface ODDGraphSiderView ()

@property (nonatomic,strong) NSMutableArray *labels;

@end

@implementation ODDGraphSiderView
@synthesize isLeftSide = _isLeftSide;

- (id)initWithElements:(NSArray *)elements withFrame:(CGRect)frame {
    self = [super initWithElements:elements withFrame:frame];
    if (self) {
        _isLeftSide = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 2.0f);
    if (self.isLeftSide) {
        CGContextMoveToPoint(context, self.bounds.size.width, 0.0f);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    } else {
        CGContextMoveToPoint(context, 0.0f, 0.0f);
        CGContextAddLineToPoint(context, 0.0f, self.bounds.size.height);
    }
    CGContextStrokePath(context);
}

- (void)layoutSubviews {
    CGFloat height = ceil(self.bounds.size.height / self.labels.count);
    CGRect lastFrame = CGRectMake(0, 0, 0, 0);
    NSUInteger count = 0;
    for (UILabel *label in self.labels) {
        label.frame = CGRectMake(0, CGRectGetMaxY(lastFrame), self.bounds.size.width, height);
        lastFrame = label.frame;
        count++;
    }
}


@end
