//
//  ODDSettingsViewController.m
//  Happyness
//
//  Created by John Lee on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDSettingsViewController.h"

@interface ODDSettingsViewController ()

@end

@implementation ODDSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Settings";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
