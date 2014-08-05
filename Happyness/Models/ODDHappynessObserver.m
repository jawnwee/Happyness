//
//  ODDHappynessObserver.m
//  Happyness
//
//  Created by Matthew Chiang on 7/10/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Parse/Parse.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "SBJson4.h"
#import "ODDHappynessObserver.h"
#import "ODDHappynessEntryStore.h"
#import "ODDHappynessEntry.h"
#import "ODDHappyness.h"

@interface ODDHappynessObserver ()

@property (nonatomic, strong) NSMutableDictionary *feedbackData;
@property (nonatomic, strong) NSString *filePath;

@end

@implementation ODDHappynessObserver

- (instancetype)init {
    self = [super init];
    if (self) {
        _filePath = [[NSBundle mainBundle]pathForResource:@"feedbackQuotations" ofType:@"json"];

        NSData *allFeedbackData = [[NSData alloc] initWithContentsOfFile:_filePath];
        NSError *error;
        _feedbackData = [NSJSONSerialization JSONObjectWithData:allFeedbackData 
                                                        options:NSJSONReadingMutableContainers 
                                                          error:&error];
    }
    return self;
}

- (BOOL)connected
{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://google.com"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data) {
        return YES;
    } else {
        return NO;
    }
}

- (void)retreiveMessage {
    if ([self connected]) {
        PFQuery *query = [PFQuery queryWithClassName:@"FeedbackQuotations"];
        [query getObjectInBackgroundWithId:@"8tr1lrYDGl" block:^(PFObject *object, NSError *error) {
            NSMutableDictionary *newQuotations = [[NSMutableDictionary alloc] init];
            for (NSString *key in [object allKeys]) {
                [newQuotations setObject:[object valueForKey:key] forKey:key];
            }
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSData *result = [NSJSONSerialization dataWithJSONObject:newQuotations 
                                                             options:NSJSONWritingPrettyPrinted 
                                                               error:&error];
            [fileManager createFileAtPath:self.filePath contents:result attributes:nil];
        }];
    } else {
        NSLog(@"no connection available");
    }
}

/* Returns a feedback message */
- (NSString *)analyzePastDays {
    [self retreiveMessage];
    NSArray *entries = [[ODDHappynessEntryStore sharedStore] sortedStore];
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
    NSString *prefix = @"ODD";
    NSString *adjustedKey = [NSString stringWithFormat:@"%@%@", prefix, key];
    NSString *result = [self.feedbackData objectForKey:adjustedKey];
    return result;
}

@end
