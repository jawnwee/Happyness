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

@property (nonatomic, strong) NSMutableDictionary *feedbackData;

@end

@implementation ODDHappynessObserver

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString* filepath = [[NSBundle mainBundle]pathForResource:@"feedbackQuotations" ofType:@"JSON"];

        NSData *allFeedbackData = [[NSData alloc] initWithContentsOfFile:filepath];
        NSError *error;
        _feedbackData = [NSJSONSerialization JSONObjectWithData:allFeedbackData 
                                                        options:NSJSONReadingMutableContainers 
                                                          error:&error];
    }
    return self;
}

/* Returns a feedback message */
- (NSString *)analyzePastDays {
    NSArray *entries = [[ODDHappynessEntryStore sharedStore] sortedStore];
    NSString *message;

    // pastDays: index 0 is most recent entry
    NSInteger numDays = 2;
    NSMutableArray *pastDays = [NSMutableArray arrayWithCapacity:numDays];

    for (int i = 0; i < numDays; i++) {
        ODDHappynessEntry *entry = [entries objectAtIndex:entries.count - 1 - i];
        ODDHappyness *happyness = entry.happyness;
        [pastDays addObject:[NSNumber numberWithInteger:[happyness.value intValue]]];
    }

    // Entries get older as they increase; rating1 is most recent entry
    NSInteger rating1 = [[pastDays objectAtIndex:0] integerValue];
    NSInteger rating2 = [[pastDays objectAtIndex:numDays - 1] integerValue];
    NSInteger pairValue = (0.5 * (rating1 + rating2) * (rating1 + rating2 + 1)) + rating2;
    NSString *key = [@(pairValue) stringValue];
    message = [self.feedbackData objectForKey:key];
    return message;
}

@end
