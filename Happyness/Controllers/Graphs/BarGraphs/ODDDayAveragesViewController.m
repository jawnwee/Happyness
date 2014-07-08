//
//  ODDDayAveragesViewController.m
//  Happyness
//
//  Created by Yujun Cho on 7/3/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDDayAveragesViewController.h"

@interface ODDDayAveragesViewController ()

@end

@implementation ODDDayAveragesViewController

#pragma mark - Alloc/Init

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
    
    [self initializeBarGraph];
}

- (void)setFramePosition:(CGPoint)point {
    [super setFramePosition:point];
}

#pragma mark - Subviews Init/Layout

- (void)initializeBarGraph {
    [super initializeBarGraph];
    self.graphTitle = @"Daily Averages";
}

#pragma mark - Setup Datastore

- (void)reloadDataStore {
    [super reloadDataStore];
    
    if (self.numberOfBars != 7) {
        @throw [NSException exceptionWithName:@"IncorrectSetup"
                                       reason:@"Incorrect number of bars"
                                     userInfo:nil];
    }
    
    
    double barHeightsValues[7] = { 0 };
    self.allData = [[ODDDoubleArrayHolder alloc] initWithCount:self.numberOfBars
                                                    withValues:barHeightsValues];
    self.mediumeData = [[ODDDoubleArrayHolder alloc] initWithCount:self.numberOfBars
                                                        withValues:barHeightsValues];
    self.shortData = [[ODDDoubleArrayHolder alloc] initWithCount:self.numberOfBars
                                                      withValues:barHeightsValues];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    double dayCountsValues[7] = { 0 };
    ODDDoubleArrayHolder *allDayCounts = [[ODDDoubleArrayHolder alloc] initWithCount:self.numberOfBars
                                                                          withValues:dayCountsValues];
    ODDDoubleArrayHolder *mediumDayCounts = [[ODDDoubleArrayHolder alloc] initWithCount:self.numberOfBars
                                                                             withValues:dayCountsValues];
    ODDDoubleArrayHolder *shortTermDayCounts = [[ODDDoubleArrayHolder alloc] initWithCount:self.numberOfBars
                                                                                withValues:dayCountsValues];
    NSUInteger forLoopCount = 0;
    NSUInteger entriesCount = self.entries.count;
    for (ODDHappynessEntry *entry in self.entries) {
        NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:entry.date];
        NSInteger weekday = [comps weekday] - 1;
        [self.allData setValue:((double)entry.happyness.rating +
                                [self.allData getValueAtIndex:weekday])
                       atIndex:weekday];
        [allDayCounts setValue:([allDayCounts getValueAtIndex:weekday] + 1) atIndex:weekday];
        
        if ((entriesCount - forLoopCount) <= self.mediumCount) {
            [self.mediumeData setValue:((double)entry.happyness.rating +
                                        [self.mediumeData getValueAtIndex:weekday])
                               atIndex:weekday];
            [mediumDayCounts setValue:([mediumDayCounts getValueAtIndex:weekday] + 1)
                              atIndex:weekday];
        }
        
        if ((entriesCount - forLoopCount) <= self.shortTermCount) {
            [self.shortData setValue:((double)entry.happyness.rating +
                                      [self.shortData getValueAtIndex:weekday])
                             atIndex:weekday];
            [shortTermDayCounts setValue:([shortTermDayCounts getValueAtIndex:weekday] + 1)
                                 atIndex:weekday];
        }
        
        forLoopCount++;
    }
    
    for (NSUInteger i = 0; i < 7; i++) {
        [self.allData setValue:([self.allData getValueAtIndex:i] /
                                [allDayCounts getValueAtIndex:i])
                       atIndex:i];
        [self.mediumeData setValue:([self.mediumeData getValueAtIndex:i] /
                                    [mediumDayCounts getValueAtIndex:i])
                           atIndex:i];
        [self.shortData setValue:([self.shortData getValueAtIndex:i] /
                                  [shortTermDayCounts getValueAtIndex:i])
                         atIndex:i];
    }
    
    [self.barChartView reloadData];
}

#pragma mark - Graph Delegate Setup

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView {
    return [super numberOfBarsInBarChartView:barChartView];
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index {
    return [super barChartView:barChartView heightForBarViewAtAtIndex:index];
}

#pragma mark - Graph Selection



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
