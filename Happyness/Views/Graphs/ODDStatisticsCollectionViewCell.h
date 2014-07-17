//
//  ODDStatisticsCollectionViewCell.h
//  Happyness
//
//  Created by Yujun Cho on 7/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCardCollectionViewCell.h"

@interface ODDStatisticsCollectionViewCell : ODDCardCollectionViewCell

- (void)setCardValueAndLabelsShadow:(NSInteger)value;
- (void)setOccurencesText:(NSString *)text;
- (void)setLongestStreakText:(NSString *)text;

@end
