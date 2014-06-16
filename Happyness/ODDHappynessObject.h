//
//  ODDHappynessObject.h
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VERY_SAD_FACE // image strings go here
#define SAD_FACE
#define SO_SO_FACE
#define HAPPY_FACE
#define VERY_HAPPY_FACE

@interface ODDHappynessObject : NSObject

@property(nonatomic, readonly) UIImage *face;
@property(nonatomic, readonly) UIColor *color;
@property(nonatomic, readonly) int rating;

// Init with face image determines the color and rating value
- (instancetype)initWithFace:(UIImage *)face;

@end
