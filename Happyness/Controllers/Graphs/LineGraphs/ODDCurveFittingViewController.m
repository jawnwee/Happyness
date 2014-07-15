//
//  ODDCurveFittingViewController.m
//  Happyness
//
//  Created by Yujun Cho on 7/3/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCurveFittingViewController.h"

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
    self.lineGraphView.maximumValue = 5.5;
    self.lineGraphView.minimumValue = .5;
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
        self.numberOfMediumEntries = 580;
        NSUInteger mediumEntriesRatingsCount = 0;
        if (numberOfAllEntries < self.mediumCount) {
            self.numberOfMediumEntries = numberOfAllEntries;
            mediumEntriesRatingsCount = self.numberOfMediumEntries;
        } else {
            NSDate *latestDate = ((ODDHappynessEntry *)[self.entries lastObject]).date;
            mediumEntriesRatingsCount += 1;
            CGFloat secondsPerDay = 60 * 60 * 24;
            CGFloat secondsForMediumCount = self.mediumCount * secondsPerDay;
            for (NSInteger i = self.entries.count - 2; i >= 0; i--) {
                NSDate *nextDate = ((ODDHappynessEntry *)self.entries[i]).date;
                CGFloat timeInterval = [latestDate timeIntervalSinceDate:nextDate];
                if (timeInterval > secondsForMediumCount) {
                    break;
                }
                mediumEntriesRatingsCount++;
            }
            ODDDoubleArrayHolder *mediumEntriesRatings =
            [allEntriesRatings subarrayWithRange:NSMakeRange(numberOfAllEntries - (mediumEntriesRatingsCount),
                                                             numberOfAllEntries)];

            if (mediumEntriesRatingsCount < self.mediumCount) {
                NSDate *mostRecentDate = ((ODDHappynessEntry *)self.entries[self.entries.count -
                                                                            mediumEntriesRatingsCount -
                                                                            2]).date;
                int startDifference = ceil([latestDate timeIntervalSinceDate:mostRecentDate] / secondsPerDay);
                self.mediumeData =
                [[ODDDoubleArrayHolder alloc] initWithCount:self.numberOfMediumEntries
                                                 withValues:polynomialFitCoordinatesExtraData((int)mediumEntriesRatingsCount,
                                                                                              [mediumEntriesRatings getValues],
                                                                                              POLYFIT_DEGREE,
                                                                                              (int)self.numberOfMediumEntries,
                                                                                              startDifference)];
            } else {
                self.mediumeData =
                [[ODDDoubleArrayHolder alloc] initWithCount:self.numberOfMediumEntries
                                                 withValues:polynomialFitCoordinatesExtraData((int)self.mediumCount,
                                                                                              [mediumEntriesRatings getValues],
                                                                                              POLYFIT_DEGREE,
                                                                                              (int)self.numberOfMediumEntries,
                                                                                              0)];
            }
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
