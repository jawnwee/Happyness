//
//  ODDHappyness.m
//  Happyness
//
//  Created by Matthew Chiang on 7/18/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDHappyness.h"
#import "ODDHappynessEntry.h"


@implementation ODDHappyness

@dynamic rating;
@dynamic value;
@dynamic entry;

/* Set rating based on face; Temporarily putting face value as the rating */
- (NSNumber *)rating {
    NSNumber *rtn = self.value;
    if ([self.value integerValue] == 5) {
        rtn = [NSNumber numberWithInt:100.0];
    } else if ([self.value integerValue] == 4) {
        rtn = [NSNumber numberWithInt:80.0];
    } else if ([self.value integerValue] == 3) {
        rtn = [NSNumber numberWithInt:50.0];
    } else if ([self.value integerValue] == 2) {
        rtn = [NSNumber numberWithInt:40.0];
    } else if ([self.value integerValue] == 1) {
        rtn = [NSNumber numberWithInt:10.0];
    }
    return rtn;
}

@end
