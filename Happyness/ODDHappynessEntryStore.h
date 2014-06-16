//
//  ODDHappynessEntryStore.h
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODDHappynessEntry.h"

@interface ODDHappynessEntryStore : NSObject

@property(nonatomic, readonly) NSArray *entries;

+ (instancetype)sharedStore;

- (void)addEntry:(ODDHappynessEntry *)entry;
- (void)removeEntry:(ODDHappynessEntry *)entry;



@end
