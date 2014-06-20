//
//  ODDBarGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDBarGraphViewController.h"

@interface ODDBarGraphViewController ()

@end

@implementation ODDBarGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect landscapeFrame = CGRectMake(0, 0, 568, 320);
    self.view.frame = landscapeFrame;
    
    UIView *tabBar = nil;
    for (UIView *subview in self.tabBarController.view.subviews) {
        if ([subview isKindOfClass:[UITabBar class]]) {
            tabBar = subview;
        }
    }
    CGRect tabBarFrame = tabBar.frame;
}

@end
