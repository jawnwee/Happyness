//
//  ODDDoubleArrayHolder.m
//  Happyness
//
//  Created by Yujun Cho on 7/2/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDDoubleArrayHolder.h"

@implementation ODDDoubleArrayHolder

- (id)initWithCount:(NSUInteger)count{
    if (count == 0) {
        @throw [NSException exceptionWithName:@"InputException"
                                       reason:@"Count must be greater than zero"
                                     userInfo:nil];
    }
    
    self = [super init];
    if (self) {
        _count = count;
        _values = malloc(sizeof(double) * count);
    }
    return self;
}

- (id)initWithCount:(NSUInteger)count withValues:(double *)givenValues {
    self = [self initWithCount:count];
    if (self) {
        memcpy(_values, givenValues, count*sizeof(double));
    }
    return self;
}

- (id)subarrayWithRange:(NSRange)range {
    NSUInteger rangeCount = (range.length - range.location);
    NSUInteger i;
    double temporaryDoubleArray[rangeCount];
    for (i = 0; i < rangeCount; i++) {
        temporaryDoubleArray[i] = _values[_count - rangeCount + i];
    }
    ODDDoubleArrayHolder *subarray =
        [[ODDDoubleArrayHolder alloc] initWithCount:rangeCount
                                        withValues:temporaryDoubleArray];
    return subarray;
}

- (double)getValueAtIndex:(NSUInteger)index {
    if (index >= _count) {
        @throw [NSException exceptionWithName:@"InputException"
                                       reason:@"Index out of bounds"
                                     userInfo:nil];
    }
    
    return _values[index];
}

- (void)setValue:(double)value atIndex:(NSUInteger)index {
    if (index >= _count) {
        @throw [NSException exceptionWithName:@"InputException"
                                       reason:@"Index out of bounds"
                                     userInfo:nil];
    }
    
    _values[index] = value;
}

- (NSUInteger)getSize {
    return _count;
}

- (double *)getValues {
    return _values;
}

@end
