//
//  ODDBarGraphViewController.m
//  Happyness
//
//  Created by Yujun Cho on 6/19/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDBarGraphViewController.h"

@interface ODDBarGraphViewController ()

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

- (void)initializeBarGraph {
    self.shortTermCount = 14;
    self.mediumCount = 60;
    self.barChartView.maximumValue = 5;
    self.barChartView.minimumValue = 0;
    [self.graphMedium setTitle:@"60 Days" forState:UIControlStateNormal];
    [self.graphShortTerm setTitle:@"14 Days" forState:UIControlStateNormal];
    
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    self.barChartView.userInteractionEnabled = NO;
    self.barChartView.showsVerticalSelection = NO;
    CGRect rootFrame = self.view.frame;
    CGRect topFrame = self.topFrame.frame;
    CGRect graphShortTermButtonFrame = self.graphShortTerm.frame;
    CGFloat heightPadding = CGRectGetMaxY(topFrame);
    heightPadding += (heightPadding / 3);
    CGFloat widthPadding = graphShortTermButtonFrame.origin.x;
    widthPadding += (widthPadding / 2);
    self.barChartView.frame = CGRectMake(widthPadding,
                                         heightPadding,
                                         rootFrame.size.width - (widthPadding * 2),
                                         rootFrame.size.height - (heightPadding * 2));
    
    CGRect barChartFrame = self.barChartView.frame;
    CGSize barChartSize = barChartFrame.size;
    CGPoint barChartPosition = barChartFrame.origin;
    CGFloat footerHeight = (rootFrame.size.height - barChartSize.height) / 6;
    CGFloat siderPaddingFromGraph = 5;
    CGFloat extraRightSpace = 10;
    CGFloat siderWidth = (rootFrame.size.width - barChartSize.width) / 6;
    self.footer = [[ODDGraphFooterView alloc] initWithElements:@[@"Sun",
                                                                 @"Mon",
                                                                 @"Tues",
                                                                 @"Wed",
                                                                 @"Thurs",
                                                                 @"Fri",
                                                                 @"Sat"]
                                                     withFrame:CGRectMake(barChartPosition.x -
                                                                            siderPaddingFromGraph -
                                                                            siderWidth,
                                                                          CGRectGetMaxY(barChartFrame),
                                                                          barChartSize.width +
                                                                            siderPaddingFromGraph +
                                                                            siderWidth +
                                                                            extraRightSpace,
                                                                          footerHeight)];
    self.footer.isBarChart = YES;
    self.footer.siderPadding = siderPaddingFromGraph + siderWidth;
    self.footer.rightPadding = extraRightSpace;
    self.sider = [[ODDColoredAxisView alloc] initWithFrame:CGRectMake(barChartPosition.x -
                                                                        siderWidth -
                                                                        siderPaddingFromGraph,
                                                                      barChartPosition.y,
                                                                      siderWidth,
                                                                      barChartSize.height)];
    CGRect backgroundLinesFrame = barChartFrame;
    backgroundLinesFrame.origin.x -= siderPaddingFromGraph;
    backgroundLinesFrame.size.width += siderPaddingFromGraph + extraRightSpace;
    self.backgroundLines = [[ODDColoredLinesView alloc] initWithFrame:backgroundLinesFrame];
    [self.view addSubview:self.barChartView];
}

#pragma mark - Setup Datastore

- (void)reloadDataStore {
    [super reloadDataStore];
}

#pragma mark - Graph Delegate Setup

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView {
    if (self.entries.count > 0) {
        [self.notEnoughDataLabel removeFromSuperview];
        [self.view addSubview:self.backgroundLines];
        [self.view addSubview:self.sider];
        [self.view addSubview:self.footer];
        [self.view bringSubviewToFront:self.barChartView];
        if (self.currentAmountOfData == ODDGraphAmountShortTerm) {
            return self.numberOfBars;
        } else if (self.currentAmountOfData == ODDGraphAmountMedium) {
            if (self.entries.count < self.mediumCount) {
                [self.backgroundLines removeFromSuperview];
                [self.sider removeFromSuperview];
                [self.footer removeFromSuperview];
                [self.view addSubview:self.notEnoughDataLabel];
                return 0;
            }
            return self.numberOfBars;
        } else if (self.currentAmountOfData == ODDGraphAmountAll) {
            if  (self.entries.count < self.mediumCount) {
                [self.backgroundLines removeFromSuperview];
                [self.sider removeFromSuperview];
                [self.footer removeFromSuperview];
                [self.view addSubview:self.notEnoughDataLabel];
                return 0;
            }
            return self.numberOfBars;
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

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index {
    if (self.currentAmountOfData == ODDGraphAmountAll) {
        return [self.allData getValueAtIndex:index];
    } else if (self.currentAmountOfData == ODDGraphAmountMedium) {
        return [self.mediumeData getValueAtIndex:index];
    } else {
        return [self.shortData getValueAtIndex:index];
    }
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index {
    CGFloat value = [self barChartView:barChartView heightForBarViewAtAtIndex:index];
    if (value <= 1.02) {
        return self.colors[@"oddLook_color_1"];
    } else if (value <= 2.02) {
        return self.colors[@"oddLook_color_2"];
    } else if (value <= 3.02) {
        return self.colors[@"oddLook_color_3"];
    } else if (value <= 4.02) {
        return self.colors[@"oddLook_color_4"];
    } else {
        return self.colors[@"oddLook_color_5"];
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
