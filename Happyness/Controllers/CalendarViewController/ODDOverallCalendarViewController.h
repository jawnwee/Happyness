//
//  ODDOverallCalendarView.h
//  Happyness
//
//  Created by John Lee on 7/5/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@class ODDCalendarCardScrollViewController;


@interface ODDOverallCalendarViewController : GAITrackedViewController

- (instancetype)initWithbottomController:(ODDCalendarCardScrollViewController *)bottomController;

@end
