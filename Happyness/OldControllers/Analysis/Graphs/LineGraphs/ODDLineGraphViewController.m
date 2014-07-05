//
//  ODDLineGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDLineGraphViewController.h"

@interface ODDLineGraphViewController () <JBLineChartViewDataSource, JBLineChartViewDelegate>

@end

@implementation ODDLineGraphViewController
@synthesize lineGraphView = _lineGraphView;

#pragma mark - Init/Alloc

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeLineGraph];
}

#pragma mark - Subviews Init/Layout

- (void)initializeLineGraph {
    self.shortTermCount = 20;
    self.mediumCount = 50;
    self.lineGraphView.maximumValue = 5;
    self.lineGraphView.minimumValue = 0;
    
    self.lineGraphView.delegate = self;
    self.lineGraphView.dataSource = self;
    self.lineGraphView.userInteractionEnabled = NO;
    CGRect rootFrame = self.view.frame;
    CGRect graphTitleFrame = self.graphTitle.frame;
    CGFloat heightPadding = CGRectGetMaxY(graphTitleFrame);
    heightPadding += (heightPadding / 3);
    CGFloat widthPadding = graphTitleFrame.origin.x;
    widthPadding += (widthPadding / 3);
    self.lineGraphView.frame = CGRectMake(widthPadding,
                                          heightPadding,
                                          rootFrame.size.width - (widthPadding * 2),
                                          rootFrame.size.height - (heightPadding * 2));
    
    // Should initialize footer and sider in landscapeAnalysisViewController
    CGRect lineGraphFrame = self.lineGraphView.frame;
    CGSize lineGraphSize = lineGraphFrame.size;
    CGPoint lineGraphPosition = lineGraphFrame.origin;
    CGFloat footerHeight = (rootFrame.size.height - lineGraphSize.height) / 6;
    self.footer = [[ODDGraphFooterView alloc] initWithElements:@[@"Mon",
                                                                 @"Tues",
                                                                 @"Wed",
                                                                 @"Thurs",
                                                                 @"Fri",
                                                                 @"Sat",
                                                                 @"Sun"]
                                                     withFrame:CGRectMake(lineGraphPosition.x,
                                                                          CGRectGetMaxY(lineGraphFrame),
                                                                          lineGraphSize.width,
                                                                          footerHeight)];
    CGFloat siderWidth = (rootFrame.size.width - lineGraphSize.width) / 6;
    self.sider = [[ODDGraphSiderView alloc] initWithElements:@[@"5",
                                                               @"4",
                                                               @"3",
                                                               @"2",
                                                               @"1",
                                                               @"0"]
                                                   withFrame:CGRectMake(lineGraphPosition.x - siderWidth,
                                                                        lineGraphPosition.y,
                                                                        siderWidth,
                                                                        lineGraphSize.height)];
    [self.view addSubview:self.lineGraphView];
    [self.view addSubview:self.lineGraphView];
}

#pragma mark - Setup Datastore

- (void)reloadDataStore {
    [super reloadDataStore];
}

#pragma mark - Graph Delegate Setup

// TODO: Add property numberOfLines
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
    if (self.currentAmountOfData == ODDGraphAmountAll) {
        return [self.allData getValueAtIndex:horizontalIndex];
    } else if (self.currentAmountOfData == ODDGraphAmountMedium) {
        return [self.mediumeData getValueAtIndex:horizontalIndex];
    } else {
        return [self.shortData getValueAtIndex:horizontalIndex];
    }
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex {
    return FALSE;
}

#pragma mark - Graph Selection

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

#pragma mark - Button IBActions

- (IBAction)graphAll:(id)sender {
    [super graphAll:sender];
    self.currentAmountOfData = ODDGraphAmountAll;
    [self.lineGraphView reloadData];
}

- (IBAction)graphShortTerm:(id)sender {
    [super graphShortTerm:sender];
    self.currentAmountOfData = ODDGraphAmountShortTerm;
    [self.lineGraphView reloadData];
}

- (IBAction)graphMedium:(id)sender {
    [super graphMedium:sender];
    self.currentAmountOfData = ODDGraphAmountMedium;
    [self.lineGraphView reloadData];
}

#pragma mark - Touch Events

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
