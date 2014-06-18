//
//  ODDHappynessObject.m
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDHappyness.h"
#import "ODDCustomColor.h"

@interface ODDHappyness ()

@end

@implementation ODDHappyness

@synthesize face = _face;
@synthesize color = _color;
@synthesize rating = _rating;


- (instancetype)initWithFace:(NSInteger)faceValue{
    self = [super init];
    if (self) {
        // commented out for testing purposes [self setFaceImage:faceValue];
        [self setColor: faceValue];
        [self setRating:faceValue];
    }
    return self;
}


/* Set the UIImage for the face */
- (void)setFaceImage:(NSInteger)faceValue {

    NSString *faceImageName = [NSString stringWithFormat:@"Happyness_%ld.png", faceValue];
    _face = [UIImage imageNamed:faceImageName];
}


/* Set color based on face */
- (void)setColor:(NSInteger)faceValue {

    NSDictionary *colorDictionary = [ODDCustomColor customColorDictionary];
    NSString *key = [NSString stringWithFormat:@"oddLook_color_%ld", faceValue];
    UIColor *happynessColor = (UIColor *)[colorDictionary objectForKey:key];

    _color = happynessColor;
}

/* Set rating based on face; Temporarily putting face value as the rating */
- (void)setRating:(NSInteger)faceValue {
    _rating = faceValue;
}

@end
