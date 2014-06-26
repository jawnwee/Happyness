//
//  ODDHappynessEntryStore.h
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ODDHappynessEntry;

@interface ODDHappynessEntryStore : NSObject

@property (strong, nonatomic, readonly) NSDictionary *happynessEntries;

+ (instancetype)sharedStore;

- (void)addEntry:(ODDHappynessEntry *)entry;
- (void)removeEntry:(ODDHappynessEntry *)entry;



@end
