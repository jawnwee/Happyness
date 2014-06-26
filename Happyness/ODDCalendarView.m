//
//  ODDCalendarView.m
//  Happyness
//
//  Created by John Lee on 6/24/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarView.h"
#import "CKCalendarCell.h"
#import "ODDHappynessEntryStore.h"
#import "ODDHappynessEntry.h"
#import "ODDHappyness.h"

@implementation ODDCalendarView

///* Overriden method to implement cell changes in calendar */
//- (void)setCustomColorForThisMonthCell:(CKCalendarCell *)cell forDate:(NSDate *)date {
//    NSDateComponents *components = [[NSCalendar currentCalendar] components:
//                                    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
//                                                                   fromDate:date];
//    NSString *key = [NSString stringWithFormat:@"%ld/%ld/%ld",
//                     (long)[components year], (long)[components month], (long)[components day]];
//    NSDictionary *entries = [[ODDHappynessEntryStore sharedStore] happynessEntries];
//    ODDHappynessEntry *entry = [entries objectForKey:key];
//    ODDHappyness *happyness = [entry happyness];
//    if (!happyness) {
//        cell.normalBackgroundColor = [UIColor whiteColor];
//        // NSLog(@"key: %@ happynessEntry: %@", key, hap);
//    } else {
//        //cell.cellBorderColor = happyness.color;
//        cell.normalBackgroundColor = happyness.color;
//    }
//}


@end
