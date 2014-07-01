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

@end

@implementation ODDBarGraphViewController
@synthesize barChartView = _barChartView;

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
    self.barChartView.userInteractionEnabled = NO;
    CGRect rootFrame = self.view.frame;
    CGRect graphTitleFrame = self.graphTitle.frame;
    CGFloat heighPadding = CGRectGetMaxY(graphTitleFrame);
    self.barChartView.frame = CGRectMake(graphTitleFrame.origin.x,
                                          heighPadding,
                                          rootFrame.size.width - (graphTitleFrame.origin.x * 2),
                                          rootFrame.size.height - (heighPadding * 2));

    self.barChartView.minimumValue = 0;
    self.barChartView.maximumValue = 5;
    self.footer = [[ODDGraphFooterView alloc] initWithElements:@[@"Mon",
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
    self.sider = [[ODDGraphSiderView alloc] initWithElements:@[@"5",
                                                                             @"4",
                                                                             @"3",
                                                                             @"2",
                                                                             @"1",
                                                                             @"0"]
                                                                 withFrame:CGRectMake(self.barChartView.frame.origin.x - 30,
                                                                                      self.barChartView.frame.origin.y,
                                                                                      30,
                                                                                      self.barChartView.frame.size.height)];
    [self.view addSubview:self.sider];
    [self.view addSubview:self.footer];
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
    [super graphAll:sender];
    self.currentAmountOfData = ODDGraphAmountAll;
    [self.barChartView reloadData];
}

- (IBAction)graphShortTerm:(id)sender {
    [super graphShortTerm:sender];
    self.currentAmountOfData = ODDGraphAmountShortTerm;
    [self.barChartView reloadData];
}

- (IBAction)graphMedium:(id)sender {
    [super graphMedium:sender];
    self.currentAmountOfData = ODDGraphAmountMedium;
    [self.barChartView reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.barChartView touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self.barChartView touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.barChartView touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.barChartView touchesMoved:touches withEvent:event];
}


@end
