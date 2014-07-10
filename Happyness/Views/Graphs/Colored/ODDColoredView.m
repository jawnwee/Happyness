//
//  ODDColoredView.m
//  Happyness
//
//  Created by Yujun Cho on 7/10/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDColoredView.h"

@implementation ODDColoredView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
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
