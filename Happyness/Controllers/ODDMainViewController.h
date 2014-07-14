//
//  ODDMainViewController.h
//  Happyness
//
//  Created by John Lee on 7/7/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODDBottomRootViewController;
@class ODDRootViewController;

@interface ODDMainViewController : UIViewController

- (instancetype)initWithScrollViewController:(ODDRootViewController *)scrollView
                        bottomViewController:(ODDBottomRootViewController *)assistantView;

@end
