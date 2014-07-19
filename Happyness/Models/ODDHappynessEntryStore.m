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

@property (strong, nonatomic) NSMutableDictionary *privateEntries;
@property (strong, nonatomic) NSMutableArray *entries;

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

- (void)sortStore:(BOOL)isAscending {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:isAscending];
    _entries = [[NSMutableArray alloc] initWithArray:[self.privateEntries allValues]];
    self.entries = [[NSMutableArray alloc] initWithArray:
               [self.entries sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];

}

- (NSMutableArray *)sortedStore {
    return self.entries;
}

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
        _entries = [[NSMutableArray alloc] initWithArray:[self.privateEntries allValues]];
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
    [entry MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (ODDHappynessEntry *)todayEntry {
    NSDate *date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    NSString *key = [NSString stringWithFormat:@"%ld/%ld/%ld",
                     (long)[components year], (long)[components month], (long)[components day]];

    return [self.privateEntries objectForKey:key];
}

#pragma mark - Calendar properties

- (NSDate *)firstDate {
    ODDHappynessEntry *first = [self.entries objectAtIndex:0];
    NSDate *date = [first date];

    return date;
}

@end
