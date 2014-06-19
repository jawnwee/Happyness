//
//  ODDHappynessEntryView.m
//  Happyness
//
//  Created by John Lee on 6/17/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDHappynessEntryView.h"

@implementation ODDHappynessEntryView

+ (instancetype)createHappynessEntryView {
    ODDHappynessEntryView *happynessEntry = [[[NSBundle mainBundle]
                                              loadNibNamed:@"ODDHappynessEntryView"
                                              owner:nil options:nil] lastObject];
    if (happynessEntry) {
        return happynessEntry;
    }
    return nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
