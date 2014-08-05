//
//  ODDSelectionCardCollectionViewCell.h
//  Happyness
//
//  Created by John Lee on 7/14/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCardCollectionViewCell.h"

@interface ODDSelectionCardCollectionViewCell : ODDCardCollectionViewCell

- (void)setCardValue:(NSInteger)value;
- (void)selectCard;
- (void)deselect;

@end
