//
//  ODDLineGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDLineGraphViewController.h"
#import "JBLineChartView.h"

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
                                         graphTitleFrame.origin.y + 25,
                                         475,
                                         200);
    self.lineGraphView.maximumValue = 100;
    self.lineGraphView.minimumValue = 0;
    [self.view addSubview:self.lineGraphView];
    [self.lineGraphView reloadData];
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    return 2;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView
    numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    return 7;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView
    verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex
                        atLineIndex:(NSUInteger)lineIndex {
    switch (lineIndex) {
        case 0:
            return 0;
        case 1:
            switch (horizontalIndex) {
                case 0:
                    return 20;
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
                                format:@"Line chart tried to plot point at %lu", horizontalIndex];
            }
        default:
            [NSException raise:@"Invalid lineIndex"
                        format:@"Line chart tried to create line index %lu", lineIndex];
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
