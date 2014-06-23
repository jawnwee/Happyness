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

- (void)setHappynessEntry:(ODDHappynessEntry *)happyness;

@end
