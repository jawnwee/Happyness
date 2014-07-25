//
//  ODDSelectionModalViewController.h
//  Happyness
//
//  Created by John Lee on 7/24/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODDCardScrollViewController.h"

@class ODDHappynessEntry;

@interface ODDSelectionModalViewController : ODDCardScrollViewController

@property (nonatomic, strong) ODDHappynessEntry *currentEntry;
@property (nonatomic, strong) NSDate *selectedDate;

- (instancetype)initWithHappynessEntry:(ODDHappynessEntry *)entry;

@end
