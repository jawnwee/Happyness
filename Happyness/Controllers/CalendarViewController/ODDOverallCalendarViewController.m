//
//  ODDOverallCalendarView.m
//  Happyness
//
//  Created by John Lee on 7/5/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "GAIDictionaryBuilder.h"
#import "ODDOverallCalendarViewController.h"
#import "ODDCalendarCardScrollViewController.h"
#import "ODDHappynessHeader.h"
#import "ODDCalendarModalViewController.h"
#import "ODDSelectionModalViewController.h"
#import "ODDCalendarView.h"
#import "ODDCalendarCell.h"
#import "ODDCalendarRowCell.h"
#import "ODDPresentingAnimator.h"
#import "ODDDismissingAnimator.h"
#import "ODDCustomColor.h"

#define HEADER_HEIGHT 45
#define STATUS_BAR_HEIGHT 20 // Should always be 20 points

@interface ODDOverallCalendarViewController () < TSQCalendarViewDelegate,
                                                ODDCalendarCardScrollViewControllerDelegate,
                                                UIViewControllerTransitioningDelegate >

@property (nonatomic, strong)  UIView *calendarHeader;
@property (nonatomic, strong)  UILabel *month;
@property (nonatomic, strong)  UILabel *monthYear;
//@property (nonatomic, weak) IBOutlet UILabel *year;
@property (nonatomic, strong) UIButton *increaseMonthButton;
@property (nonatomic, strong) UIButton *decreaseMonthButton;
@property (nonatomic, strong) NSDate *dayOneInCurrentMonth;
@property (nonatomic, strong) NSDate *lastDayInCurrentMonth;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) ODDCalendarCardScrollViewController *calendarCardController;
@property (nonatomic, strong) ODDCalendarView *currentCalendar;

@end

@implementation ODDOverallCalendarViewController

#pragma mark - Initialization

- (instancetype)initWithbottomController:(ODDCalendarCardScrollViewController *)bottomController {
    self = [super init];
    if (self) {
        _calendarCardController = bottomController;
        _calendarCardController.delegate = self;
    }
    return self;
}

