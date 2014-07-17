//
//  ODDStatisticsCollectionViewCell.m
//  Happyness
//
//  Created by Yujun Cho on 7/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDStatisticsCollectionViewCell.h"
#import "ODDCustomColor.h"

@interface ODDStatisticsCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) CGSize shadowOffset;
@property (nonatomic, strong) UILabel *occurences;
@property (nonatomic, strong) UILabel *longestStreak;

@end

@implementation ODDStatisticsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] init];
        self.backgroundView  = _imageView;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        CGFloat onePixel = 3.0f / [UIScreen mainScreen].scale;
        static CGSize shadowOffset;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shadowOffset = CGSizeMake(0.0f, onePixel);
        });
        self.shadowOffset = shadowOffset;
        
        [self setComingSoonLabels];
    }
    return self;
}

- (void)setComingSoonLabels{
    UILabel *comingSoon = [[UILabel alloc] init];
    comingSoon.textAlignment = NSTextAlignmentCenter;
    comingSoon.numberOfLines = 0;
    comingSoon.lineBreakMode = NSLineBreakByWordWrapping;
    comingSoon.font = [UIFont fontWithName:@"GothamRounded-Bold" size:14.0];
    comingSoon.textColor = [UIColor whiteColor];
    comingSoon.shadowOffset = self.shadowOffset;
    comingSoon.text = @"Coming Soon";
    [comingSoon sizeToFit];
    CGRect modifiedFrame = CGRectMake(0,
                                      CGRectGetMidY(self.frame) - 20,
                                      self.frame.size.width,
                                      comingSoon.frame.size.height);
    [comingSoon setFrame:modifiedFrame];
    [self addSubview:comingSoon];
}

- (void)setCardValueAndLabelsShadow:(NSInteger)value {
    NSString *cardImage = [NSString stringWithFormat:@"oddLook_card_%ld", (long)value];
    UIImage *card = [UIImage imageNamed:cardImage];
    self.imageView.image = card;
    
    UIColor *labelShadowColor = [[ODDCustomColor customColorDictionary]
                                 objectForKey:
                                 [NSString stringWithFormat:@"oddLook_color_dark_%ld", (long) value]];
    self.occurences.shadowColor = labelShadowColor;
    self.longestStreak.shadowColor = labelShadowColor;
}

- (void)setOccurencesLabel {
    self.occurences = [[UILabel alloc] init];
    self.occurences.textAlignment = NSTextAlignmentCenter;
    self.occurences.numberOfLines = 0;
    self.occurences.lineBreakMode = NSLineBreakByWordWrapping;
    self.occurences.font = [UIFont fontWithName:@"GothamRounded-Bold" size:14.0];
    self.occurences.textColor = [UIColor whiteColor];
    self.occurences.shadowOffset = self.shadowOffset;
    [self addSubview:self.occurences];
}

- (void)setLongestStreakLabel {
    self.longestStreak = [[UILabel alloc] init];
    self.longestStreak.textAlignment = NSTextAlignmentCenter;
    self.longestStreak.numberOfLines = 0;
    self.longestStreak.lineBreakMode = NSLineBreakByWordWrapping;
    self.longestStreak.font = [UIFont fontWithName:@"GothamRounded-Bold" size:14.0];
    self.longestStreak.textColor = [UIColor whiteColor];
    self.longestStreak.shadowOffset = self.shadowOffset;
    [self addSubview:self.longestStreak];
}

- (void)setOccurencesText:(NSString *)text {
    self.occurences.text = text;
    [self.occurences sizeToFit];
    CGFloat yOffsetGuess = CGRectGetMidY(self.frame) / 4.4;
    CGRect modifiedFrame = CGRectMake(0,
                                      yOffsetGuess,
                                      self.frame.size.width,
                                      self.occurences.frame.size.height);
    [self.occurences setFrame:modifiedFrame];
}

- (void)setLongestStreakText:(NSString *)text {
    self.longestStreak.text = text;
    [self.longestStreak sizeToFit];
    CGFloat yOffsetGuess = 40;
    CGRect modifiedFrame = CGRectMake(0,
                                      CGRectGetMidY(self.frame) + yOffsetGuess,
                                      self.frame.size.width,
                                      self.longestStreak.frame.size.height);
    [self.longestStreak setFrame:modifiedFrame];
}

@end
