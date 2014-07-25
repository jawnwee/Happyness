//
//  ODDLineGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDLineGraphViewController.h"
#define NUMBER_OF_XAXIS_LABELS 7


@interface ODDLineGraphViewController () <JBLineChartViewDataSource, JBLineChartViewDelegate>

@end

@implementation ODDLineGraphViewController
@synthesize lineGraphView = _graph;

#pragma mark - Init/Alloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
}

#pragma mark - Setters

- (void)setFrameSize:(CGSize)size {
    [super setFrameSize:size];
}

- (void)setFramePosition:(CGPoint)point {
    [super setFramePosition:point];
}

#pragma mark - Subviews Init/Layout

- (void)initializeLineGraph {
    self.lineGraphView = [[JBLineChartView alloc] init];
    self.shortTermCount = 7;
    self.mediumCount = 31;
    self.lineGraphView.maximumValue = 102;
    self.lineGraphView.minimumValue = 8;
    
    self.lineGraphView.delegate = self;
    self.lineGraphView.dataSource = self;
    self.lineGraphView.userInteractionEnabled = NO;
    self.lineGraphView.showsLineSelection = NO;
    self.lineGraphView.showsVerticalSelection = NO;
    CGRect rootFrame = self.view.frame;
    CGRect topFrame = self.topFrame.frame;
    CGRect graphShortTermButtonFrame = self.graphShortTerm.frame;
    CGFloat heightPadding = CGRectGetMaxY(topFrame);
    heightPadding += (heightPadding / 3);
    CGFloat widthPadding = graphShortTermButtonFrame.origin.x;
    widthPadding += (widthPadding / 2);
    self.lineGraphView.frame = CGRectMake(widthPadding,
                                          heightPadding,
                                          rootFrame.size.width - (widthPadding * 2),
                                          rootFrame.size.height - (heightPadding * 2));
    
    CGRect lineGraphFrame = self.lineGraphView.frame;
    CGSize lineGraphSize = lineGraphFrame.size;
    CGPoint lineGraphPosition = lineGraphFrame.origin;
    CGFloat footerHeight = (rootFrame.size.height - lineGraphSize.height);
    CGFloat siderPaddingFromGraph = 5;
    CGFloat extraRightSpace = 10;
    CGFloat siderWidth = (rootFrame.size.width - lineGraphSize.width) / 6;
    self.footer = [[ODDGraphFooterView alloc] initWithElements:@[]
                                                     withFrame:CGRectMake(lineGraphPosition.x -
                                                                            siderPaddingFromGraph -
                                                                            siderWidth,
                                                                          CGRectGetMaxY(lineGraphFrame),
                                                                          lineGraphSize.width +
                                                                           siderPaddingFromGraph +
                                                                            siderWidth +
                                                                            extraRightSpace,
                                                                          footerHeight)];
    self.footer.isBarChart = NO;
    self.footer.siderPadding = siderPaddingFromGraph + siderWidth;
    self.footer.rightPadding = extraRightSpace;
    self.sider = [[ODDColoredAxisView alloc] initWithFrame:CGRectMake(lineGraphPosition.x -
                                                                        siderWidth -
                                                                        siderPaddingFromGraph,
                                                                      lineGraphPosition.y,
                                                                      siderWidth,
                                                                      lineGraphSize.height)];
    CGRect backgroundLinesFrame = lineGraphFrame;
    backgroundLinesFrame.origin.x -= siderPaddingFromGraph;
    backgroundLinesFrame.size.width += siderPaddingFromGraph + extraRightSpace;
    self.backgroundLines = [[ODDColoredLinesView alloc] initWithFrame:backgroundLinesFrame];
    [self.view addSubview:self.lineGraphView];
}

#pragma mark - Setup Datastore

- (void)reloadDataStore {
    [super reloadDataStore];
    [self reloadXAxis];
}

#pragma mark - Setup XAxis