#pragma mark - View Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Calendar";
    self.view.frame = CGRectMake(0,
                                 0,
                                 self.view.frame.size.width,
                                 self.view.frame.size.height * SCROLLVIEW_HEIGHT_RATIO + 20);
    self.view.layer.cornerRadius = 10.0f;
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupHeader];
    [self setupCalendarLogic];
    [self.currentCalendar scrollToDate:[NSDate date] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.currentCalendar reload];
    [self.calendarCardController resortAndReload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Calendar"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}


- (void)setupHeader {

    // Header View
    CGRect headerFrame = CGRectMake(0.0, 0.0,
                                    self.view.frame.size.width,
                                    STATUS_BAR_HEIGHT + HEADER_HEIGHT);
    _calendarHeader = [[UIView alloc] initWithFrame:headerFrame];
    _calendarHeader.layer.cornerRadius = 10.0;
    _calendarHeader.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_calendarHeader];

    // Title of Header
    [self setCurrentDate];
    CGFloat adjustedHeight = STATUS_BAR_HEIGHT - 5.0;
    CGFloat titleOfMonthWidth = 190;
    CGRect titleOfMonthFrame = CGRectMake((self.view.frame.size.width / 2) - (titleOfMonthWidth / 2),
                                          adjustedHeight,
                                          titleOfMonthWidth,
                                          HEADER_HEIGHT);
    _month = [[UILabel alloc] init];
    _monthYear = [[UILabel alloc] initWithFrame:titleOfMonthFrame];
    _monthYear.backgroundColor = [UIColor clearColor];
    _monthYear.textColor = [ODDCustomColor textColor];
    _monthYear.font = [UIFont fontWithName:@"Helvetica"
                                             size:22];
    _monthYear.textAlignment = NSTextAlignmentCenter;
    [self.calendarHeader addSubview:self.monthYear];

    _increaseMonthButton = [[UIButton alloc] init];
    _decreaseMonthButton = [[UIButton alloc] init];
    [_increaseMonthButton addTarget:self
                action:@selector(increaseMonth)
      forControlEvents:UIControlEventTouchDown];
    [_decreaseMonthButton addTarget:self
                  action:@selector(decreaseMonth)
        forControlEvents:UIControlEventTouchDown];
    _increaseMonthButton.backgroundColor = [UIColor clearColor];
    [_increaseMonthButton setImage:[UIImage imageNamed:@"increasing.png"] forState:UIControlStateNormal];
    CGFloat buttonWidth = 45;
    CGRect upFrame = CGRectMake(titleOfMonthFrame.origin.x + titleOfMonthFrame.size.width,
                                adjustedHeight,
                                buttonWidth,
                                HEADER_HEIGHT);
    [_increaseMonthButton setFrame:upFrame];
    _decreaseMonthButton.backgroundColor = [UIColor clearColor];
    [_decreaseMonthButton setImage:[UIImage imageNamed:@"decreasing.png"] forState:UIControlStateNormal];
    CGRect downFrame = upFrame;
    downFrame.origin.x = titleOfMonthFrame.origin.x - buttonWidth;
    [_decreaseMonthButton setFrame:downFrame];
    [self.calendarHeader addSubview:self.increaseMonthButton];
    [self.calendarHeader addSubview:self.decreaseMonthButton];


    // Setting up Sunday - Saturday
    NSDate *referenceDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    NSDateComponents *offset = [NSDateComponents new];
    offset.day = 1;
    NSMutableArray *headerLabels = [NSMutableArray arrayWithCapacity:7];

    NSDateFormatter *dayFormatter = [NSDateFormatter new];
//    dayFormatter.calendar = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    dayFormatter.calendar = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    dayFormatter.dateFormat = @"cccccc";

    CGFloat headerWidth = self.calendarHeader.bounds.size.width / 7.0;

    for (NSUInteger index = 0; index < 7; index++) {
        [headerLabels addObject:@""];
    }

    for (NSUInteger index = 0; index < 7; index++) {
        NSInteger ordinality = [dayFormatter.calendar ordinalityOfUnit:NSCalendarUnitDay
                                                                inUnit:NSCalendarUnitWeekOfMonth
                                                               forDate:referenceDate];
        CGRect frame = CGRectMake((index * headerWidth) + headerWidth / 3.0,
                                  self.calendarHeader.bounds.size.height - 8.0, 30.0, 40.0);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [dayFormatter stringFromDate:referenceDate];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
        label.textColor = [UIColor darkGrayColor];
        [label sizeToFit];
        headerLabels[ordinality - 1] = label;
        [self.calendarHeader addSubview:label];

        referenceDate = [dayFormatter.calendar dateByAddingComponents:offset
                                                               toDate:referenceDate
                                                              options:0];
    }

}

- (void)setupCalendarLogic {
    NSDate *todayDate = [NSDate date];
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *components = [gregorian
                                    components:(NSCalendarUnitEra |
                                                NSCalendarUnitYear | 
                                                NSCalendarUnitMonth)
                                    fromDate:todayDate];
    components.day = 1;
    _dayOneInCurrentMonth = [gregorian dateFromComponents:components];

    NSDateComponents *lastComponents = [gregorian
                                        components:(NSCalendarUnitEra |
                                                    NSCalendarUnitYear |
                                                    NSCalendarUnitMonth)
                                        fromDate:[NSDate date]];
    lastComponents.month += 1;
    lastComponents.day = 0;
    _lastDayInCurrentMonth = [gregorian dateFromComponents:lastComponents];
    ODDCalendarView *calendar = [self createCalendarView];
    calendar.tag = 1;
    [self.view insertSubview:calendar belowSubview:self.calendarHeader];
    [self setCurrentDate];
}


- (ODDCalendarView *)createCalendarView {

    ODDCalendarView *calendarView = [[ODDCalendarView alloc] init];
    CGRect frame = [self.view bounds];
    frame.origin.y += self.calendarHeader.bounds.size.height + 5.0;
    // Calendar's frame height, is overcalculated and -100 is used to adjust to the correct size
    frame.size.height = self.view.frame.size.height - 100.0;
    calendarView.frame = frame;
    calendarView.backgroundColor = [UIColor whiteColor];
//    calendarView.calendar = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendarView.calendar = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    calendarView.delegate = self;
    calendarView.firstDate = self.dayOneInCurrentMonth;
    calendarView.lastDate = self.lastDayInCurrentMonth;
    calendarView.rowCellClass = [ODDCalendarRowCell class];
    calendarView.pagingEnabled = NO;
    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);

    self.currentCalendar = calendarView;
    return calendarView;
}

