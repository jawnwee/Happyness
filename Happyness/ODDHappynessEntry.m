//
//  ODDHappynessEntry.m
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDHappynessEntry.h"

@implementation ODDHappynessEntry

- (instancetype)initWithHappynessObjectAndNoteAndDateTime:(ODDHappynessObject *)happynessObject
                                                     note:(ODDNoteObject *)note
                                                 dateTime:(NSString *)dateTime {
    self = [super init];
    if (self) {
        _happynessObject = happynessObject;
        _note = note;
        _dateAndTimeString = dateTime;
    }
    return self;
}

@end
