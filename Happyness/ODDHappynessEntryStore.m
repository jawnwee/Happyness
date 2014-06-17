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

@property(nonatomic) NSMutableArray *privateEntries;

@end

@implementation ODDHappynessEntryStore

+ (instancetype)sharedStore {
    static ODDHappynessEntryStore *sharedStore = nil;

    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
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
        _privateEntries = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addEntry:(ODDHappynessEntry *)entry {
    [_privateEntries addObject:entry];
}

- (void)removeEntry:(ODDHappynessEntry *)entry {
    [_privateEntries removeObjectIdenticalTo:entry];
}

@end
