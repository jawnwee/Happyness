//
//  ODDBarGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDBarGraphViewController.h"
#import "JBBarChartView.h"

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
    [self initializeBarGraph];
}

- (void)initializeBarGraph {
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    CGRect graphTitleFrame = self.graphTitle.frame;
    self.barChartView.frame = CGRectMake(graphTitleFrame.origin.x + 25,
                                         graphTitleFrame.origin.y + 25,
                                         475,
                                         200);
    self.barChartView.minimumValue = 0;
    self.barChartView.maximumValue = 5;
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

- (IBAction)graphAll:(id)sender{
    
}

- (IBAction)graphOneMonth:(id)sender{
    
}

- (IBAction)graphOneWeek:(id)sender{
    
}

- (IBAction)graphOneYear:(id)sender{
    
}

@end
