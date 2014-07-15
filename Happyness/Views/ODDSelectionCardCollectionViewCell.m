//
//  ODDSelectionCardCollectionViewCell.m
//  Happyness
//
//  Created by John Lee on 7/14/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDSelectionCardCollectionViewCell.h"
#import "ODDHappynessHeader.h"

@interface ODDSelectionCardCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *checkMark;

@end

@implementation ODDSelectionCardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        CGRect checkMark = CGRectMake(CGRectGetMidX(self.bounds) - 10, 140.0, 22.5, 22.5);
        _checkMark = [[UIImageView alloc] initWithFrame:checkMark];
        self.backgroundView  = _imageView;
        [self addSubview:_checkMark];
    }
    return self;
}

- (void)setCardValue:(NSInteger)value {
    NSString *cardImage = [NSString
                           stringWithFormat:@"oddLook_selection_card_%ld", (long)value];
    UIImage *card = [UIImage imageNamed:cardImage];
    self.imageView.image = card;
}

- (void)selectCard {
    UIImage *card = [UIImage imageNamed:@"checkmark.png"];
    self.checkMark.image = card;
}

- (void)deselect {
    self.checkMark.image = nil;
    
}




@end
