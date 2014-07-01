//
//  ODDPreviousDayViewController.h
//  Happyness
//
//  Created by John Lee on 6/30/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODDTodayViewController.h"

@class ODDHappynessEntry;

@interface ODDPreviousDayViewController : ODDTodayViewController

- (instancetype)initWithHappynessEntry:(ODDHappynessEntry *)entry forDate:(NSDate *)date;

@end
