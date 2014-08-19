//
//  ODDFeedbackViewController.m
//  Happyness
//
//  Created by Matthew Chiang on 7/10/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "GAIDictionaryBuilder.h"
#import "ODDFeedbackViewController.h"
#import "ODDSelectionCardScrollViewController.h"
#import "ODDHappynessHeader.h"
#import "ODDCustomColor.h"
#import "ODDHappynessObserver.h"
#import "ODDNoteModalViewController.h"
#import "ODDPresentingAnimator.h"
#import "ODDDismissingAnimator.h"

@interface ODDFeedbackViewController () <ODDSelectionCardScrollViewControllerDelegate,
                                         UIAlertViewDelegate, UIViewControllerTransitioningDelegate>


@property (nonatomic, strong) NSDictionary *colorDictionary;
@property (nonatomic, strong) NSMutableArray *slices;
@property (nonatomic, strong) UILabel *feedbackLabel;
@property (strong, nonatomic) ODDNote *note;
@property (strong, nonatomic) UIButton *clearAllButton;
@property (strong, nonatomic) UIView *noteContainerView;
@end

@implementation ODDFeedbackViewController
@synthesize pieChart = _pieChart;

- (instancetype)initWithCardSelectionController:
                                        (ODDSelectionCardScrollViewController *)bottomController {
    self = [super init];
    if (self) {
        bottomController.delegate = self;
        _colorDictionary = [ODDCustomColor customColorDictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadFeedbackText)
                                                     name:UIApplicationSignificantTimeChangeNotification
                                                   object:nil];
    }
    return self;
}


