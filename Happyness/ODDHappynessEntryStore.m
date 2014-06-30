//
//  ODDHappynessEntryStore.m
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDHappynessEntryStore.h"
#import "ODDHappynessEntry.h"

@interface ODDHappynessEntryStore ()

@property(nonatomic) NSMutableDictionary *privateEntries;

@end

@implementation ODDHappynessEntryStore

+ (instancetype)sharedStore {
    static ODDHappynessEntryStore *sharedStore = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

+ (NSMutableArray *)sortedStore {
    NSMutableArray *entries =
        [[NSMutableArray alloc] initWithArray:
            [[[ODDHappynessEntryStore sharedStore] happynessEntries] allValues]];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    entries = [[NSMutableArray alloc] initWithArray:
                [entries sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];
    return entries;
}

// If a programmar calls [[ODDHappynessEntryStore alloc] init], throw an exception
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton" 
                                   reason:@"Use +[ODDHappynessEntryStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        _privateEntries = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSDictionary *)happynessEntries {
    return self.privateEntries;
}

/* Convert date to a Year/Month/Day format and use it as a the key for the entry */
- (void)addEntry:(ODDHappynessEntry *)entry {
    NSDate *date = [entry date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    NSString *key = [NSString stringWithFormat:@"%ld/%ld/%ld",
                     (long)[components year], (long)[components month], (long)[components day]];
    [_privateEntries setObject:entry forKey:key];
}

- (void)removeEntry:(ODDHappynessEntry *)entry {
    NSDate *key = [entry date];
    [_privateEntries removeObjectForKey:key];
}

@end