#pragma mark - UIViewControllerTransition Delegates

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [ODDPresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    ODDHappynessEntry *entry = ((ODDSelectionModalViewController *)dismissed).currentEntry;
    if (entry) {
        [[ODDHappynessEntryStore sharedStore] addEntry:entry];
        [self.currentCalendar reload];
        [self.calendarCardController resortAndReload];
    }

    return [ODDDismissingAnimator new];
}


#pragma mark - Calendar Card Scroll View Delegate

- (void)changedEntry {
    [self.currentCalendar reload];
}

#pragma mark - Calendar View Logic

- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSString *monthName = [formatter stringFromDate:date];
    // For HappynessEntryObject
    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                    NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    NSString *key = [NSString stringWithFormat:@"%ld/%ld/%ld",
                     (long)[components year], (long)[components month], (long)[components day]];
    ////////////////////////////////////////////////////////////////////////////////

    if (![self.month.text isEqualToString:monthName]) {
        NSComparisonResult result = [self.dayOneInCurrentMonth compare:date];
        self.selectedDate = date;
        if (result == NSOrderedAscending) {
            [self increaseMonth];
        } else {
            [self decreaseMonth];
        }
    } else if (![[[ODDHappynessEntryStore sharedStore] happynessEntries] objectForKey:key]) {
        // If HappynessEntry doesnt exist in current month, and we are in same month
        // create a new one
        NSComparisonResult result = [[NSDate dateWithTimeIntervalSinceNow:-86400] compare:date];
        self.selectedDate = date;
        if (result == NSOrderedDescending) {
            ODDSelectionModalViewController *noteViewController =
                                                      [[ODDSelectionModalViewController alloc] init];
            noteViewController.selectedDate = date;
            noteViewController.currentEntry = NULL;
            noteViewController.transitioningDelegate = self;
            noteViewController.modalPresentationStyle = UIModalPresentationCustom;
            [self.view.window.rootViewController presentViewController:noteViewController
                                                              animated:YES 
                                                            completion:nil];
        }
    } else {
        [self.calendarCardController scrollToDate:date animated:YES];
    }
}


- (void)setCurrentDate {
    NSDate *currentDate = self.dayOneInCurrentMonth;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM YYYY"];

    NSString *monthYearName = [formatter stringFromDate:currentDate];
    self.monthYear.text = monthYearName;

    [formatter setDateFormat:@"MMMM"];
    NSString *monthName = [formatter stringFromDate:currentDate];
    self.month.text = monthName;

//    NSString *year = [formatter stringFromDate:currentDate];
//    self.year.text = year;

    NSString *dateComponents = @"MMMM YYYY";
    [formatter setDateFormat:dateComponents];
    self.calendarCardController.currentDate = [formatter stringFromDate:currentDate];
    [self.calendarCardController reloadCollectionData];
}

- (void)increaseMonth {
    [self changeMonth:YES];
}

- (void)decreaseMonth {
    [self changeMonth:NO];
}

- (void)changeMonth:(BOOL)increase {

    NSDate *firstDate = self.dayOneInCurrentMonth;
    NSDate *lastDate = self.lastDayInCurrentMonth;
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra |
                                                          NSCalendarUnitYear |
                                                          NSCalendarUnitMonth)
                                                fromDate:firstDate];

    NSDateComponents *lastComponents = [gregorian components:(NSCalendarUnitEra |
                                                              NSCalendarUnitYear |
                                                              NSCalendarUnitMonth)
                                                    fromDate:lastDate];
    NSDate *dayOneInCurrentMonth, *lastDayInCurrentMonth;
    if (increase) {
        components.month += 1;
        dayOneInCurrentMonth = [gregorian dateFromComponents:components];
        lastComponents.month += 2;
        lastComponents.day = 0;
        lastDayInCurrentMonth = [gregorian dateFromComponents:lastComponents];
    } else {
        components.month -= 1;
        dayOneInCurrentMonth = [gregorian dateFromComponents:components];
        components.month += 1;
        lastComponents.day = 0;
        lastDayInCurrentMonth = [gregorian dateFromComponents:lastComponents];
    }

    self.dayOneInCurrentMonth = dayOneInCurrentMonth;
    self.lastDayInCurrentMonth = lastDayInCurrentMonth;

    ODDCalendarView *calendarView = [self createCalendarView];
    calendarView.alpha = 0.0;
    // Start the second calendar above the current calendar; hardcoded y  value used.
    CGRect incomingFrame = calendarView.frame;

    if (increase) {
        incomingFrame.origin.y += 200;
        calendarView.frame = incomingFrame;
        [self.view insertSubview:calendarView belowSubview:self.calendarHeader];
        [self animateCalendar:calendarView firstY:-300 secondY:-200];
    } else {
        incomingFrame.origin.y -= 200;
        calendarView.frame = incomingFrame;
        [self.view insertSubview:calendarView belowSubview:self.calendarHeader];
        [self animateCalendar:calendarView firstY:300 secondY:200];
    }

    [self setCurrentDate];
    
}

