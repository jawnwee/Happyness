//
//  ODDCardQuoteViewCell.h
//  Happyness
//
//  Created by Matthew Chiang on 7/15/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCardCollectionViewCell.h"

@interface ODDCardQuoteCollectionViewCell : ODDCardCollectionViewCell

@property (nonatomic, strong) UILabel *label;
- (void)setCardValue:(NSInteger)value;

@end
