//
//  ODDBottomRootViewController.h
//  Happyness
//
//  Created by John Lee on 7/7/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODDBottomRootViewController : UIViewController

- (instancetype)initWithViewControllers:(NSArray *)bottomViewControllers;

- (void)updateView:(NSInteger)index;

@end