- (IBAction)increaseYear:(id)sender {
    [self changeYear:YES];
}

- (IBAction)decreaseYear:(id)sender {
    [self changeYear:NO];
}

// No longer used, but if needed. here it is
- (void)changeYear:(BOOL)increase {


    NSDate *firstDate = self.dayOneInCurrentMonth;
    NSDate *lastDate = self.lastDayInCurrentMonth;
//    NSCalendar *gregorian = [[NSCalendar alloc]
//                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra |
                                                          NSCalendarUnitYear |
                                                          NSCalendarUnitMonth)
                                                fromDate:firstDate];

    NSDateComponents *lastComponents = [gregorian components:(NSCalendarUnitEra |
                                                              NSCalendarUnitYear |
                                                              NSCalendarUnitMonth)
                                                    fromDate:lastDate];
    NSDate *dayOneInCurrentMonth, *lastDayInCurrentMonth;
    if (increase) {
        components.year += 1;
        dayOneInCurrentMonth = [gregorian dateFromComponents:components];
        lastComponents.year += 1;
        lastComponents.month += 1;
        lastComponents.day = 0;
        lastDayInCurrentMonth = [gregorian dateFromComponents:lastComponents];
    } else {
        components.year -= 1;
        dayOneInCurrentMonth = [gregorian dateFromComponents:components];
        lastComponents.year -= 1;
        lastComponents.month += 1;
        lastComponents.day = 0;
        lastDayInCurrentMonth = [gregorian dateFromComponents:lastComponents];
    }

    self.dayOneInCurrentMonth = dayOneInCurrentMonth;
    self.lastDayInCurrentMonth = lastDayInCurrentMonth;

    ODDCalendarView *calendarView = [self createCalendarView];
    calendarView.alpha = 0.0;
    // Start the second calendar above the current calendar; hardcoded y  value used.
    CGRect incomingFrame = calendarView.frame;

    if (increase) {
        incomingFrame.origin.y += 200;
        calendarView.frame = incomingFrame;
        [self.view insertSubview:calendarView belowSubview:self.calendarHeader];
        [self animateCalendar:calendarView firstY:-300 secondY:-200];
    } else {
        incomingFrame.origin.y -= 200;
        calendarView.frame = incomingFrame;
        [self.view insertSubview:calendarView belowSubview:self.calendarHeader];
        [self animateCalendar:calendarView firstY:300 secondY:200];
    }

    [self setCurrentDate];

}

- (void)animateCalendar:(ODDCalendarView *)calendarView firstY:(CGFloat)firstDistance
                                                       secondY:(CGFloat)secondDistance{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionTransitionCurlDown
                     animations:^{
                         ODDCalendarView *first = (ODDCalendarView *)[self.view viewWithTag:1];
                         CGRect frame = first.frame;
                         frame.origin.y += firstDistance;
                         [first setFrame:frame];
                         first.alpha = 0.0;

                         CGRect frame2 = calendarView.frame;
                         frame2.origin.y += secondDistance;
                         [calendarView setFrame:frame2];
                         calendarView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [[self.view viewWithTag:1] removeFromSuperview];
                         calendarView.tag = 1;
                         if (self.selectedDate) {
                             calendarView.selectedDate = self.selectedDate;
                             self.selectedDate = nil;
                         }
                     }];
}

@end
