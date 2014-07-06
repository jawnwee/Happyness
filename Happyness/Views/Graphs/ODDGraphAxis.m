//
//  ODDGraphAxis.m
//  Happyness
//
//  Created by Yujun Cho on 7/1/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDGraphAxis.h"

@implementation ODDGraphAxis
@synthesize labels = _labels;

- (id)initWithElements:(NSArray *)elements withFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _labels = [[NSMutableArray alloc] initWithCapacity:elements.count];
        for (NSString *labelTitle in elements) {
            UILabel *newLabel = [[UILabel alloc] init];
            newLabel.text = labelTitle;
            newLabel.adjustsFontSizeToFitWidth = YES;
            newLabel.textAlignment = NSTextAlignmentCenter;
            newLabel.backgroundColor = [UIColor clearColor];
            //            CGFloat fontSize = frame.size.height / 2;
            [newLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
            [self addSubview:newLabel];
            [_labels addObject:newLabel];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithElements:@[] withFrame:frame];
    if (self) {
        
    }
    return self;
}

@end
