//
//  ODDMainViewController.m
//  Happyness
//
//  Created by John Lee on 7/7/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDMainViewController.h"
#import "ODDBottomRootViewController.h"
#import "ODDRootViewController.h"

@interface ODDMainViewController ()

@property (nonatomic, strong) ODDRootViewController *topView;
@property (nonatomic, strong) ODDBottomRootViewController *bottomView;

@end

@implementation ODDMainViewController

- (instancetype)initWithScrollViewController:(ODDRootViewController *)scrollView
                        bottomViewController:(ODDBottomRootViewController *)assistantView{
    self = [super init];
    if (self) {
        /* insert any additional custom inits here */
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(updateBottomView)
                       name:@"updateBottomView" object:nil];
        _bottomView = assistantView;
        _topView = scrollView;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];
}

- (void)setupSubviews {
    [self.view addSubview:self.topView.view];
    [self.view addSubview:self.bottomView.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateBottomView {
    [self.bottomView updateView:[self.topView currentPage]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
