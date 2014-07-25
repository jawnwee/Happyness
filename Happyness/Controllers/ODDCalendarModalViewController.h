//
//  ODDCalendarModalViewController.h
//  Happyness
//
//  Created by John Lee on 7/24/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODDNoteModalViewController.h"

@class ODDHappynessEntry;
@interface ODDCalendarModalViewController : ODDNoteModalViewController

@property (nonatomic, strong) ODDHappynessEntry *selectedHappyness;
@property (nonatomic, strong) NSDate *selectedDate;


@end
