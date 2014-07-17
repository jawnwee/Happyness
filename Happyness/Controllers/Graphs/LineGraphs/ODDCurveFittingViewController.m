//
//  ODDCurveFittingViewController.m
//  Happyness
//
//  Created by Yujun Cho on 7/3/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCurveFittingViewController.h"
#import "ODDPolynomialFit.h"

#define ALL_COUNT_FOR_SMALL_DATA 500
#define POLYFIT_DEGREE 7

@interface ODDCurveFittingViewController ()

@property NSUInteger numberOfMediumEntries;

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
    self.graphTitle = @"Trends";
    [self.graphMedium setTitle:@"31 Days" forState:UIControlStateNormal];
    [self.graphShortTerm setTitle:@"7 Days" forState:UIControlStateNormal];
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
        if (numberOfAllEntries < ALL_COUNT_FOR_SMALL_DATA) {
            self.allData =
            [[ODDDoubleArrayHolder alloc] initWithCount:ALL_COUNT_FOR_SMALL_DATA
                                             withValues:polynomialFitCoordinatesExtraData((int)numberOfAllEntries,
                                                                                          [allEntriesRatings getValues],
                                                                                          POLYFIT_DEGREE,
                                                                                          ALL_COUNT_FOR_SMALL_DATA,
                                                                                          0)];
        } else {
            self.allData =
            [[ODDDoubleArrayHolder alloc] initWithCount:numberOfAllEntries
                                             withValues:polynomialFitCoordinates((int)numberOfAllEntries,
                                                                                 [allEntriesRatings getValues],
                                                                                 POLYFIT_DEGREE)];
        }
        
        // Initialize self.mediumEntries;
        self.numberOfMediumEntries = 500;
        if (numberOfAllEntries >= self.mediumCount) {
            CGFloat secondsPerDay = 60 * 60 * 24;
            CGFloat secondsForMediumCount = self.mediumCount * secondsPerDay;
            NSArray *mediumEntries =
                [self.entries subarrayWithRange:NSMakeRange(numberOfAllEntries - self.mediumCount,
                                                            self.mediumCount)];
            NSUInteger count = 0;
            NSDate *latestDate = ((ODDHappynessEntry *)[self.entries lastObject]).date;
            for (NSInteger i = mediumEntries.count - 2; i >= 0; i--) {
                NSDate *nextDate = ((ODDHappynessEntry *)mediumEntries[i]).date;
                CGFloat timeInterval = [latestDate timeIntervalSinceDate:nextDate];
                if (timeInterval > secondsForMediumCount) {
                    break;
                }
                count++;
            }
            // TODO: Correct usage of NSRange
            ODDDoubleArrayHolder *mediumEntriesRatings =
            [allEntriesRatings subarrayWithRange:NSMakeRange(numberOfAllEntries - self.mediumCount,
                                                             numberOfAllEntries)];
            NSDate *firstDate = ((ODDHappynessEntry *)mediumEntries[0]).date;
            NSDate *lastDate = ((ODDHappynessEntry *)[mediumEntries lastObject]).date;
            float totalDifference = ceil([lastDate timeIntervalSinceDate:firstDate]) / secondsPerDay;
            float startRatio = 1 - (self.mediumCount / totalDifference);
            if (startRatio < 0) {
                startRatio = 0;
            }
            float actualStart = startRatio * self.mediumCount;
            self.mediumeData =
            [[ODDDoubleArrayHolder alloc] initWithCount:self.numberOfMediumEntries
                                             withValues:polynomialFitCoordinatesExtraData((int)self.mediumCount,
                                                                                          [mediumEntriesRatings getValues],
                                                                                          POLYFIT_DEGREE,
                                                                                          (int)self.numberOfMediumEntries,
                                                                                          actualStart)];
        }
        
        
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
                                         withValues:[shortTermRatings getValues]];
        
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
        return self.numberOfMediumEntries;
    } else if (self.currentAmountOfData == ODDGraphAmountAll && self.entries.count < 500) {
        return ALL_COUNT_FOR_SMALL_DATA;
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

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView
   colorForLineAtLineIndex:(NSUInteger)lineIndex {
    return [super lineChartView:lineChartView colorForLineAtLineIndex:lineIndex];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView
  colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex
                   atLineIndex:(NSUInteger)lineIndex {
    return self.colors[@"oddLook_textcolor"];
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
    return self.colors[@"oddLook_textcolor"];
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
