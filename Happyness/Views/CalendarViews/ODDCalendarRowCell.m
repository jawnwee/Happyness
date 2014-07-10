//
//  ODDCalendarRowCell.m
//  Happyness
//
//  Created by John Lee on 6/25/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarRowCell.h"
#import "ODDCustomColor.h"
#import "ODDCalendarView.h"
#import "ODDHappyness.h"
#import "ODDHappynessEntry.h"
#import "ODDHappynessEntryStore.h"
#import "ODDCalendarTabImageView.h"

@interface ODDCalendarRowCell ()

@property (strong, nonatomic) NSDictionary *tabs;
@property (strong, nonatomic) NSDictionary *colors;

@end

@implementation ODDCalendarRowCell

- (id)initWithCalendar:(NSCalendar *)calendar reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithCalendar:calendar reuseIdentifier:reuseIdentifier];
    _tabs = [ODDCalendarTabImageView customCalendarImageDictionary];
    _colors = [ODDCustomColor customColorDictionary];
    if (!self) {
        return nil;
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/* Each row's background can be customized; needs both bottom and a top row */
- (UIImage *)backgroundImage;
{
    return [UIImage imageNamed:
                [NSString stringWithFormat:@"CalendarRow%@.png", self.bottomRow ? @"Bottom" : @""]];
}

- (void)configureOddLookCalendarTab:(UIButton *)button forDate:(NSDate *)date {
    // 100 is hardcoded into the super class button subview
    UIImageView *currentImageView = (UIImageView *)[button viewWithTag:100];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    NSString *key = [NSString stringWithFormat:@"%ld/%ld/%ld",
                     (long)[components year], (long)[components month], (long)[components day]];

    NSDictionary *entries = [[ODDHappynessEntryStore sharedStore] happynessEntries];
    ODDHappynessEntry *entry = [entries objectForKey:key];
    if (entry) {
        NSInteger value = [[entry happyness] value];
        NSString *string = [NSString stringWithFormat:@"oddLook_calendar_%ld", (long)value];
        [currentImageView setImage:[self.tabs objectForKey:string]];
    } else {
        [currentImageView setImage:nil];

    }
}

- (void)configureOddLookCalendarSelected:(UIButton *)button forDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    NSString *key = [NSString stringWithFormat:@"%ld/%ld/%ld",
                     (long)[components year], (long)[components month], (long)[components day]];

    NSDictionary *entries = [[ODDHappynessEntryStore sharedStore] happynessEntries];
    ODDHappynessEntry *entry = [entries objectForKey:key];
    ODDHappyness *happyness = [entry happyness];
    NSInteger value = [happyness value];
    if (entry) {
        NSString *key = [NSString stringWithFormat:@"oddLook_color_%ld", (long)value];
        button.backgroundColor = [self.colors objectForKey:key];
    } else {
        button.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0
                                                  blue:245.0 / 255.0 alpha:1.0];
    }
}

@end
