//
//  ODDGraphFooterView.h
//  Happyness
//
//  Created by Yujun Cho on 6/24/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODDGraphAxis.h"

@interface ODDGraphFooterView : ODDGraphAxis

@property CGFloat siderPadding;
@property CGFloat rightPadding;
@property BOOL isBarChart;

- (void)setElements:(NSMutableArray *)elements;

@end
