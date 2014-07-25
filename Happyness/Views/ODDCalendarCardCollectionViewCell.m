//
//  ODDCalendarCardCollectionViewCell.m
//  Happyness
//
//  Created by John Lee on 7/9/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarCardCollectionViewCell.h"
#import "ODDHappynessHeader.h"
#import "ODDCustomColor.h"

@interface ODDCalendarCardCollectionViewCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) CGSize shadowOffset;

@end

@implementation ODDCalendarCardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        self.backgroundView  = _imageView;

        CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;

        static CGSize shadowOffset;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shadowOffset = CGSizeMake(0.0f, onePixel);
        });
        self.shadowOffset = shadowOffset;

        [self setupNoteLabel];
        [self setupDateLabel];
    }
    return self;
}

- (void)setupNoteLabel {

    _noteLabel = [[UITextView alloc] initWithFrame:[self createNoteFrame]];
    _noteLabel.font = [UIFont fontWithName:@"Whitney-Book" size:12.0];
    _noteLabel.textColor = [[ODDCustomColor customColorDictionary]
                            objectForKey:@"oddLook_textcolor"];
    _noteLabel.backgroundColor = [UIColor clearColor];
    _noteLabel.editable = NO;
    [self.contentView addSubview:_noteLabel];

}

- (void)setupDateLabel {

    _dateLabel = [[UILabel alloc] initWithFrame:[self createDateFrame]];
    _dateLabel.font = [UIFont fontWithName:@"GothamRounded-Bold" size:18.0];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.shadowColor = [UIColor lightTextColor];
    _dateLabel.shadowOffset = self.shadowOffset;
    [self.contentView addSubview:_dateLabel];
}

/* Change this class if want to make the calendar cards to display differently */
- (void)setHappynessEntry:(ODDHappynessEntry *)happynessEntry {
    NSDate *entryDate = [happynessEntry date];
    ODDNote *note = [happynessEntry note];
    ODDHappyness *happyness = [happynessEntry happyness];
    _currentEntry = happynessEntry;
    NSInteger value = [[happyness value] integerValue];

    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:entryDate];

    NSInteger day = [components day];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];

    NSString *cardImage = [NSString stringWithFormat:@"oddLook_calendar_card_%ld", (long)value];
    UIImage *card = [UIImage imageNamed:cardImage];

    // Date Color needs to change respectively to card color
    _dateLabel.textColor = [[ODDCustomColor customColorDictionary]
                            objectForKey:
                               [NSString stringWithFormat:@"oddLook_color_dark_%ld", (long) value]];

    self.imageView.image = card;
    self.noteLabel.text = note.noteString;
    self.dateLabel.text = [NSString stringWithFormat:@"%ld", (long) day];
    [self.dateLabel sizeToFit];
}

- (CGRect)createDateFrame {
    CGRect dateFrame = CGRectMake((self.frame.size.width / 2.0) - 8.0, 5.0, 50, 50);
    return dateFrame;
}

/* Adjust this to move the space for notes; will need to change for iphone6 */
- (CGRect)createNoteFrame {
    CGRect noteFrame = CGRectMake(5.0, 120.0, 110, 75);
    return noteFrame;
}

@end
