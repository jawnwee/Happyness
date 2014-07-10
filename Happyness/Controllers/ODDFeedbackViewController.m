//
//  ODDFeedbackViewController.m
//  Happyness
//
//  Created by Matthew Chiang on 7/10/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDFeedbackViewController.h"
#import "ODDHappyness.h"
#import "ODDHappynessEntry.h"
#import "ODDHappynessEntryStore.h"
#import "ODDCustomColor.h"
#import "ODDHappynessObserver.h"

@interface ODDFeedbackViewController ()

@property (strong, nonatomic) NSMutableArray *slices;
@property (strong, nonatomic) UILabel *feedbackLabel;

@end

@implementation ODDFeedbackViewController
@synthesize pieChart = _pieChart;

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - View Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width,
                                 self.view.frame.size.height * SCROLLVIEW_HEIGHT_RATIO);
    self.view.layer.cornerRadius = 10.0f;
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    _pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             self.view.bounds.size.width,
                                                             self.view.bounds.size.height)
                                           Center:CGPointMake(60, 60)
                                           Radius:100];
    [self setUpPieChart];
    [self setUpFeedbackView];
    [self.pieChart reloadData];

    // Test submit button; crashes if you add, then go to graphs
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeSystem];
    submit.frame = CGRectMake(200, 300, 50, 50);
    [submit setTitle:@"Submit" forState:UIControlStateNormal];
    [self.view addSubview:submit];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpPieChart {
    // Set up data for the pie chart
    self.slices = [NSMutableArray arrayWithCapacity:5];
    int oneCount = 0, twoCount = 0, threeCount = 0, fourCount = 0, fiveCount = 0;

    NSArray *store = [[[ODDHappynessEntryStore sharedStore] happynessEntries] allValues];
    for (int i = 0; i < store.count; i++) {
        ODDHappyness *temp = ((ODDHappynessEntry *)[store objectAtIndex:i]).happyness;
        if (temp.value == 1) {
            oneCount += 1;
        } else if (temp.value == 2) {
            twoCount += 1;
        } else if (temp.value == 3) {
            threeCount += 1;
        } else if (temp.value == 4) {
            fourCount += 1;
        } else {
            fiveCount += 1;
        }
    }
    [_slices addObject:[NSNumber numberWithInt:oneCount]];
    [_slices addObject:[NSNumber numberWithInt:twoCount]];
    [_slices addObject:[NSNumber numberWithInt:threeCount]];
    [_slices addObject:[NSNumber numberWithInt:fourCount]];
    [_slices addObject:[NSNumber numberWithInt:fiveCount]];

    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:-M_PI_2];
    [self.pieChart setPieRadius:120]; // change back to 62.5 or whatever value we need
    [self.pieChart setAnimationSpeed:4.0];
    [self.pieChart setShowLabel:YES];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    [self.pieChart setLabelRadius:120];
    [self.pieChart setShowPercentage:YES];
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChart setPieCenter:CGPointMake(160, 160)];
    [self.pieChart setUserInteractionEnabled:NO];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];

    [self.view addSubview:self.pieChart];
}

- (void)setUpFeedbackView {
    CGRect imageRect = CGRectMake(0, 0, 200, 200);
    UIImageView *centerImage = [[UIImageView alloc] initWithFrame:imageRect];
    [centerImage setImage:[UIImage imageNamed:@"feedbackCircle.png"]];
    centerImage.center = CGPointMake(160, 160);

    UIFont *customFont = [UIFont fontWithName:@"ProximaNovaSemiBold" size:10];
    self.feedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
    self.feedbackLabel.center = CGPointMake(160, 160);
    [self reloadFeedbackText];
    self.feedbackLabel.font = customFont;
    self.feedbackLabel.numberOfLines = 0;
    self.feedbackLabel.adjustsFontSizeToFitWidth = YES;
    self.feedbackLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    self.feedbackLabel.minimumScaleFactor = 1.0f / 2.0f;
    self.feedbackLabel.backgroundColor = [UIColor clearColor];
    self.feedbackLabel.textColor = [UIColor blackColor];
    self.feedbackLabel.textAlignment = NSTextAlignmentCenter;


    [self.pieChart addSubview:centerImage];
    [self.pieChart addSubview:self.feedbackLabel];
}

- (void)reloadFeedbackText {
    double overallScore = [self calculateOverallScoreWithLinearRegression];
    NSString *text;

    if (overallScore <= 15) {
        text = @"Overall: You are very negative \n\n";
    } else if (overallScore <= 35) {
        text = @"Overall: You are sad \n\n";
    } else if (overallScore <= 65) {
        text = @"Overall: Neither positive nor negative, just neutral \n\n";
    } else if (overallScore <= 85) {
        text = @"Overall: Today was a good day - Ice Cube \n\n";
    } else {
        text = @"BOOMSHAKALAKA \n\n";
    }

    ODDHappynessObserver *observer = [[ODDHappynessObserver alloc] init];
    NSString *analysis = [observer analyzePastDays];

    NSString *feedback = [text stringByAppendingString:analysis];
    self.feedbackLabel.text = feedback;

}

