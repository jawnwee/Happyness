//
//  ODDCurveFittingViewController.m
//  Happyness
//
//  Created by Yujun Cho on 7/3/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCurveFittingViewController.h"

@interface ODDCurveFittingViewController ()

@property NSUInteger factor;

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

#pragma mark - Setters

- (void)setFrameSize:(CGSize)size {
    [super setFrameSize:size];
    
    [self initializeLineGraph];
}

- (void)setFramePosition:(CGPoint)point {
    [super setFramePosition:point];
}

#pragma mark - Subviews Init/Layout

- (void)initializeLineGraph {
    [super initializeLineGraph];
    self.shortTermCount = 7;
    self.mediumCount = 30;
    self.factor = 20;
    self.lineGraphView.maximumValue = 5.5;
    self.lineGraphView.minimumValue = .5;
    self.graphTitle = @"Trends";
}

#pragma mark - Setup Datastore

- (void)reloadDataStore {
    [super reloadDataStore];
    NSUInteger numberOfAllEntries = self.entries.count;
    if (self.entries.count > 0) {
        // Initialize self.allEntries
        ODDDoubleArrayHolder *allEntriesRatings = [[ODDDoubleArrayHolder alloc] initWithCount:numberOfAllEntries];
        NSUInteger index = 0;
        for (ODDHappynessEntry *happynessItem in self.entries) {
            [allEntriesRatings setValue:(double)happynessItem.happyness.rating atIndex:index];
            index++;
        }
        self.allData =
        [[ODDDoubleArrayHolder alloc] initWithCount:numberOfAllEntries
                                         withValues:polynomialFitCoordinates((int)numberOfAllEntries,
                                                                             [allEntriesRatings getValues],
                                                                             10)];
        
        // Initialize self.mediumEntries;
        NSUInteger numberOfMediumEntries = (self.mediumCount - 1) * self.factor;
        if (numberOfAllEntries < self.mediumCount) {
            numberOfMediumEntries = numberOfAllEntries;
        }
        ODDDoubleArrayHolder *mediumEntriesRatings =
        [allEntriesRatings subarrayWithRange:NSMakeRange(numberOfAllEntries - (self.mediumCount),
                                                         numberOfAllEntries)];
        self.mediumeData =
        [[ODDDoubleArrayHolder alloc] initWithCount:numberOfMediumEntries
                                         withValues:polynomialFitCoordinatesExtraData((int)self.mediumCount,
                                                                                      [mediumEntriesRatings getValues],
                                                                                      10,
                                                                                      (int)self.factor)];
        
        // Initialize self.shortTermEntries;
        NSUInteger numberOfShortTermEntries = self.shortTermCount;
        if (numberOfAllEntries < numberOfShortTermEntries) {
            numberOfShortTermEntries = numberOfAllEntries;
        }
        ODDDoubleArrayHolder *shortTermRatings =
        [allEntriesRatings subarrayWithRange:NSMakeRange(numberOfAllEntries - numberOfShortTermEntries,
                                                         numberOfAllEntries)];
        self.shortData =
        [[ODDDoubleArrayHolder alloc] initWithCount:numberOfShortTermEntries
                                         withValues:polynomialFitCoordinates((int)numberOfShortTermEntries,
                                                                             [shortTermRatings getValues],
                                                                             6)];
        
        [self.lineGraphView reloadData];
    }
}

#pragma mark - Graph Delegate Setup

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    return [super numberOfLinesInLineChartView:lineChartView];
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView
numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    if (self.currentAmountOfData == ODDGraphAmountMedium && self.entries.count >= self.mediumCount) {
        return (self.mediumCount - 1) * self.factor;
    } else {
        return [super lineChartView:lineChartView numberOfVerticalValuesAtLineIndex:lineIndex];
    }
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView
verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex
             atLineIndex:(NSUInteger)lineIndex {
    return [super lineChartView:lineChartView
verticalValueForHorizontalIndex:horizontalIndex
                    atLineIndex:lineIndex];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex {
//    return [super lineChartView:lineChartView smoothLineAtLineIndex:lineIndex];
    return NO;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex{
    if (self.currentAmountOfData == ODDGraphAmountShortTerm) {
        return YES;
    }
    return NO;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForLineAtLineIndex:(NSUInteger)lineIndex{
    return 7;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 1.5;
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

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView
selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex
                          atLineIndex:(NSUInteger)lineIndex {
    return [UIColor lightGrayColor];
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
