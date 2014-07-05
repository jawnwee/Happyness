//
//  ODDHappynessView.m
//  Happyness
//
//  Created by Matthew Chiang on 6/18/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDHappynessView.h"

@implementation ODDHappynessView

- (id)initWithFrame:(CGRect)frame happyness:(ODDHappyness *)happynessObject
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpColorAndFace:happynessObject];
    }
    return self;
}

- (void)setUpColorAndFace:(ODDHappyness *)happynessObject {
    self.backgroundColor = happynessObject.color;

    UIImageView *imageSubView = [[UIImageView alloc] initWithImage:happynessObject.face];
    CGPoint imageCenter = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2 - 49);
    imageSubView.center = imageCenter;

    [self addSubview:imageSubView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
