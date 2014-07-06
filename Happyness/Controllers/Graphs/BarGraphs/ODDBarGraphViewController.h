//
//  ODDBarGraphViewController.h
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODDGraphViewController.h"
#import "JBBarChartView.h"

@interface ODDBarGraphViewController : ODDGraphViewController <JBBarChartViewDataSource, JBBarChartViewDelegate>

@property (nonatomic,strong) JBBarChartView *barChartView;
@property NSUInteger numberOfBars;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)initializeBarGraph;
- (void)reloadDataStore;

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView;
- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index;

- (IBAction)graphShortTerm:(id)sender;
- (IBAction)graphMedium:(id)sender;
- (IBAction)graphAll:(id)sender;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end
