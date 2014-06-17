//
//  ODDNoteObject.m
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDNote.h"

@implementation ODDNote

- (instancetype)initWithNote:(NSMutableString *)note {
    self = [super init];
    if (self) {
        _noteString = note;
    }
    return self;
}

@end
