//
//  ODDManyGraphsViewController.h
//  Happyness
//
//  Created by Yujun Cho on 7/6/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ODDStatisticsCardScrollView;

@interface ODDManyGraphsViewController : UIViewController

@property (nonatomic, strong) ODDStatisticsCardScrollView *cards;

// Designated initializer
- (instancetype)initWithGraphs:(NSArray *)graphs;

@end
