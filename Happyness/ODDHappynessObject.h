//
//  ODDHappynessObject.h
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODDHappynessObject : NSObject

@property(nonatomic, readonly) UIImage *face;
@property(nonatomic, readonly) UIColor *color;
@property(nonatomic, readonly) int rating;

- (instancetype)initWithFaceAndViewColor:(UIImage *)face viewColor:(UIColor *)color;

@end
