//
//  ODDHappynessObject.m
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDHappynessObject.h"

#define VERY_SAD_COLOR
#define SAD_COLOR
#define SO_SO_COLOR
#define HAPPY_COLOR
#define VERY_HAPPY_COLOR

#define VERY_SAD_RATING
#define SAD_RATING
#define SO_SO_RATING
#define HAPPY_RATING
#define VERY_HAPPY_RATING

@interface ODDHappynessObject ()

@end

@implementation ODDHappynessObject

- (instancetype)initWithFace:(UIImage *)face {
    self = [super init];
    if (self) {
        _face = face;
        [self setColor];
        [self setRating];
    }
    return self;
}


// Set color based on face
- (void)setColor {
    switch (_face) {
        case VERY_SAD_FACE:
            _color = VERY_SAD_COLOR;
            break;
        case SAD_FACE:
            _color = SAD_COLOR;
            break;
        case SO_SO_FACE:
            _color = SO_SO_COLOR;
            break;
        case HAPPY_FACE:
            _color = HAPPY_COLOR;
            break;
        case VERY_HAPPY_FACE:
            _color = VERY_HAPPY_COLOR;
            break;
        default:
            break;
    }
}

// Set rating based on face
- (void)setRating {
    switch (self.color) {
        case VERY_SAD_FACE:
            _rating = VERY_SAD_RATING;
            break;
        case SAD_FACE:
            _rating = SAD_RATING;
            break;
        case SO_SO_FACE:
            _rating = SO_SO_RATING;
            break;
        case HAPPY_FACE:
            _rating = HAPPY_RATING;
            break;
        case VERY_HAPPY_FACE:
            _rating = VERY_HAPPY_RATING;
            break;
        default:
            break;
    }
}

@end
