//
//  ODDStatisticsGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/18/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDStatisticsGraphViewController.h"
#import "JBLineChartView.h"

@interface ODDStatisticsGraphViewController () <JBLineChartViewDelegate, JBLineChartViewDataSource>

@end

@implementation ODDStatisticsGraphViewController

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
    
    JBLineChartView *lineChartView = [[JBLineChartView alloc] init];
    lineChartView.delegate = self;
    lineChartView.dataSource = self;
    lineChartView.frame = CGRectMake(25, 0, 518, 270);
    lineChartView.minimumValue = 0;
    lineChartView.maximumValue = 10;
    [lineChartView reloadData];
    [self.view addSubview:lineChartView];
}

#pragma mark - LineChart setup

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView
  numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    return 7;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView
  verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex
                      atLineIndex:(NSUInteger)lineIndex {
    return 5;
}

@end
