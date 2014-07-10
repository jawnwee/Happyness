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
    return [UIColor colorWithRed:255.0 / 255.0 green:190.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customTealColor {
    return [UIColor colorWithRed:60.0 / 255.0 green:216.0 / 255.0 blue:199.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customBlueColor {
    return [UIColor colorWithRed:53.0 / 255.0 green:197.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customRedColor {
    return [UIColor colorWithRed:255.0 / 255.0 green:96.0 / 255.0 blue:90.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customDarkColor {
    return [UIColor colorWithRed:69.0 / 255.0 green:88.0 / 255.0 blue:102.0 / 255.0 alpha:1.0];
}

+ (NSDictionary *)customColorDictionary {
    NSDictionary *oddLookColors = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [self customTealColor], @"oddLook_color_1",
                                   [self customYellowColor], @"oddLook_color_2",
                                   [self customBlueColor], @"oddLook_color_3",
                                   [self customDarkColor], @"oddLook_color_4",
                                   [self customRedColor], @"oddLook_color_5",
                                   nil];
    return oddLookColors;
}


@end
