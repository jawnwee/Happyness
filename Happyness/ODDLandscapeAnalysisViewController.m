//
//  ODDLandscapeAnalysisViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/17/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDLandscapeAnalysisViewController.h"

@interface ODDLandscapeAnalysisViewController ()

@end

@implementation ODDLandscapeAnalysisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2,
                                                                   self.view.frame.size.height / 2,
                                                                   50, 50)];
    testLabel.text = @"LANDSCAPE";
    [self.view addSubview:testLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
