//
//  ODDBarGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDBarGraphViewController.h"
#import "JBBarChartView.h"
#import "ODDGraphFooterView.h"
#import "ODDGraphSiderView.h"

@interface ODDBarGraphViewController () <JBBarChartViewDataSource, JBBarChartViewDelegate>

@property (nonatomic,strong) JBBarChartView *barChartView;

@end

@implementation ODDBarGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _barChartView = [[JBBarChartView alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Bar Graph Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeBarGraph];
}

- (void)initializeBarGraph {
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    CGRect rootFrame = self.view.frame;
    CGRect graphTitleFrame = self.graphTitle.frame;
    CGFloat heighPadding = CGRectGetMaxY(graphTitleFrame);
    self.barChartView.frame = CGRectMake(graphTitleFrame.origin.x,
                                          heighPadding,
                                          rootFrame.size.width - (graphTitleFrame.origin.x * 2),
                                          rootFrame.size.height - (heighPadding * 2));

    self.barChartView.minimumValue = 0;
    self.barChartView.maximumValue = 100;
    self.barChartView.backgroundColor = [UIColor lightGrayColor];
    ODDGraphFooterView *footer = [[ODDGraphFooterView alloc] initWithElements:@[@"Mon",
                                                                                @"Tues",
                                                                                @"Wed",
                                                                                @"Thurs",
                                                                                @"Fri",
                                                                                @"Sat",
                                                                                @"Sun"]
                                                                    withFrame:CGRectMake(graphTitleFrame.origin.x,
                                                                                         CGRectGetMaxY(self.barChartView.frame),
                                                                                         self.barChartView.frame.size.width,
                                                                                         20)];
    ODDGraphSiderView *sider = [[ODDGraphSiderView alloc] initWithElements:@[@"100",
                                                                             @"80",
                                                                             @"60",
                                                                             @"40",
                                                                             @"20",
                                                                             @"0"]
                                                                 withFrame:CGRectMake(self.barChartView.frame.origin.x - 30,
                                                                                      self.barChartView.frame.origin.y,
                                                                                      30,
                                                                                      self.barChartView.frame.size.height)];
    [self.view addSubview:sider];
    [self.view addSubview:footer];
    [self.view addSubview:self.barChartView];
    [self.barChartView reloadData];
}

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView {
    return 7;
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            return 2;
        case 1:
            return 5;
        case 2:
            return 5;
        case 3:
            return 4;
        case 4:
            return 3;
        case 5:
            return 2;
        case 6:
            return 3;
        default:
            return 0;
            break;
    }
}

#pragma mark - Amount of data to graph

- (IBAction)graphAll:(id)sender {
    
}

- (IBAction)graphShortTerm:(id)sender {
    
}

- (IBAction)graphMedium:(id)sender {
    
}

@end
