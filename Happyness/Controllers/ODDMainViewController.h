//
//  ODDMainViewController.h
//  Happyness
//
//  Created by John Lee on 7/7/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ODDBottomRootViewController;

@interface ODDMainViewController : UIViewController

- (instancetype)initWithScrollViewController:(UIViewController *)scrollView
                        bottomViewController:(ODDBottomRootViewController *)assistantView;

@end
