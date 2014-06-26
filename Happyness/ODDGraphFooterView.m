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

- (id)initWithElements:(NSArray *)elements withFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _labels = [[NSMutableArray alloc] initWithCapacity:elements.count];
        for (NSString *labelTitle in elements) {
            UILabel *newLabel = [[UILabel alloc] init];
            newLabel.text = labelTitle;
            newLabel.adjustsFontSizeToFitWidth = YES;
            newLabel.textAlignment = NSTextAlignmentRight;
            newLabel.shadowColor = [UIColor blackColor];
            newLabel.shadowOffset = CGSizeMake(0, 1);
            newLabel.backgroundColor = [UIColor clearColor];
            newLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:newLabel];
            [_labels addObject:newLabel];
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 2.0f);
    CGContextMoveToPoint(context, 0.0f, 0.0f);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0.0f);
    CGContextStrokePath(context);
}

- (void)layoutSubviews {
    CGFloat width = ceil(self.bounds.size.width / self.labels.count);
    CGRect lastFrame = CGRectMake(0, 0, 0, 0);
    NSUInteger count = 0;
    for (UILabel *label in self.labels) {
        label.frame = CGRectMake(CGRectGetMaxX(lastFrame), 0, width, self.bounds.size.height);
        lastFrame = label.frame;
        count++;
    }
}

@end
