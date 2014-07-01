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

- (id)initWithElements:(NSArray *)elements withFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _labels = [[NSMutableArray alloc] initWithCapacity:elements.count];
        for (NSString *labelTitle in elements) {
            UILabel *newLabel = [[UILabel alloc] init];
            newLabel.text = labelTitle;
            newLabel.adjustsFontSizeToFitWidth = YES;
            newLabel.shadowColor = [UIColor blackColor];
            newLabel.shadowOffset = CGSizeMake(0, 1);
            newLabel.backgroundColor = [UIColor clearColor];
            newLabel.textAlignment = NSTextAlignmentCenter;
            CGFloat fontSize = frame.size.width / 2;
            [newLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize]];
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
    CGContextMoveToPoint(context, self.bounds.size.width, 0.0f);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
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
