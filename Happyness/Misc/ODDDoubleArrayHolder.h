//
//  ODDDoubleArrayHolder.h
//  Happyness
//
//  Created by Yujun Cho on 7/2/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODDDoubleArrayHolder : NSObject {
    NSUInteger _count;
    double* _values;
}

// Designated initializer
- (id)initWithCount:(NSUInteger)size;
- (id)initWithCount:(NSUInteger)size withValues:(double*)values;
- (id)subarrayWithRange:(NSRange)range;
- (double)getValueAtIndex:(NSUInteger)index;
- (void)setValue:(double)value atIndex:(NSUInteger)index;
- (double *)getValues;
- (NSUInteger)getSize;

@end
