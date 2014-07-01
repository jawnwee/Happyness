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
#import "ODDHappynessEntryStore.h"
#import "ODDHappynessEntry.h"
#import "ODDHappyness.h"

@interface ODDLineGraphViewController () <JBLineChartViewDataSource, JBLineChartViewDelegate>

@property CGFloat happynessEntrySum;

@end

@implementation ODDLineGraphViewController
@synthesize lineGraphView = _lineGraphView;

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
    [super viewDidLoad];
    
    [self initializeLineGraph];
}

- (void)initializeLineGraph {
    self.shortTermCount = 20;
    self.mediumCount = 50;
    self.lineGraphView.tag = 200;
    
    self.lineGraphView.delegate = self;
    self.lineGraphView.dataSource = self;
    self.lineGraphView.userInteractionEnabled = NO;
    CGRect rootFrame = self.view.frame;
    CGRect graphTitleFrame = self.graphTitle.frame;
    CGFloat heighPadding = CGRectGetMaxY(graphTitleFrame);
    self.lineGraphView.frame = CGRectMake(graphTitleFrame.origin.x,
                                         heighPadding,
                                         rootFrame.size.width - (graphTitleFrame.origin.x * 2),
                                         rootFrame.size.height - (heighPadding * 2));
//    self.lineGraphView.maximumValue = 5;
    self.lineGraphView.minimumValue = 0;
    CGFloat bordersFramePadding = self.topFrame.frame.size.height / 2;
    self.footer = [[ODDGraphFooterView alloc] initWithElements:@[@"Mon",
                                                                                @"Tues",
                                                                                @"Wed",
                                                                                @"Thurs",
                                                                                @"Fri",
                                                                                @"Sat",
                                                                                @"Sun"]
                                                                    withFrame:CGRectMake(graphTitleFrame.origin.x,
                                                                                         CGRectGetMaxY(self.lineGraphView.frame),
                                                                                         self.lineGraphView.frame.size.width,
                                                                                         bordersFramePadding)];
    self.sider = [[ODDGraphSiderView alloc] initWithElements:@[@"100",
                                                                             @"80",
                                                                             @"60",
                                                                             @"40",
                                                                             @"20",
                                                                             @"0"]
                                                                 withFrame:CGRectMake(self.lineGraphView.frame.origin.x - bordersFramePadding,
                                                                                      self.lineGraphView.frame.origin.y,
                                                                                      bordersFramePadding,
                                                                                      self.lineGraphView.frame.size.height)];
    [self.view addSubview:self.lineGraphView];
    [self.view addSubview:self.lineGraphView];
    self.happynessEntrySum = 0;
    [self.lineGraphView reloadData];
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    if (self.entries.count > 0) {
        [self.view addSubview:self.sider];
        [self.view addSubview:self.footer];
        return 1;
    } else {
        [self.sider removeFromSuperview];
        [self.footer removeFromSuperview];
        return 0;
    }
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView
    numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    if (self.currentAmountOfData == ODDGraphAmountAll) {
        return [[ODDHappynessEntryStore sharedStore].happynessEntries count];
    } else if (self.currentAmountOfData == ODDGraphAmountMedium) {
        return self.mediumCount;
    } else {
        return self.shortTermCount;
    }
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView
    verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex
                        atLineIndex:(NSUInteger)lineIndex {
    NSInteger happynessRating = ((ODDHappynessEntry *)self.entries[horizontalIndex]).happyness.rating;
    if (horizontalIndex > 1) {
        self.happynessEntrySum = (self.happynessEntrySum * (horizontalIndex - 1)) / horizontalIndex;
        self.happynessEntrySum += happynessRating;
    } else {
        self.happynessEntrySum += happynessRating;
    }
    return happynessRating;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex {
    return TRUE;
}

#pragma mark - Touch Events

- (UIColor *)verticalSelectionColorForLineChartView:(JBLineChartView *)lineChartView {
    return [UIColor redColor];
}

- (CGFloat)verticalSelectionWidthForLineChartView:(JBLineChartView *)lineChartView {
    return 1.0;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView
    selectionColorForLineAtLineIndex:(NSUInteger)lineIndex {
    return [UIColor lightGrayColor];
}

- (void)lineChartView:(JBLineChartView *)lineChartView
    didSelectLineAtIndex:(NSUInteger)lineIndex
         horizontalIndex:(NSUInteger)horizontalIndex {
    
}

#pragma mark - Amount of data to graph

- (IBAction)graphAll:(id)sender {
    [super graphAll:sender];
    self.happynessEntrySum = 0;
    self.currentAmountOfData = ODDGraphAmountAll;
    [self.lineGraphView reloadData];
}

- (IBAction)graphShortTerm:(id)sender {
    [super graphShortTerm:sender];
    self.happynessEntrySum = 0;
    self.currentAmountOfData = ODDGraphAmountShortTerm;
    [self.lineGraphView reloadData];
}

- (IBAction)graphMedium:(id)sender {
    [super graphMedium:sender];
    self.happynessEntrySum = 0;
    self.currentAmountOfData = ODDGraphAmountMedium;
    [self.lineGraphView reloadData];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.lineGraphView touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self.lineGraphView touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.lineGraphView touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.lineGraphView touchesMoved:touches withEvent:event];
}

@end
