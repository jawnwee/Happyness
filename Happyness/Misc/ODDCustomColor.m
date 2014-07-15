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

+ (UIColor *)textColor {
    return [UIColor colorWithRed:68.0 / 255.0 green:73.0 / 255.0 blue:83.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customDarkYellowColor {
    return [UIColor colorWithRed:255.0 / 255.0 green:138.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customDarkTealColor {
    return [UIColor colorWithRed:0.0 / 255.0 green:179.0 / 255.0 blue:157.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customDarkBlueColor {
    return [UIColor colorWithRed:0.0 / 255.0 green:152.0 / 255.0 blue:232.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customDarkRedColor {
    return [UIColor colorWithRed:252.0 / 255.0 green:37.0 / 255.0 blue:24.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customDarkerDarkColor {
    return [UIColor colorWithRed:41.0 / 255.0 green:50.0 / 255.0 blue:75.0 / 255.0 alpha:1.0];
}

+ (NSDictionary *)customColorDictionary {
    NSDictionary *oddLookColors = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [self customTealColor], @"oddLook_color_5",
                                   [self customYellowColor], @"oddLook_color_4",
                                   [self customBlueColor], @"oddLook_color_3",
                                   [self customDarkColor], @"oddLook_color_2",
                                   [self customRedColor], @"oddLook_color_1",
                                   [self textColor], @"oddLook_textcolor",
                                   [self customDarkTealColor], @"oddLook_color_dark_5",
                                   [self customDarkYellowColor], @"oddLook_color_dark_4",
                                   [self customDarkBlueColor], @"oddLook_color_dark_3",
                                   [self customDarkerDarkColor], @"oddLook_color_dark_2",
                                   [self customDarkRedColor], @"oddLook_color_dark_1",
                                   nil];
    return oddLookColors;
}


@end
