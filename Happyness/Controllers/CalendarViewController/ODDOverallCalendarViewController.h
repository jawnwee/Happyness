//
//  ODDOverallCalendarView.h
//  Happyness
//
//  Created by John Lee on 7/5/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODDCalendarCardScrollViewController;

@interface ODDOverallCalendarViewController : UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
               bottomController:(ODDCalendarCardScrollViewController *)bottomController;


@end
