//
//  ODDLineGraphViewController.h
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODDGraphViewController.h"
@class JBLineChartView;

@interface ODDLineGraphViewController : ODDGraphViewController

@property (nonatomic,strong) JBLineChartView *lineGraphView;

@end
