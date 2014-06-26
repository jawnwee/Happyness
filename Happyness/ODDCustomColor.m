//
//  ODDCustomColor.m
//  Happyness
//
//  Created by John Lee on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
// purple, pink, blue, green yellow


#import "ODDCustomColor.h"

@implementation ODDCustomColor

+ (UIColor *)customRedColor {
    return [UIColor colorWithRed:230.0 / 255.0 green:74.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customGreenColor {
    return [UIColor colorWithRed:78.0 /255.0 green:215.0 / 255.0 blue:92.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customBlueColor {
    return [UIColor colorWithRed:0.0 green:117.0 / 255.0 blue:189.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customMagentaColor {
    return [UIColor colorWithRed:152.0 / 255.0 green:91.0 / 255.0 blue:178.0 / 255.0 alpha:1.0];
}

+ (UIColor *)customPurpleColor {
    return [UIColor colorWithRed:84.0 / 255.0 green:96 / 255.0 blue:122.0 / 255.0 alpha:1.0];
}

+ (NSDictionary *)customColorDictionary {
    NSDictionary *oddLookColors = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [self customRedColor], @"oddLook_color_1",
                                   [self customGreenColor], @"oddLook_color_2",
                                   [self customBlueColor], @"oddLook_color_3",
                                   [self customMagentaColor], @"oddLook_color_4",
                                   [self customPurpleColor], @"oddLook_color_5",
                                   nil];
    return oddLookColors;
}


@end
