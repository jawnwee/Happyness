//
//  ODDLineGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDLineGraphViewController.h"

@interface ODDLineGraphViewController () <JBLineChartViewDataSource, JBLineChartViewDelegate>

@property CGRect originalGraphFrame;

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
    self.shortTermCount = 20;
    self.mediumCount = 50;
    self.lineGraphView.maximumValue = 5;
    self.lineGraphView.minimumValue = 0;
    
    self.lineGraphView.delegate = self;
    self.lineGraphView.dataSource = self;
    self.lineGraphView.userInteractionEnabled = NO;
    CGRect rootFrame = self.view.frame;
    CGRect topFrame = self.topFrame.frame;
    CGRect graphShortTermButtonFrame = self.graphShortTerm.frame;
    CGFloat heightPadding = CGRectGetMaxY(topFrame);
    heightPadding += (heightPadding / 3);
    CGFloat widthPadding = graphShortTermButtonFrame.origin.x;
    widthPadding += (widthPadding / 3);
    self.originalGraphFrame = CGRectMake(widthPadding,
                                         heightPadding,
                                         rootFrame.size.width - (widthPadding * 2),
                                         rootFrame.size.height - (heightPadding * 2));
    self.lineGraphView.frame = self.originalGraphFrame;
    
    // Should initialize footer and sider in landscapeAnalysisViewController
    CGRect lineGraphFrame = self.lineGraphView.frame;
    CGSize lineGraphSize = lineGraphFrame.size;
    CGPoint lineGraphPosition = lineGraphFrame.origin;
    CGFloat footerHeight = (rootFrame.size.height - lineGraphSize.height) / 6;
    CGFloat siderPaddingFromGraph = 1;
    self.footer = [[ODDGraphFooterView alloc] initWithElements:@[@"4/18",
                                                                 @"4/19",
                                                                 @"4/20",
                                                                 @"4/21",
                                                                 @"4/22",
                                                                 @"4/23",
                                                                 @"4/24"]
                                                     withFrame:CGRectMake(lineGraphPosition.x -
                                                                            siderPaddingFromGraph,
                                                                          CGRectGetMaxY(lineGraphFrame),
                                                                          lineGraphSize.width +
                                                                           siderPaddingFromGraph,
                                                                          footerHeight)];
    self.footer.siderPadding = siderPaddingFromGraph;
    CGFloat siderWidth = (rootFrame.size.width - lineGraphSize.width) / 6;
    CGRect backgroundLinesFrame = lineGraphFrame;
    backgroundLinesFrame.origin.x -= siderPaddingFromGraph;
    backgroundLinesFrame.size.width += siderPaddingFromGraph;
    self.sider = [[ODDColoredAxisView alloc] initWithFrame:CGRectMake(lineGraphPosition.x -
                                                                        siderWidth -
                                                                        siderPaddingFromGraph,
                                                                      lineGraphPosition.y,
                                                                      siderWidth,
                                                                      lineGraphSize.height)];
    ODDColoredLinesView *backgroundLines = [[ODDColoredLinesView alloc] initWithFrame:backgroundLinesFrame];
    [self.view addSubview:backgroundLines];
    [self.view sendSubviewToBack:backgroundLines];
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
    if (self.entries.count > 0) {
        [self.lineGraphView setFrame:self.originalGraphFrame];
        if (self.currentAmountOfData == ODDGraphAmountShortTerm) {
            if (self.entries.count < self.shortTermCount) {
                CGRect temporaryFrame = self.originalGraphFrame;
                temporaryFrame.size.width = (temporaryFrame.size.width / self.shortTermCount) *
                                                self.entries.count;
                [self.lineGraphView setFrame:temporaryFrame];
                return self.entries.count;
            }
            return self.shortTermCount;
        } else if (self.currentAmountOfData == ODDGraphAmountMedium) {
            if (self.entries.count < self.mediumCount) {
                return 0;
            }
            return self.mediumCount;
        } else if (self.currentAmountOfData == ODDGraphAmountAll) {
            if  (self.entries.count < 40) {
                return 0;
            }
            return [[ODDHappynessEntryStore sharedStore].happynessEntries count];
        }
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
