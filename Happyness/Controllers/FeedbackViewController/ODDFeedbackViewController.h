//
//  ODDFeedbackViewController.h
//  Happyness
//
//  Created by Matthew Chiang on 7/10/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "XYPieChart.h"

@class ODDSelectionCardScrollViewController;
@interface ODDFeedbackViewController : GAITrackedViewController <XYPieChartDataSource>

@property (nonatomic, strong) XYPieChart *pieChart;

- (instancetype)initWithCardSelectionController:
                                        (ODDSelectionCardScrollViewController *)bottomController;

@end

@protocol SubmitEntryObserver

- (void)submit;

@end
