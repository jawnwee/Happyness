//
//  ODDHappynessObject.h
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODDHappyness : NSObject

@property (nonatomic) NSInteger value;
@property (strong, nonatomic, readonly) UIImage *face;
@property (strong, nonatomic, readonly) UIColor *color;
@property (nonatomic, readonly) NSInteger rating;

// Init with face image determines the color and rating value
- (instancetype)initWithFace:(NSInteger)faceValue;

@end
