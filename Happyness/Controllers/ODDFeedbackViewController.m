//
//  ODDFeedbackViewController.m
//  Happyness
//
//  Created by Matthew Chiang on 7/10/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDFeedbackViewController.h"
#import "ODDSelectionCardScrollViewController.h"
#import "ODDHappynessHeader.h"
#import "ODDCustomColor.h"
#import "ODDHappynessObserver.h"
#import "ODDTodayNoteView.h"

@interface ODDFeedbackViewController () <ODDSelectionCardScrollViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *slices;
@property (nonatomic, strong) UILabel *feedbackLabel;
@property (nonatomic, strong) NSDictionary *colorDictionary;
@property (strong, nonatomic) UIView *noteContainerView;
@property (strong, nonatomic) UIButton *clearAllButton;
@property (strong, nonatomic) ODDNote *note;
@property (strong, nonatomic) ODDTodayNoteView *noteView;

@end

@implementation ODDFeedbackViewController
@synthesize pieChart = _pieChart;

- (instancetype)initWithCardSelectionController:
                                        (ODDSelectionCardScrollViewController *)bottomController {
    self = [super init];
    if (self) {
        bottomController.delegate = self;
        _colorDictionary = [ODDCustomColor customColorDictionary];

        _note = [[ODDNote alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
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

    [self setupNoteButton];
    [self setupHashtagButton];
    [self setUpNoteView];
}

- (void)setupNoteButton {
    UIButton *note = [UIButton buttonWithType:UIButtonTypeCustom];
    note.frame = CGRectMake(self.view.bounds.size.width - 40.0, self.view.frame.size.height - 50.0, 25, 25);
    note.backgroundColor = [UIColor clearColor];
    [note setImage:[UIImage imageNamed:@"note.png"] forState:UIControlStateNormal];
    [self.view addSubview:note];
    [note addTarget:self action:@selector(addNote) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupHashtagButton {
    UIButton *hashtag = [UIButton buttonWithType:UIButtonTypeCustom];
    hashtag.frame = CGRectMake(25.0, self.view.frame.size.height - 52.0, 25, 25);
    hashtag.backgroundColor = [UIColor clearColor];
    [hashtag setImage:[UIImage imageNamed:@"hashtag.png"] forState:UIControlStateNormal];
    [self.view addSubview:hashtag];
    [hashtag addTarget:self action:@selector(addHashtag) forControlEvents:UIControlEventTouchUpInside];

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
    [self.pieChart setAnimationSpeed:2.0];
    [self.pieChart setShowLabel:YES];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    [self.pieChart setLabelRadius:120];
    [self.pieChart setShowPercentage:NO];
    [self.pieChart setPieBackgroundColor:[UIColor whiteColor]];
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
//
//    ODDHappynessObserver *observer = [[ODDHappynessObserver alloc] init];
//    NSString *analysis = [observer analyzePastDays];
//
//    NSString *feedback = [text stringByAppendingString:analysis];
//    self.feedbackLabel.text = feedback;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Note and Hashtag

- (void)addNote {
    [self.noteView becomeFirstResponder];
}

- (void)addHashtag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OddLook"
                                                    message:@"Do you like hashtags?"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

# pragma mark - Note

/* Still need to make sure note view slides down every new day */
- (void)setUpNoteView {
    self.noteContainerView = [[UIView alloc]
                              initWithFrame:CGRectMake(0, -self.view.bounds.size.height, 320,
                                                       self.view.bounds.size.height)];
    self.noteContainerView.backgroundColor = [UIColor clearColor];

    self.noteView = [[ODDTodayNoteView alloc]
                     initWithFrame:CGRectMake(0, self.view.frame.size.height - 34, 270, 40)];
    self.noteView.delegate = self;


    self.clearAllButton = [[UIButton alloc]
                           initWithFrame:CGRectMake(270, self.view.frame.size.height - 34, 50, 40)];

    self.clearAllButton.backgroundColor = [UIColor lightGrayColor];
    self.clearAllButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.clearAllButton setTitle:@"X" forState:UIControlStateNormal];
    [self.clearAllButton addTarget:self action:@selector(clearButtonSelected)
                  forControlEvents:UIControlEventTouchUpInside];

    /* entryBackground; edit these lines for back
     UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
     UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
     UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
     entryImageView.frame = CGRectMake(5, 0, 248, 40);
     entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
     */

    /* messageEntryBackground
     UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
     UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
     UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
     imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
     imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
     */

    [self.view addSubview:self.noteContainerView];
    //[containerView addSubview:imageView];
    [self.noteContainerView addSubview:self.noteView];
    [self.noteContainerView addSubview:self.clearAllButton];
    //[containerView addSubview:entryImageView];

    /* Replace image with custom CLEAR ALL
     UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
     UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
     */

    /*Replace doneBtn with a clearAll button
     UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
     doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
     [doneBtn setTitle:@"Done" forState:UIControlStateNormal];

     [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
     doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
     doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];

     [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
     [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
     [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
     [containerView addSubview:doneBtn];
     */
    self.noteContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)keyboardWillShow:(NSNotification *)note {
    // get keyboard size and location
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];

    // get a rect for the textView frame
    CGRect containerFrame = self.noteContainerView.frame;
    // Matt: play with height values to make textView move upon keyboard showing
    containerFrame.origin.y = self.view.bounds.size.height - self.noteContainerView.frame.size.height - 30.0;
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];

    // set views with new info
    self.noteContainerView.frame = containerFrame;


    // commit animations
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)note {
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    // get a rect for the textView frame
    CGRect containerFrame = self.noteContainerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height + containerFrame.size.height;

    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];

    // set views with new info
    self.noteContainerView.frame = containerFrame;

    // commit animations
    [UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    float diff = (growingTextView.frame.size.height - height);

    CGRect r = self.noteContainerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.noteContainerView.frame = r;

    CGRect clearR = self.clearAllButton.frame;
    clearR.size.height -= diff;
    self.clearAllButton.frame = clearR;
}

/* Dismiss keyboard upon pressing "Done" and impose 140 character limit */
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
        [self.noteView resignFirstResponder];
    }
    return growingTextView.text.length + (text.length - range.length) <= 140;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (void)clearButtonSelected {
    self.noteView.text = @"";
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView {
    self.note.noteString = growingTextView.text;
}


#pragma mark - Delegate for Card Selection View Controller
- (void)submit {
    [self setUpPieChart];
    [self.pieChart reloadData];
    [self reloadFeedbackText];
    // double overall = [self calculateOverallScoreWithLinearRegression];
    // NSLog(@"Overall score: %f", overall);
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


@end
