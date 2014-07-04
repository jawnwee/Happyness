//
//  ODDCurveFittingViewController.m
//  Happyness
//
//  Created by Yujun Cho on 7/3/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCurveFittingViewController.h"

@interface ODDCurveFittingViewController ()

@end

@implementation ODDCurveFittingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Subviews Init/Layout

- (void)initializeLineGraph {
    [super initializeLineGraph];
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
    self.allData =
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
    self.mediumeData =
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
    self.shortData =
    [[ODDDoubleArrayHolder alloc] initWithCount:numberOfShortTermEntries
                                     withValues:polynomailFitCoordinates((int)numberOfShortTermEntries,
                                                                         [shortTermRatings getValues],
                                                                         3)];
    
    [self.lineGraphView reloadData];
}

#pragma mark - Graph Delegate Setup

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    return [super numberOfLinesInLineChartView:lineChartView];
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView
numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    return [super lineChartView:lineChartView numberOfVerticalValuesAtLineIndex:lineIndex];
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView
verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex
             atLineIndex:(NSUInteger)lineIndex {
    return [super lineChartView:lineChartView
verticalValueForHorizontalIndex:horizontalIndex
                    atLineIndex:lineIndex];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex {
    return [super lineChartView:lineChartView smoothLineAtLineIndex:lineIndex];
}

#pragma mark - Graph Selection

- (UIColor *)verticalSelectionColorForLineChartView:(JBLineChartView *)lineChartView {
    return [super verticalSelectionColorForLineChartView:lineChartView];
}

- (CGFloat)verticalSelectionWidthForLineChartView:(JBLineChartView *)lineChartView {
    return [super verticalSelectionWidthForLineChartView:lineChartView];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView
selectionColorForLineAtLineIndex:(NSUInteger)lineIndex {
    return [super lineChartView:lineChartView selectionColorForLineAtLineIndex:lineIndex];
}

- (void)lineChartView:(JBLineChartView *)lineChartView
 didSelectLineAtIndex:(NSUInteger)lineIndex
      horizontalIndex:(NSUInteger)horizontalIndex {
    [super lineChartView:lineChartView
    didSelectLineAtIndex:lineIndex
         horizontalIndex:horizontalIndex];
}

#pragma mark - Button IBActions

- (IBAction)graphAll:(id)sender {
    [super graphAll:sender];
}

- (IBAction)graphShortTerm:(id)sender {
    [super graphShortTerm:sender];
}

- (IBAction)graphMedium:(id)sender {
    [super graphMedium:sender];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

@end
