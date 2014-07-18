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
    return rtn;
}

@end
