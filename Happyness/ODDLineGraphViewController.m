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
#import "ODDDoubleArrayHolder.h"

@interface ODDLineGraphViewController () <JBLineChartViewDataSource, JBLineChartViewDelegate>

@property CGFloat happynessEntrySum;
@property (nonatomic,strong) ODDDoubleArrayHolder *allEntries;
@property (nonatomic,strong) ODDDoubleArrayHolder *mediumEntries;
@property (nonatomic,strong) ODDDoubleArrayHolder *shortTermEntries;

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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadDataStore)
                                                     name:@"reloadGraphData" object:nil];
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
    self.lineGraphView.maximumValue = 5;
    self.lineGraphView.minimumValue = 0;
    
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
    self.happynessEntrySum = 0;
    [self.lineGraphView reloadData];
}

#pragma mark - Setup Datastore

- (void)reloadDataStore {
    [super reloadDataStore];
    
    // Initialize self.allEntries
    NSUInteger numberOfAllEntries = self.entries.count;
    ODDDoubleArrayHolder *allEntriesRatings = [[ODDDoubleArrayHolder alloc] initWithCount:numberOfAllEntries];
    NSUInteger index = 0;
    for (ODDHappynessEntry *happynessItem in self.entries) {
        [allEntriesRatings setValue:(double)happynessItem.happyness.rating atIndex:index];
        index++;
    }
    self.allEntries =
        [[ODDDoubleArrayHolder alloc] initWithCount:numberOfAllEntries
                                        withValues:polynomailFitCoordinates((int)numberOfAllEntries,
                                                                            [allEntriesRatings getValues],
                                                                            10)];
    
    // Initialize self.mediumEntries;
    NSUInteger numberOfMediumEntries = self.mediumCount;
    if (numberOfAllEntries < numberOfMediumEntries) {
        numberOfMediumEntries = numberOfAllEntries;
    }
    ODDDoubleArrayHolder *mediumEntriesRatings =
        [allEntriesRatings subarrayWithRange:NSMakeRange(numberOfAllEntries - numberOfMediumEntries,
                                                         numberOfAllEntries)];
    self.mediumEntries =
        [[ODDDoubleArrayHolder alloc] initWithCount:numberOfMediumEntries
                                        withValues:polynomailFitCoordinates((int)numberOfMediumEntries,
                                                                            [mediumEntriesRatings getValues],
                                                                            6)];

    // Initialize self.shortTermEntries;
    NSUInteger numberOfShortTermEntries = self.shortTermCount;
    if (numberOfAllEntries < numberOfShortTermEntries) {
        numberOfShortTermEntries = numberOfAllEntries;
    }
    ODDDoubleArrayHolder *shortTermRatings =
        [mediumEntriesRatings subarrayWithRange:NSMakeRange(numberOfMediumEntries - numberOfShortTermEntries,
                                                            numberOfMediumEntries)];
    self.shortTermEntries =
         [[ODDDoubleArrayHolder alloc] initWithCount:numberOfShortTermEntries
                                         withValues:polynomailFitCoordinates((int)numberOfShortTermEntries,
                                                                             [shortTermRatings getValues],
                                                                             3)];
    [self.lineGraphView reloadData];
}

#pragma mark - Graph Delegate Setup

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
        return [self.allEntries getValueAtIndex:horizontalIndex];
    } else if (self.currentAmountOfData == ODDGraphAmountMedium) {
        return [self.mediumEntries getValueAtIndex:horizontalIndex];
    } else {
        return [self.shortTermEntries getValueAtIndex:horizontalIndex];
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
