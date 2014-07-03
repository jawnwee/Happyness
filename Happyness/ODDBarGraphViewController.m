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
#import "ODDDoubleArrayHolder.h"
#import "ODDHappynessEntry.h"
#import "ODDHappyness.h"

@interface ODDBarGraphViewController () <JBBarChartViewDataSource, JBBarChartViewDelegate>

@property (nonatomic,strong) ODDDoubleArrayHolder *allBarHeights;
@property (nonatomic,strong) ODDDoubleArrayHolder *mediumBarHeights;
@property (nonatomic,strong) ODDDoubleArrayHolder *shortTermBarHeights;

@end

@implementation ODDBarGraphViewController
@synthesize barChartView = _barChartView;
@synthesize numberOfBars = _numberOfBars;

#pragma mark - Init/Alloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _barChartView = [[JBBarChartView alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadDataStoreByDays)
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
    
    [self initializeBarGraph];
}

#pragma mark - Subviews Init/Layout

- (void)initializeBarGraph {
    self.shortTermCount = 20;
    self.mediumCount = 50;
    
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    self.barChartView.userInteractionEnabled = NO;
    CGRect rootFrame = self.view.frame;
    CGRect graphTitleFrame = self.graphTitle.frame;
    CGFloat heightPadding = CGRectGetMaxY(graphTitleFrame);
    heightPadding += (heightPadding / 3);
    CGFloat widthPadding = graphTitleFrame.origin.x;
    widthPadding += (widthPadding / 3);
    self.barChartView.frame = CGRectMake(widthPadding,
                                         heightPadding,
                                         rootFrame.size.width - (widthPadding * 2),
                                         rootFrame.size.height - (heightPadding * 2));
    self.barChartView.maximumValue = 5;
    self.barChartView.minimumValue = 0;
    
    // Should initialize footer and sider in landscapeAnalysisViewController
    CGRect barChartFrame = self.barChartView.frame;
    CGSize barChartSize = barChartFrame.size;
    CGPoint barChartPosition = barChartFrame.origin;
    CGFloat footerHeight = (rootFrame.size.height - barChartSize.height) / 6;
    self.footer = [[ODDGraphFooterView alloc] initWithElements:@[@"Sun",
                                                                 @"Mon",
                                                                 @"Tues",
                                                                 @"Wed",
                                                                 @"Thurs",
                                                                 @"Fri",
                                                                 @"Sat"]
                                                     withFrame:CGRectMake(barChartPosition.x,
                                                                          CGRectGetMaxY(barChartFrame),
                                                                          barChartSize.width,
                                                                          footerHeight)];
    CGFloat siderWidth = (rootFrame.size.width - barChartSize.width) / 6;
    self.sider = [[ODDGraphSiderView alloc] initWithElements:@[@"5",
                                                               @"4",
                                                               @"3",
                                                               @"2",
                                                               @"1",
                                                               @"0"]
                                                   withFrame:CGRectMake(barChartPosition.x - siderWidth,
                                                                        barChartPosition.y,
                                                                        siderWidth,
                                                                        barChartSize.height)];
    [self.view addSubview:self.sider];
    [self.view addSubview:self.footer];
    [self.view addSubview:self.barChartView];
    [self.barChartView reloadData];
}

#pragma mark - Setup Datastore

- (void)reloadDataStore {
    [super reloadDataStore];
    
    // Doesn't follow OOP :(
    double barHeightsValues[7] = { 0 };
    self.allBarHeights = [[ODDDoubleArrayHolder alloc] initWithCount:self.numberOfBars
                                                          withValues:barHeightsValues];
    self.mediumBarHeights = [[ODDDoubleArrayHolder alloc] initWithCount:self.numberOfBars
                                                             withValues:barHeightsValues];
    self.shortTermBarHeights = [[ODDDoubleArrayHolder alloc] initWithCount:self.numberOfBars
                                                                withValues:barHeightsValues];
}

// Doesn't follow OOP :(
- (void)reloadDataStoreByDays {
    [self reloadDataStore];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    double dayCountsValues[7] = { 0 };
    ODDDoubleArrayHolder *allDayCounts = [[ODDDoubleArrayHolder alloc] initWithCount:7
                                                                          withValues:dayCountsValues];
    ODDDoubleArrayHolder *mediumDayCounts = [[ODDDoubleArrayHolder alloc] initWithCount:7
                                                                             withValues:dayCountsValues];
    ODDDoubleArrayHolder *shortTermDayCounts = [[ODDDoubleArrayHolder alloc] initWithCount:7
                                                                                withValues:dayCountsValues];
    NSUInteger forLoopCount = 0;
    NSUInteger entriesCount = self.entries.count;
    for (ODDHappynessEntry *entry in self.entries) {
        NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:entry.date];
        NSInteger weekday = [comps weekday] - 1;
        [self.allBarHeights setValue:((double)entry.happyness.rating +
                                        [self.allBarHeights getValueAtIndex:weekday])
                             atIndex:weekday];
        [allDayCounts setValue:([allDayCounts getValueAtIndex:weekday] + 1) atIndex:weekday];
        
        if ((entriesCount - forLoopCount) <= self.mediumCount) {
            [self.mediumBarHeights setValue:((double)entry.happyness.rating +
                                             [self.mediumBarHeights getValueAtIndex:weekday])
                                    atIndex:weekday];
            [mediumDayCounts setValue:([mediumDayCounts getValueAtIndex:weekday] + 1)
                              atIndex:weekday];
        }
        
        if ((entriesCount - forLoopCount) <= self.shortTermCount) {
            [self.shortTermBarHeights setValue:((double)entry.happyness.rating +
                                                [self.shortTermBarHeights getValueAtIndex:weekday])
                                       atIndex:weekday];
            [shortTermDayCounts setValue:([shortTermDayCounts getValueAtIndex:weekday] + 1)
                                 atIndex:weekday];
        }
        
        forLoopCount++;
    }
    
    for (NSUInteger i = 0; i < 7; i++) {
        [self.allBarHeights setValue:([self.allBarHeights getValueAtIndex:i] /
                                      [allDayCounts getValueAtIndex:i])
                             atIndex:i];
        [self.mediumBarHeights setValue:([self.mediumBarHeights getValueAtIndex:i] /
                                         [mediumDayCounts getValueAtIndex:i])
                                atIndex:i];
        [self.shortTermBarHeights setValue:([self.shortTermBarHeights getValueAtIndex:i] /
                                            [shortTermDayCounts getValueAtIndex:i])
                                   atIndex:i];
    }

    [self.barChartView reloadData];
}

#pragma mark - Graph Delegate Setup

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView {
    return self.numberOfBars;
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index {
    if (self.currentAmountOfData == ODDGraphAmountAll) {
        return [self.allBarHeights getValueAtIndex:index];
    } else if (self.currentAmountOfData == ODDGraphAmountMedium) {
        return [self.mediumBarHeights getValueAtIndex:index];
    } else {
        return [self.shortTermBarHeights getValueAtIndex:index];
    }
}

#pragma mark - Graph Selection



#pragma mark - Button IBActions

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

#pragma mark - Touch Events

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
