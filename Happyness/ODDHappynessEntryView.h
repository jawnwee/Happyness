//
//  ODDHappynessEntryView.h
//  Happyness
//
//  Created by John Lee on 6/17/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODDHappynessEntry;

@interface ODDHappynessEntryView : UITableViewCell

+ (instancetype)createHappynessEntryView;

@property (weak, nonatomic) IBOutlet UIImageView *happynessImage;
@property (weak, nonatomic) IBOutlet UILabel *happynessNote;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *day;


- (void)setHappynessEntry:(ODDHappynessEntry *)happyness;

@end
