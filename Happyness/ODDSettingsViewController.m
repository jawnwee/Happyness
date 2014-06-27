//
//  ODDSettingsViewController.m
//  Happyness
//
//  Created by John Lee on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDSettingsViewController.h"

@interface ODDSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *reminder;

@end

@implementation ODDSettingsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage *settingsSelected = [UIImage imageNamed:@"SettingsTabSelected60.png"];
        UIImage *settingsUnselected = [UIImage imageNamed:@"SettingsTabUnselected60.png"];
        settingsSelected = [settingsSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        settingsUnselected = [settingsUnselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *settingsTabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:settingsUnselected selectedImage:settingsSelected];
        self.tabBarItem = settingsTabBarItem;
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
- (IBAction)eraseData:(id)sender {
}

@end
