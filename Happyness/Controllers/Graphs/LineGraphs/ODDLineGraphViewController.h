//
//  ODDLineGraphViewController.h
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDGraphViewController.h"
#import "JBLineChartView.h"

@interface ODDLineGraphViewController : ODDGraphViewController

@property (nonatomic,strong) JBLineChartView *lineGraphView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)setFrameSize:(CGSize)size;
- (void)setFramePosition:(CGPoint)point;
- (void)initializeLineGraph;
- (void)reloadDataStore;

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView;
- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex;
- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex;
- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex;
- (UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForLineAtLineIndex:(NSUInteger)lineIndex;

- (UIColor *)verticalSelectionColorForLineChartView:(JBLineChartView *)lineChartView;
- (CGFloat)verticalSelectionWidthForLineChartView:(JBLineChartView *)lineChartView;
- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex;
- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex;

- (IBAction)graphShortTerm:(id)sender;
- (IBAction)graphMedium:(id)sender;
- (IBAction)graphAll:(id)sender;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end
