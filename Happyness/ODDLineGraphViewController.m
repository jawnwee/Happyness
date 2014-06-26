//
//  ODDLineGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDLineGraphViewController.h"
#import "JBLineChartView.h"
#import "ODDGraphFooterView.h"
#import "ODDGraphSiderView.h"

@interface ODDLineGraphViewController () <JBLineChartViewDataSource, JBLineChartViewDelegate>

@property (nonatomic,strong) JBLineChartView *lineGraphView;

@end

@implementation ODDLineGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _lineGraphView = [[JBLineChartView alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Line Graph Setup

- (void)viewDidLoad {
    [self initializeLineGraph];
}

- (void)initializeLineGraph {
    self.lineGraphView.delegate = self;
    self.lineGraphView.dataSource = self;
    CGRect graphTitleFrame = self.graphTitle.frame;
    self.lineGraphView.frame = CGRectMake(graphTitleFrame.origin.x + 25,
                                         graphTitleFrame.origin.y + 30,
                                         475,
                                         225);
    self.lineGraphView.maximumValue = 100;
    self.lineGraphView.minimumValue = 0;
    ODDGraphFooterView *footer = [[ODDGraphFooterView alloc] initWithElements:@[@"Mon",
                                                                                @"Tues",
                                                                                @"Wed",
                                                                                @"Thurs",
                                                                                @"Fri",
                                                                                @"Sat",
                                                                                @"Sun"]
                                                                    withFrame:CGRectMake(0,
                                                                                         0,
                                                                                         self.lineGraphView.frame.size.width,
                                                                                         20)];
    ODDGraphSiderView *sider = [[ODDGraphSiderView alloc] initWithElements:@[@"100",
                                                                             @"80",
                                                                             @"60",
                                                                             @"40",
                                                                             @"20",
                                                                             @"0"]
                                                                 withFrame:CGRectMake(self.lineGraphView.frame.origin.x - 20,
                                                                                      self.lineGraphView.frame.origin.y,
                                                                                      30,
                                                                                      self.lineGraphView.frame.size.height)];
    [self.view addSubview:sider];
    self.lineGraphView.footerView = footer;
    [self.view addSubview:self.lineGraphView];
    [self.lineGraphView reloadData];
}

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
    switch (horizontalIndex) {
        case 0:
            return 0;
        case 1:
            return 30;
        case 2:
            return 40;
        case 3:
            return 80;
        case 4:
            return 100;
        case 5:
            return 50;
        case 6:
            return 25;
        default:
            [NSException raise:@"Invalid horizontalIndex"
                        format:@"Line chart tried to plot point at %lu", (unsigned long)horizontalIndex];
    }
    
    return 0;
}

#pragma mark - Amount of data to graph

- (IBAction)graphAll:(id)sender{
    
}

- (IBAction)graphOneMonth:(id)sender{
    
}

- (IBAction)graphOneWeek:(id)sender{
    
}

- (IBAction)graphOneYear:(id)sender{
    
}

@end
