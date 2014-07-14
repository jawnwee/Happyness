//
//  ODDRootViewController.h
//  Happyness
//
//  Created by Yujun Cho on 7/5/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODDRootViewController : UIViewController

// Add the view controllers in the order of how the views
// should be laid out.
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic) NSInteger currentPage;

@end
