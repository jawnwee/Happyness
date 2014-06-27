//
//  ODDHappynessEntryView.m
//  Happyness
//
//  Created by John Lee on 6/17/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDHappynessEntryView.h"
#import "ODDHappynessEntry.h"
#import "ODDHappyness.h"
#import "ODDNote.h"

@interface ODDHappynessEntryView ()

@end
@implementation ODDHappynessEntryView

+ (instancetype)createHappynessEntryView {
    ODDHappynessEntryView *happynessEntry = [[[NSBundle mainBundle]
                                              loadNibNamed:@"ODDHappynessEntryView"
                                              owner:nil options:nil] lastObject];
    if (happynessEntry) {
        return happynessEntry;
    }
    return nil;
}

- (void)setHappynessEntry:(ODDHappynessEntry *)happynessEntry {
    NSDate *entryDate = [happynessEntry date];
    ODDNote *note = [happynessEntry note];
    ODDHappyness *happyness = [happynessEntry happyness];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:entryDate];

    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    self.day.text = [dateFormatter stringFromDate:entryDate];

    self.happynessNote.text = note.noteString;
    [self.happynessNote sizeToFit];

    self.date.text = [NSString stringWithFormat:@"%ld", (long)day];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
