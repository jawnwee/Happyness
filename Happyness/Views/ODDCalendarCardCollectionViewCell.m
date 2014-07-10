//
//  ODDCalendarCardCollectionViewCell.m
//  Happyness
//
//  Created by John Lee on 7/9/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarCardCollectionViewCell.h"

@implementation ODDCalendarCardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *card = [UIImage imageNamed:@"oddLook_calendar_card_1.png"];
        self.backgroundView = [[UIImageView alloc] initWithImage:card];
    }
    return self;
}


@end
