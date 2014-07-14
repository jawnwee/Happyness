//
//  ODDGraphAxis.h
//  Happyness
//
//  Created by Yujun Cho on 7/1/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODDGraphAxis : UIView

@property (nonatomic, strong) NSMutableArray *labels;

// Designated initializer
- (instancetype)initWithElements:(NSArray *)elements withFrame:(CGRect)frame;

@end
