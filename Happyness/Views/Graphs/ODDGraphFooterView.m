//
//  ODDGraphFooterView.m
//  Happyness
//
//  Created by Yujun Cho on 6/24/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDGraphFooterView.h"

@interface ODDGraphFooterView ()

@property (nonatomic,strong) NSMutableArray *labels;

@end

@implementation ODDGraphFooterView
@synthesize siderPadding = _siderPadding;
@synthesize isBarChart = _isBarChart;

- (id)initWithElements:(NSArray *)elements withFrame:(CGRect)frame {
    self = [super initWithElements:elements withFrame:frame];
    if (self) {
        _isBarChart = false;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 2.0f);
    CGContextMoveToPoint(context, 0.0f, 0.0f);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0.0f);
    CGContextStrokePath(context);
}

- (void)layoutSubviews {
    CGFloat graphWidth = self.frame.size.width - self.siderPadding - self.rightPadding;
    CGFloat xPositionPadding = ceil(graphWidth / self.labels.count);
    NSUInteger count = 0;
    for (UILabel *label in self.labels) {
        CGFloat width = ceil(graphWidth / self.labels.count);
        label.textAlignment = NSTextAlignmentCenter;
        if (self.isBarChart) {
            CGFloat barPaddingGuess = 4;
            CGFloat xPosition = self.siderPadding + (xPositionPadding * count) - barPaddingGuess;
            label.frame = CGRectMake(xPosition,
                                     0,
                                     width,
                                     self.bounds.size.height);
        } else {
            CGFloat xPositionPadding = ceil(graphWidth / (self.labels.count));
            if (self.labels.count > 1) {
                width = ceil((graphWidth / (self.labels.count - 1)));
                xPositionPadding = ceil(graphWidth / (self.labels.count - 1));
            }
            CGFloat xPosition = self.siderPadding + (xPositionPadding * count) - (width / 2);
            label.frame = CGRectMake(xPosition,
                                     0,
                                     width,
                                     self.bounds.size.height);
        }
        count++;
    }
}

- (void)setElements:(NSMutableArray *)elements {
    [super setElements:elements];
}

@end
