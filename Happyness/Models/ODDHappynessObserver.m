//
//  ODDHappynessObserver.m
//  Happyness
//
//  Created by Matthew Chiang on 7/10/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDHappynessObserver.h"
#import "ODDHappynessEntryStore.h"
#import "ODDHappynessEntry.h"
#import "ODDHappyness.h"

@interface ODDHappynessObserver ()

@end

@implementation ODDHappynessObserver

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)analyzePastDays {
    NSArray *entries = [[[ODDHappynessEntryStore sharedStore] happynessEntries] allValues];
    NSString *message;

    // pastDays: index 0 is most recent entry
    NSInteger numDays = 2;
    NSMutableArray *pastDays = [NSMutableArray arrayWithCapacity:numDays];

    for (int i = 0; i < numDays; i++) {
        ODDHappynessEntry *entry = [entries objectAtIndex:entries.count - 1 - i];
        ODDHappyness *happyness = entry.happyness;
        [pastDays addObject:[NSNumber numberWithInteger:happyness.rating]];
    }

    // Entries get older as they increase; 1 is most recent entry
    NSInteger rating1 = [[pastDays objectAtIndex:0] integerValue];
    NSInteger rating2 = [[pastDays objectAtIndex:numDays - 1] integerValue];
    if (rating1 == rating2) {
        if (rating1 == 0) {
            message = @"You've been very sad. Get happier by drinking Capri Sun!";
        } else if (rating1 == 25) {
            message = @"You've been sad lately. Bagel bites!";
        } else if (rating1 == 50) {
            message = @"Neutral isn't always good. Lunchables!";
        } else if (rating1 == 75) {
            message = @"Doing good, keep it up!";
        } else {
            message = @"Everything is awesome!!!";
        }
    } else if (rating1 < rating2) {
        message = @"You've become happier over the past few days. Keep it up!";
    } else {
        message = @"You've become sadder recently. Get back up on your feet!";
    }

    return message;
}

@end
