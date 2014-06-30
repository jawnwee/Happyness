//
//  ODDCalendarTabImageView.m
//  Happyness
//
//  Created by John Lee on 6/27/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarTabImageView.h"

@implementation ODDCalendarTabImageView

+ (UIImage *)customRedColor {
    UIImage *tab = [UIImage imageNamed:@"oddLook_calendar_1.png"];
    return tab;
}

+ (UIImage *)customGreenColor {
    UIImage *tab = [UIImage imageNamed:@"oddLook_calendar_2.png"];
    return tab;
}

+ (UIImage *)customBlueColor {
    UIImage *tab = [UIImage imageNamed:@"oddLook_calendar_3.png"];
    return tab;
}

+ (UIImage *)customMagentaColor {
    UIImage *tab = [UIImage imageNamed:@"oddLook_calendar_4.png"];
    return tab;
}

+ (UIImage *)customPurpleColor {
    UIImage *tab = [UIImage imageNamed:@"oddLook_calendar_5.png"];
    return tab;
}

+ (NSDictionary *)customCalendarImageDictionary {

    UIImage *first = [self customRedColor];
    UIImage *second = [self customGreenColor];
    UIImage *third = [self customBlueColor];
    UIImage *fourth = [self customMagentaColor];
    UIImage *fifth = [self customPurpleColor];

    NSDictionary *oddCalendarTabs = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     first, @"oddLook_calendar_1",
                                     second, @"oddLook_calendar_2",
                                     third, @"oddLook_calendar_3",
                                     fourth, @"oddLook_calendar_4",
                                     fifth, @"oddLook_calendar_5",
                                     nil];
    return oddCalendarTabs;
}

@end
