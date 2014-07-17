//
//  ODDStatisticsCardScrollView.h
//  Happyness
//
//  Created by Yujun Cho on 7/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCardScrollViewController.h"

@interface ODDStatisticsCardScrollView : ODDCardScrollViewController

@property (nonatomic, strong) NSMutableArray *cardOccurences;
@property (nonatomic, strong) NSMutableArray *longestStreak;

@end
