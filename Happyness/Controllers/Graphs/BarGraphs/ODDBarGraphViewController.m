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
    self.shortTermCount = 20;
    self.mediumCount = 50;
    self.barChartView.maximumValue = 5;
    self.barChartView.minimumValue = 0;
    
    self.barChartView.delegate = self;
    self.barChartView.dataSource = self;
    self.barChartView.userInteractionEnabled = NO;
    CGRect rootFrame = self.view.frame;
    CGRect topFrame = self.topFrame.frame;
    CGRect graphShortTermButtonFrame = self.graphShortTerm.frame;
    CGFloat heightPadding = CGRectGetMaxY(topFrame);
    heightPadding += (heightPadding / 3);
    CGFloat widthPadding = graphShortTermButtonFrame.origin.x;
    widthPadding += (widthPadding / 3);
    self.barChartView.frame = CGRectMake(widthPadding,
                                         heightPadding,
                                         rootFrame.size.width - (widthPadding * 2),
                                         rootFrame.size.height - (heightPadding * 2));
    
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
}

#pragma mark - Setup Datastore

- (void)reloadDataStore {
    [super reloadDataStore];
}

#pragma mark - Graph Delegate Setup

// TODO: Removed footer and siders when there isn't enough data
- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView {
    if (self.entries.count > 0) {
        [self.view addSubview:self.sider];
        [self.view addSubview:self.footer];
        return self.numberOfBars;
    } else {
        [self.sider removeFromSuperview];
        [self.footer removeFromSuperview];
        return 0;
    }
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
