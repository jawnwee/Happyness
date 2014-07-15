//
//  ODDColoredView.m
//  Happyness
//
//  Created by Yujun Cho on 7/10/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDColoredView.h"
#import "ODDCustomColor.h"

@interface ODDColoredView ()

@property (nonatomic, strong) NSDictionary *colors;

@end

@implementation ODDColoredView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _colors = [ODDCustomColor customColorDictionary];
    }
    return self;
}

- (UIColor *)chooseColorForNumber:(NSUInteger)number {
    switch (number) {
        case 0:
            return self.colors[@"oddLook_color_5"];
        case 1:
            return self.colors[@"oddLook_color_4"];
        case 2:
            return self.colors[@"oddLook_color_3"];
        case 3:
            return self.colors[@"oddLook_color_2"];
        case 4:
            return self.colors[@"oddLook_color_1"];
        default:
            return [UIColor blackColor];
    }
}

@end
