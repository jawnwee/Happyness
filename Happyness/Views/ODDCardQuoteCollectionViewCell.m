//
//  ODDCardQuoteViewCell.m
//  Happyness
//
//  Created by Matthew Chiang on 7/15/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCardQuoteCollectionViewCell.h"

@interface ODDCardQuoteCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ODDCardQuoteCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] init];
        self.backgroundView = _imageView;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)setCardValue:(NSInteger)value {
    NSString *cardImage = [NSString stringWithFormat:@"oddLook_card_%ld", (long)value];
    UIImage *card = [UIImage imageNamed:cardImage];
    self.imageView.image = card;

//    CGRect frame = CGRectMake(7, 0, card.size.width - 20, card.size.height);
//    self.label = [[UILabel alloc] initWithFrame:frame];
//    self.label.textAlignment = NSTextAlignmentCenter;
//    self.label.numberOfLines = 0;
//    self.label.lineBreakMode = NSLineBreakByWordWrapping;
//    self.label.font = [UIFont fontWithName:@"GothamRounded-Bold" size:12.0];
//    self.label.textColor = [UIColor whiteColor];
//
//    [self addSubview:self.label];
}

@end
