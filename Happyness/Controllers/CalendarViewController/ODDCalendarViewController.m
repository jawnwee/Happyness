//
//  ODDCalendarViewController.m
//  Happyness
//
//  Created by John Lee on 6/17/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarViewController.h"
#import "ODDHappynessHeader.h"
#import "ODDHappynessEntryView.h"
#import "ODDCalendarView.h"
#import "ODDCalendarRowCell.h"
#import "ODDTimelineTableViewController.h"
#import "ODDPreviousDayViewController.h"

#import "ODDOverallCalendarViewController.h"

@interface ODDCalendarViewController () <TSQCalendarViewDelegate>

@property (strong, nonatomic) IBOutlet ODDHappynessEntryView *happynessEntryView;
@property (strong, nonatomic) ODDTimelineTableViewController *timeline;

@property (strong, nonatomic) NSDate *dayOneInCurrentMonth;
@property (strong, nonatomic) NSDate *lastDayInCurrentMonth;

@end

@implementation ODDCalendarViewController


#pragma mark - Initialization
- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        // Basic sanity test //
        for (int i = 1 ; i <= 500; i++) {
            int test = arc4random_uniform(5) + 1;
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(-86400 * i)];
            ODDHappyness *testing = [[ODDHappyness alloc] initWithFace:test];
            ODDNote *testNote = [[ODDNote alloc] init];
            testNote.noteString = [NSMutableString stringWithFormat:@"testing123"];
            ODDHappynessEntry *testEntry = [[ODDHappynessEntry alloc] initWithHappyness:testing
                                                                                   note:testNote
                                                                               dateTime:date];
            [[ODDHappynessEntryStore sharedStore] addEntry:testEntry];
        }
        [[ODDHappynessEntryStore sharedStore] sortStore:YES];
        /////////////////////////////////////////////////////////////////////////////////////
        NSDate *todayDate = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

        NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:todayDate];
        components.day = 1;

        _dayOneInCurrentMonth = [gregorian dateFromComponents:components];
        components.day = 0;
        _lastDayInCurrentMonth = [gregorian dateFromComponents:components];
        ODDCalendarView *calendarView = [self createCalendarView];
        //[self.view addSubview:calendarView];

        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(updateTitle)
                       name:@"changeYear" object:nil];
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[(ODDCalendarView *)self.view reload];
    // [self.happynessEntryView setHappynessEntry:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ODDOverallCalendarViewController *cal = [[ODDOverallCalendarViewController alloc] init];
    [self.view addSubview:cal];
    CGRect adjustedFrame = self.view.frame;
    adjustedFrame.size.height *= SCROLLVIEW_HEIGHT_RATIO;
    self.view.frame = adjustedFrame;

    self.view.layer.cornerRadius = 10.0f;
    self.view.layer.masksToBounds = YES;
    // TODO: when view initally loads, must set the entryView to reflect current selected
    // NSDate *key = [self.calendar date];
    // ODDHappynessEntry *initialEntry = [[ODDHappynessEntryStore sharedStore] ]
}

- (void)viewDidLayoutSubviews {
    //[(ODDCalendarView *)self.view scrollToDate:[NSDate date] animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTitle {
    //NSString *year = [(ODDCalendarView *)self.view currentYear];
    //    if (year != self.navigationItem.title) {
    //        self.navigationItem.title = year;
    //    }
}

#pragma mark - Calendar View Logic
- (ODDCalendarView *)createCalendarView {

    ODDCalendarView *calendarView = [[ODDCalendarView alloc] init];
    calendarView.backgroundColor = [UIColor whiteColor];
    CGRect frame = [self.view frame];
    calendarView.frame = frame;
    calendarView.calendar = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendarView.delegate = self;
    calendarView.firstDate = self.dayOneInCurrentMonth;
    calendarView.lastDate = self.lastDayInCurrentMonth;
    // calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60* 60 * 24 * 100];
    calendarView.rowCellClass = [ODDCalendarRowCell class];
    calendarView.pagingEnabled = NO;
    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);

    return calendarView;
}

#pragma mark - Calendar Header Button Logic
- (void)moveToToday {
    //[(ODDCalendarView *)self.view scrollToDate:[NSDate date] animated:YES];
    NSDate *firstDate = self.dayOneInCurrentMonth;
    NSDate *lastDate = self.lastDayInCurrentMonth;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:firstDate];

    NSDateComponents *lastComponents = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:lastDate];

    components.month -= 1;
    NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
    lastComponents.day = 0;
    NSDate *lastDayInCurrentMonth = [gregorian dateFromComponents:lastComponents];

    self.dayOneInCurrentMonth = dayOneInCurrentMonth;
    self.lastDayInCurrentMonth = lastDayInCurrentMonth;

    ODDCalendarView *calendarView = [[ODDCalendarView alloc] init];
    CGRect frame = [self.view bounds];
    NSLog(@"todays frame: %@", NSStringFromCGRect(frame));
    frame.origin.y -= 1000;
    calendarView.frame = frame;
    calendarView.calendar = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendarView.delegate = self;
    calendarView.firstDate = dayOneInCurrentMonth;
    calendarView.lastDate = lastDayInCurrentMonth;
    calendarView.rowCellClass = [ODDCalendarRowCell class];

    calendarView.pagingEnabled = NO;
    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect frame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.frame.size.height);
                         frame.origin.y += 1000;
                         [[[self.view subviews] objectAtIndex:0] setFrame:frame];

                         CGRect frame2 = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         [self.view addSubview:calendarView];
                         [[[self.view subviews] objectAtIndex:2] setFrame:frame2];
                     }
                     completion:^(BOOL finished){
                         [[[self.view subviews] objectAtIndex:0] removeFromSuperview];
                     }];
}

#pragma mark - Segues
- (void)segueToTimeline {
    [self.navigationController pushViewController:self.timeline animated:YES];
}

- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date {

}

@end
