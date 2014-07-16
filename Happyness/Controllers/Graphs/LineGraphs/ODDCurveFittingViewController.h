//
//  ODDCurveFittingViewController.h
//  Happyness
//
//  Created by Yujun Cho on 7/3/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDLineGraphViewController.h"

@interface ODDCurveFittingViewController : ODDLineGraphViewController

- (void)setFrameSize:(CGSize)size;
- (void)setFramePosition:(CGPoint)point;
- (void)reloadDataStore;

@end
