//
//  ODDFeedbackViewController.h
//  Happyness
//
//  Created by Matthew Chiang on 7/10/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "XYPieChart.h"

@class ODDTodayNoteView;

@interface ODDFeedbackViewController : UIViewController <HPGrowingTextViewDelegate, XYPieChartDataSource>

@property (strong, nonatomic) XYPieChart *pieChart;

@end