// Testing fake entries
- (void)submit {
    for (int i = 0; i < 300; i++) {
        ODDHappyness *happy = [[ODDHappyness alloc] initWithFace:1];
        ODDHappynessEntry *entry = [[ODDHappynessEntry alloc] initWithHappyness:happy note:nil dateTime:[NSDate dateWithTimeIntervalSinceNow:i * 24 * 60 * 60]];
        [[ODDHappynessEntryStore sharedStore] addEntry:entry];
    }
    [self setUpPieChart];
    [self.pieChart reloadData];
    [self reloadFeedbackText];
    double overall = [self calculateOverallScoreWithLinearRegression];
    NSLog(@"Overall score: %f", overall);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    NSArray *sliceColors = [[ODDCustomColor customColorDictionary] allValues];
    return [sliceColors objectAtIndex:(index % sliceColors.count)];
}

#pragma mark - Overall Score Calculations

- (double)calculateOverallScoreWithLinearRegression {
    // Get two arrays: x and y points
    NSArray *entries = [[[ODDHappynessEntryStore sharedStore] happynessEntries] allValues];
    NSMutableArray *xValues = [[NSMutableArray alloc] init];
    NSMutableArray *yValues = [[NSMutableArray alloc] init];

    for (int i = 0; i < entries.count; i++) {
        [xValues addObject:[NSNumber numberWithInt:i]];
        ODDHappynessEntry *entry = [entries objectAtIndex:i];
        ODDHappyness *happyness = entry.happyness;
        [yValues addObject:[NSNumber numberWithDouble:happyness.rating]];
    }

    // Get weighted y coordinates
    NSMutableArray *weightedY = [self getWeightedYWithX:xValues andY:yValues];

    // Calculate sum of squares ssX, ssY, and ssXY
    NSUInteger n = xValues.count;
    double sX, sY, ssX, ssY, ssXY;
    sX = sY = ssX = ssY = ssXY = 0;
    for (int i = 0; i < n; i++) {
        double x = [[xValues objectAtIndex:i] doubleValue];
        double y = [[weightedY objectAtIndex:i] doubleValue];
        sX += x;
        sY += y;
        ssX += x * x;
        ssY += y * y;
        ssXY += x * y;
    }
    double avgX = sX / n;
    double avgY = sY / n;

    ssX = ssX - n * pow(avgX, 2);
    ssY = ssY - n * pow(avgY, 2);
    ssXY = ssXY - n * avgX * avgY;

    // Best fit of line: y_i = a + b * x_i
    double b = ssXY / ssX;
    double a = avgY - b * avgX;

    // Correlation coeffcient, r^2, gives quality of the estimate, 1 being perfect and 0 otherwise
    //double corCoeff = pow(ssXY, 2) / (ssX * ssY);

    //NSLog(@"n: %lu, a: %f --- b: %f --- cor: %f --- avgX: %f --- avgY: %f --- ssX: %f - ssY: %f - ssXY: %f", n, a, b, corCoeff, avgX, avgY, ssX, ssY, ssXY);

    return b * (n + 1) + a;
}

- (NSMutableArray *)getWeightedYWithX:(NSMutableArray *)xValues andY:(NSMutableArray *)yValues {
    NSAssert(xValues.count == yValues.count, @"Number of x and y coordinates need to match");

    // Use appropriate weight factors depending on n
    double n = xValues.count;
    NSMutableArray *newYValues = [[NSMutableArray alloc] init];
    if (n <= 30) {
        for (double i = n; i > 0; i--) {
            double weightedY = [[yValues objectAtIndex:n - i] doubleValue] * ((30 - i + 1) / 30);
            [newYValues addObject:[NSNumber numberWithDouble:weightedY]];
        }
    } else if (n <= 365) {
        for (double i = n; i > 0; i--) {
            double weightedY = [[yValues objectAtIndex:n - i] doubleValue] * ((365 - i + 1) / 365);
            [newYValues addObject:[NSNumber numberWithDouble:weightedY]];
        }
    } else {
        for (double i = n; i > 0; i--) {
            double weightedY = [[yValues objectAtIndex:n - i] doubleValue] * ((n - i + 1) / n);
            [newYValues addObject:[NSNumber numberWithDouble:weightedY]];
        }
    }

    return newYValues;
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
