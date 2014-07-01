//
//  ODDBarGraphViewController.h
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODDGraphViewController.h"
@class JBBarChartView;

@interface ODDBarGraphViewController : ODDGraphViewController

@property (nonatomic,strong) JBBarChartView *barChartView;

@end
