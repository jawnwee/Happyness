//
//  ODDAnalysisViewController.m
//  Happyness
//
//  Created by John Lee on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDAnalysisViewController.h"

@interface ODDAnalysisViewController ()

@end

@implementation ODDAnalysisViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    // Do any additional setup after loading the view from its nib.
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2,
                                                                   self.view.frame.size.height / 2,
                                                                   200,
                                                                   200)];
    testLabel.text = @"PORTRAIT";
    [self.view addSubview:testLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
