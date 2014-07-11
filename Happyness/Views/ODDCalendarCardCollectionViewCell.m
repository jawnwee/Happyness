//
//  ODDCalendarCardCollectionViewCell.m
//  Happyness
//
//  Created by John Lee on 7/9/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarCardCollectionViewCell.h"
#import "ODDHappynessHeader.h"

@implementation ODDCalendarCardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

/* To be added for notes, date positioning and faces (probably on card) */
- (void)setHappynessEntry:(ODDHappynessEntry *)happynessEntry {
    NSDate *entryDate = [happynessEntry date];
    ODDNote *note = [happynessEntry note];
    ODDHappyness *happyness = [happynessEntry happyness];
    NSInteger value = [happyness value];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:entryDate];

    NSInteger day = [components day];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];

    // Change this line when calendar cards are ready
    NSString *cardImage = [NSString stringWithFormat:@"oddLook_card_%ld", value];
    UIImage *card = [UIImage imageNamed:cardImage];
    self.backgroundView = [[UIImageView alloc] initWithImage:card];
}


@end