- (void)reloadXAxis {
    NSMutableArray *newLabels = [[NSMutableArray alloc] init];
    NSDate *nextDateToAdd = ((ODDHappynessEntry *)[self.entries lastObject]).date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d"];
    CGFloat secondsPerDay = 60 * 60 * 24;
    if (self.currentAmountOfData == ODDGraphAmountShortTerm) {
        for (NSUInteger i = 1; i <= NUMBER_OF_XAXIS_LABELS; i++) {
            NSInteger actualIndex = self.entries.count - i;
            if (actualIndex < 0) {
                break;
            }
            ODDHappynessEntry *entry = self.entries[actualIndex];
            [newLabels insertObject:[dateFormatter stringFromDate:entry.date] atIndex:0];
        }
    } else if (self.currentAmountOfData == ODDGraphAmountMedium &&
               self.entries.count >= self.mediumCount) {
        for (NSUInteger i = 0; i < NUMBER_OF_XAXIS_LABELS; i++) {
            [newLabels insertObject:[dateFormatter stringFromDate:nextDateToAdd] atIndex:0];
            nextDateToAdd = [NSDate dateWithTimeInterval:-(secondsPerDay * 5) sinceDate:nextDateToAdd];
        }
    } else if (self.currentAmountOfData == ODDGraphAmountAll &&
               self.entries.count >= self.mediumCount) {
        NSDate *mostRecentDate = nextDateToAdd;
        NSDate *nextDateToAdd = ((ODDHappynessEntry *)[self.entries firstObject]).date;
        CGFloat timeDifference = [mostRecentDate timeIntervalSinceDate:nextDateToAdd];
        NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
        [yearFormatter setDateFormat:@"yyyy"];
        NSString *firstDate = [dateFormatter stringFromDate:nextDateToAdd];
        firstDate = [firstDate stringByAppendingString:@"\n"];
        firstDate = [firstDate stringByAppendingString:[yearFormatter stringFromDate:nextDateToAdd]];
        [newLabels addObject:firstDate];
        CGFloat timeDelta = timeDifference / 6;
        nextDateToAdd = [NSDate dateWithTimeInterval:timeDelta sinceDate:nextDateToAdd];
        for (NSUInteger i = 1; i < NUMBER_OF_XAXIS_LABELS - 1; i++) {
            [newLabels addObject:[dateFormatter stringFromDate:nextDateToAdd]];
            nextDateToAdd = [NSDate dateWithTimeInterval:timeDelta sinceDate:nextDateToAdd];
        }
        NSString *lastDate = [dateFormatter stringFromDate:mostRecentDate];
        lastDate = [lastDate stringByAppendingString:@"\n"];
        lastDate = [lastDate stringByAppendingString:[yearFormatter stringFromDate:mostRecentDate]];
        [newLabels addObject:lastDate];
    }
    [self.footer setElements:newLabels];
}

#pragma mark - Graph Delegate Setup

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView {
    if (self.entries.count > 0) {
        [self.notEnoughDataLabel removeFromSuperview];
        [self.view addSubview:self.backgroundLines];
        [self.view addSubview:self.sider];
        [self.view addSubview:self.footer];
        [self.view bringSubviewToFront:self.lineGraphView];
        if (self.currentAmountOfData == ODDGraphAmountShortTerm) {
            return 1;
        } else if (self.currentAmountOfData == ODDGraphAmountMedium) {
            if (self.entries.count < self.mediumCount) {
                [self.backgroundLines removeFromSuperview];
                [self.sider removeFromSuperview];
                [self.footer removeFromSuperview];
                [self.view addSubview:self.notEnoughDataLabel];
                return 0;
            }
            return 1;
        } else if (self.currentAmountOfData == ODDGraphAmountAll) {
            if  (self.entries.count < self.mediumCount) {
                [self.backgroundLines removeFromSuperview];
                [self.sider removeFromSuperview];
                [self.footer removeFromSuperview];
                [self.view addSubview:self.notEnoughDataLabel];
                return 0;
            }
            return 1;
        }
    } else {
        [self.backgroundLines removeFromSuperview];
        [self.sider removeFromSuperview];
        [self.footer removeFromSuperview];
        [self.view addSubview:self.notEnoughDataLabel];
        return 0;
    }
    return 0;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView
numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex {
    if (self.currentAmountOfData == ODDGraphAmountShortTerm) {
        if (self.entries.count < self.shortTermCount) {
            return self.entries.count;
        }
        return self.shortTermCount;
    } else if (self.currentAmountOfData == ODDGraphAmountMedium) {
        return self.mediumCount;
    } else if (self.currentAmountOfData == ODDGraphAmountAll) {
        return [[ODDHappynessEntryStore sharedStore].happynessEntries count];
    }
    return 0;
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

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView
   colorForLineAtLineIndex:(NSUInteger)lineIndex {
    return self.colors[@"oddLook_textcolor"];
}

#pragma mark - Graph Selection

- (UIColor *)verticalSelectionColorForLineChartView:(JBLineChartView *)lineChartView {
    return self.colors[@"oddLook_textcolor"];
}

- (CGFloat)verticalSelectionWidthForLineChartView:(JBLineChartView *)lineChartView {
    return 1.0;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView
selectionColorForLineAtLineIndex:(NSUInteger)lineIndex {
    return self.colors[@"oddLook_textcolor"];
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
    [self reloadXAxis];
}

- (IBAction)graphShortTerm:(id)sender {
    [super graphShortTerm:sender];
    self.currentAmountOfData = ODDGraphAmountShortTerm;
    [self.lineGraphView reloadData];
    [self reloadXAxis];
}

- (IBAction)graphMedium:(id)sender {
    [super graphMedium:sender];
    self.currentAmountOfData = ODDGraphAmountMedium;
    [self.lineGraphView reloadData];
    [self reloadXAxis];
}

#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.lineGraphView.showsVerticalSelection) {
        [super touchesBegan:touches withEvent:event];
        [self.lineGraphView touchesBegan:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.lineGraphView.showsVerticalSelection) {
        [super touchesCancelled:touches withEvent:event];
        [self.lineGraphView touchesCancelled:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.lineGraphView.showsVerticalSelection) {
        [super touchesEnded:touches withEvent:event];
        [self.lineGraphView touchesEnded:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.lineGraphView.showsVerticalSelection) {
        [self.lineGraphView touchesMoved:touches withEvent:event];
    }
}

@end