#pragma mark - View Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenName = @"Feedback";
    // Do any additional setup after loading the view from its nib.
    self.view.frame = CGRectMake(0,
                                 0,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height * SCROLLVIEW_HEIGHT_RATIO + 20);
    self.view.layer.cornerRadius = 10.0f;
    self.view.layer.masksToBounds = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _pieChart = [[XYPieChart alloc] initWithFrame:CGRectMake(0,
                                                             0,
                                                             self.view.bounds.size.width,
                                                             self.view.bounds.size.height)
                                           Center:CGPointMake(self.view.frame.size.width / 6.0,
                                                              self.view.frame.size.width / 6.0)
                                           Radius:100];
    [self setUpPieChart];
    [self setUpFeedbackView];
    [self.pieChart reloadData];

    [self setupNoteButton];
    // If we ever want this function again, its here
    //[self setupHashtagButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self resetAndReloadPieChart];
    ODDHappynessEntry *entry = [[ODDHappynessEntryStore sharedStore] todayEntry];
    if (entry) {
        self.note = entry.note;
    } else {
        _note = [ODDNote MR_createEntity];
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Feedback"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - Buttons setup

- (void)setupNoteButton {
    UIButton *note = [UIButton buttonWithType:UIButtonTypeCustom];
    note.frame = CGRectMake(self.view.bounds.size.width - 60.0,
                            self.view.frame.size.height - 90.0, 55, 55);
    note.backgroundColor = [UIColor clearColor];
    [note setImage:[UIImage imageNamed:@"note.png"] forState:UIControlStateNormal];
    [self.view addSubview:note];
    [note addTarget:self action:@selector(addNote) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupHashtagButton {
    UIButton *hashtag = [UIButton buttonWithType:UIButtonTypeCustom];
    hashtag.frame = CGRectMake(15.0, self.view.frame.size.height - 74.0, 45, 45);
    hashtag.backgroundColor = [UIColor clearColor];
    [hashtag setImage:[UIImage imageNamed:@"hashtag.png"] forState:UIControlStateNormal];
    [self.view addSubview:hashtag];
    [hashtag addTarget:self 
                action:@selector(addHashtag) 
      forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - Piechart and Feedback setup

- (void)setUpPieChart {
    // Set up data for the pie chart
    self.slices = [NSMutableArray arrayWithCapacity:5];
    int oneCount = 0, twoCount = 0, threeCount = 0, fourCount = 0, fiveCount = 0;

    NSArray *store = [[ODDHappynessEntryStore sharedStore] sortedStore];
    if (store.count >= 14) {
        store = [store subarrayWithRange:NSMakeRange(store.count - 14, 14)];
    }
    for (int i = 0; i < store.count; i++) {
        ODDHappyness *temp = ((ODDHappynessEntry *)[store objectAtIndex:i]).happyness;
        int value = [temp.value intValue];
        if (value == 1) {
            oneCount += 1;
        } else if (value == 2) {
            twoCount += 1;
        } else if (value == 3) {
            threeCount += 1;
        } else if (value == 4) {
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
    [self.pieChart setPieRadius:self.view.frame.size.width / 2.8];
    [self.pieChart setAnimationSpeed:2.0];
    [self.pieChart setShowLabel:NO];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    [self.pieChart setLabelRadius:120];
    [self.pieChart setShowPercentage:NO];
    [self.pieChart setPieBackgroundColor:[UIColor whiteColor]];
    CGPoint adjustedCenter = self.view.center;
    adjustedCenter.y -= adjustedCenter.y * 0.15;
    [self.pieChart setPieCenter:adjustedCenter];
    [self.pieChart setUserInteractionEnabled:NO];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];

    [self.view addSubview:self.pieChart];
}

- (void)resetAndReloadPieChart {
    self.slices = [NSMutableArray arrayWithCapacity:5];
    int oneCount = 0, twoCount = 0, threeCount = 0, fourCount = 0, fiveCount = 0;

    NSArray *store = [[ODDHappynessEntryStore sharedStore] sortedStore];
    if (store.count >= 14) {
        store = [store subarrayWithRange:NSMakeRange(store.count - 14, 14)];
    }
    for (int i = 0; i < store.count; i++) {
        ODDHappyness *temp = ((ODDHappynessEntry *)[store objectAtIndex:i]).happyness;
        int value = [temp.value intValue];
        if (value == 1) {
            oneCount += 1;
        } else if (value == 2) {
            twoCount += 1;
        } else if (value == 3) {
            threeCount += 1;
        } else if (value == 4) {
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

    [self.pieChart reloadData];
}

- (void)setUpFeedbackView {
    CGRect imageRect = CGRectMake(0, 0,
                                  self.view.frame.size.width / 1.7,
                                  self.view.frame.size.width / 1.7);
    UIImageView *centerImage = [[UIImageView alloc] initWithFrame:imageRect];
    [centerImage setImage:[UIImage imageNamed:@"feedbackCircle.png"]];
    CGPoint adjustedCenter = self.view.center;
    adjustedCenter.y -= adjustedCenter.y * 0.15;
    centerImage.center = adjustedCenter;

    UIFont *customFont = [UIFont fontWithName:@"Nunito-Bold" size:16];
    self.feedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
    self.feedbackLabel.center = adjustedCenter;
    [self reloadFeedbackText];
    self.feedbackLabel.font = customFont;
    self.feedbackLabel.alpha = 0.7;
    self.feedbackLabel.numberOfLines = 0;
    self.feedbackLabel.adjustsFontSizeToFitWidth = YES;
    self.feedbackLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    self.feedbackLabel.minimumScaleFactor = 1.0f / 2.0f;
    self.feedbackLabel.backgroundColor = [UIColor clearColor];

    self.feedbackLabel.textColor = [[ODDCustomColor customColorDictionary] 
                                                             objectForKey:@"oddLook_textcolor"];
    self.feedbackLabel.textAlignment = NSTextAlignmentCenter;

    [self.pieChart addSubview:centerImage];
    [self.pieChart addSubview:self.feedbackLabel];
}

- (void)reloadFeedbackText {
    NSInteger count = [[[ODDHappynessEntryStore sharedStore] happynessEntries] count];
    NSString *text;

    if (count == 0) {
        text = @"Hi! Select how you're feeling below once per day and get happy!";
    } else if (count == 1) {
        text = @"Hey, welcome back! We hope you're getting happier!";
    } else {
        ODDHappynessObserver *observer = [[ODDHappynessObserver alloc] init];
        text = [observer analyzePastDays];
    }

    self.feedbackLabel.text = text;
}

#pragma mark - Note and Hashtag

- (void)addNote {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker set:kGAIScreenName value:@"Feedback"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:@"note"
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];

    ODDNoteModalViewController *noteViewController = [[ODDNoteModalViewController alloc] init];

    ODDHappynessEntry *entry = [[ODDHappynessEntryStore sharedStore] todayEntry];
    if (entry) {
        noteViewController.text = entry.note.noteString;
        noteViewController.transitioningDelegate = self;
        noteViewController.modalPresentationStyle = UIModalPresentationCustom;
        [self.view.window.rootViewController presentViewController:noteViewController
                           animated:YES
                         completion:NULL];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Happyness"
                                                        message:@"Please select an entry below first"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];

    }
}

- (void)addHashtag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OddLook"
                                                    message:@"Do you want to tag your notes?"
                                                   delegate:nil
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];

    [tracker set:kGAIScreenName value:@"Feedback"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:title
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];

}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [ODDPresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:
                                                                    (UIViewController *)dismissed
{
    ODDHappynessEntry *entry = [[ODDHappynessEntryStore sharedStore] todayEntry];
    if (entry) {
        ODDNote *note = entry.note;
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            ODDNote *local = [note MR_inContext:localContext];
            local.noteString = ((ODDNoteModalViewController *)dismissed).text;
        }];
    }
    return [ODDDismissingAnimator new];
}


#pragma mark - Delegate for Card Selection View Controller
- (void)submit {

    NSDate *date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    NSString *key = [NSString stringWithFormat:@"%ld/%ld/%ld",
                     (long)[components year], (long)[components month], (long)[components day]];
    ODDHappynessEntry *entry = [[[ODDHappynessEntryStore sharedStore] happynessEntries] 
                                                                      objectForKey:key];
    entry.note = self.note;
    [self resetAndReloadPieChart];
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
    NSString *key = [NSString stringWithFormat:@"oddLook_color_%ld", (long)index + 1];
    return [self.colorDictionary objectForKey:key];
}

#pragma mark - Overall Score Calculations
- (CGFloat)calculateOverallScoreWithLinearRegression {
    // Get two arrays: x and y points
    NSArray *entries = [[ODDHappynessEntryStore sharedStore] sortedStore];
    if (entries.count == 0) {
        return 0.0;
    }
    NSMutableArray *xValues = [[NSMutableArray alloc] init];
    NSMutableArray *yValues = [[NSMutableArray alloc] init];

    for (int i = 0; i < entries.count; i++) {
        [xValues addObject:[NSNumber numberWithInt:i + 1]];
        ODDHappynessEntry *entry = [entries objectAtIndex:i];
        ODDHappyness *happyness = entry.happyness;
        double rating = [happyness.rating doubleValue];
        [yValues addObject:[NSNumber numberWithDouble:rating]];
    }

    if (entries.count == 1) {
        return [[yValues objectAtIndex:0] doubleValue];
    }

    // Get weighted y coordinates
    NSMutableArray *weightedY = [self getWeightedYWithX:xValues andY:yValues];

    // Calculate sum of squares ssX, ssY, and ssXY
    NSInteger n = xValues.count;
    CGFloat sX, sY, ssX, ssY, ssXY;
    sX = sY = ssX = ssY = ssXY = 0;
    for (int i = 0; i < n; i++) {
        CGFloat x = [[xValues objectAtIndex:i] doubleValue];
        CGFloat y = [[weightedY objectAtIndex:i] doubleValue];
        sX += x;
        sY += y;
        ssX += x * x;
        ssY += y * y;
        ssXY += x * y;
    }
    CGFloat avgX = sX / n;
    CGFloat avgY = sY / n;

    ssX = ssX - n * (avgX * avgX);//pow(avgX, 2);
    ssY = ssY - n * (avgY * avgY);//pow(avgY, 2);
    ssXY = ssXY - n * avgX * avgY;

    // Best fit of line: y_i = a + b * x_i
    CGFloat b = ssXY / ssX;
    CGFloat a = avgY - b * avgX;

    // Correlation coeffcient, r^2, gives quality of the estimate, 1 being perfect and 0 otherwise
//    double corCoeff = pow(ssXY, 2) / (ssX * ssY);
//
//    NSLog(@"n: %lu, a: %f --- b: %f --- cor: %f --- avgX: %f --- avgY: %f --- ssX: %f - ssY: %f - ssXY: %f", n, a, b, corCoeff, avgX, avgY, ssX, ssY, ssXY);
    return b * n + a;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
