//
//  ODDCustomColor.m
//  Happyness
//
//  Created by John Lee on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
// purple, pink, blue, green yellow


#import "ODDCustomColor.h"

@implementation ODDCustomColor

+ (UIColor *)customYellowColor {
    return [UIColor yellowColor];
}

+ (UIColor *)customGreenColor {
    return [UIColor greenColor];
}

+ (UIColor *)customBlueColor {
    return [UIColor blueColor];
}

+ (UIColor *)customMagentaColor {
    return [UIColor magentaColor];
}

+ (UIColor *)customPurpleColor {
    return [UIColor purpleColor];
}

+ (NSDictionary *)customColorDictionary {
    NSDictionary *oddLookColors = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"oddLook_color_1", [self customYellowColor],
                                   @"oddLook_color_2", [self customGreenColor],
                                   @"oddLook_color_3", [self customBlueColor],
                                   @"oddLook_color_4", [self customMagentaColor],
                                   @"oddLook_color_5", [self customPurpleColor],
                                   nil];
    return oddLookColors;
}


@end
