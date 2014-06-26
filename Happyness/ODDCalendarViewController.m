//
//  ODDCalendarViewController.m
//  Happyness
//
//  Created by John Lee on 6/17/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarViewController.h"
#import "ODDHappynessEntryView.h"
#import "ODDHappynessEntry.h"
#import "ODDHappynessEntryStore.h"
#import "ODDHappyness.h"
#import "ODDNote.h"
#import "CalendarKit.h"
#import "ODDCalendarView.h"
#import "ODDCalendarRowCell.h"

@interface ODDCalendarViewController () <CKCalendarViewDelegate>

@property (strong, nonatomic) IBOutlet ODDCalendarView *calendar;
@property (strong, nonatomic) IBOutlet ODDHappynessEntryView *happynessEntryView;

@end

@implementation ODDCalendarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        UIBarButtonItem *today = [[UIBarButtonItem alloc] init];
        today.title = @"Today";
        today.target = self;
        today.action = @selector(moveToToday);
        UIBarButtonItem *timeLine = [[UIBarButtonItem alloc] init];
        timeLine.title = @"Timeline";
        timeLine.target = self;
        self.navigationItem.leftBarButtonItem = today;
        [[UINavigationBar appearance] setTitleTextAttributes: @{
            NSForegroundColorAttributeName: [UIColor darkGrayColor],
                       NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0f],
                                                                }];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(updateTitle)
                       name:@"changeYear" object:nil];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // [self.calendar setDelegate:self];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // [self.happynessEntryView setHappynessEntry:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Basic sanity test //
    for (int i = 1 ; i <= 30; i++) {
        int test = arc4random_uniform(5) + 1;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(86400 * i)];
        ODDHappyness *testing = [[ODDHappyness alloc] initWithFace:test];
        ODDNote *testNote = [[ODDNote alloc] init];
        testNote.noteString = [NSMutableString stringWithFormat:@"testing123"];
        ODDHappynessEntry *testEntry = [[ODDHappynessEntry alloc] initWithHappyness:testing
                                                                               note:testNote
                                                                           dateTime:date];
        [[ODDHappynessEntryStore sharedStore] addEntry:testEntry];
    }
    /////////////////////////////////////////////////////////////////////////////////////

    ODDCalendarView *calendarView = [[ODDCalendarView alloc] init];
    calendarView.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    // calendarView.rowCellClass = [TSQTACalendarRowCell class];
    calendarView.firstDate = [NSDate dateWithTimeIntervalSinceNow:-200 * 60 * 24 * 365 * 5];
    calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:200 * 60 * 24 * 365 * 5];
    calendarView.rowCellClass = [ODDCalendarRowCell class];
    calendarView.backgroundColor = [UIColor whiteColor];
    calendarView.pagingEnabled = YES;
    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);
    self.view = calendarView;

//    _calendar = [ODDCalendarView new];
//    [_calendar setDelegate:self];
//    [[self view] addSubview:self.calendar];
//    _happynessEntryView = [ODDHappynessEntryView createHappynessEntryView];
//
//    CGRect adjustedFrame = CGRectMake(0.0,
//                                self.view.bounds.size.height - self.calendar.bounds.size.height,
//                                self.happynessEntryView.bounds.size.width,
//                                self.happynessEntryView.bounds.size.height);
//
//    self.happynessEntryView.frame = adjustedFrame;
//    
//    [self.view addSubview:self.happynessEntryView];

    // TODO: when view initally loads, must set the entryView to reflect current selected
    // NSDate *key = [self.calendar date];
    // ODDHappynessEntry *initialEntry = [[ODDHappynessEntryStore sharedStore] ]
}

- (void)updateTitle {
    NSString *year = [(ODDCalendarView *)self.view currentYear];
    if (year != self.navigationItem.title) {
        self.navigationItem.title = year;
    }
}

- (void)viewDidLayoutSubviews {
    [(ODDCalendarView *)self.view scrollToDate:[NSDate date] animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moveToToday {
    [(ODDCalendarView *)self.view scrollToDate:[NSDate date] animated:YES];
}

// Take HappynessEntry from HappynessEntryStore's dictionary and set the entry to its view
- (void)calendarView:(CKCalendarView *)calendarView didSelectDate:(NSDate *)date {
    ODDHappyness *testing = [[ODDHappyness alloc] initWithFace:2];
    ODDNote *testNote = [[ODDNote alloc] init];
    testNote.noteString = [NSMutableString stringWithFormat:@"testing123"];
    ODDHappynessEntry *testEntry = [[ODDHappynessEntry alloc] initWithHappyness:testing
                                                                           note:testNote
                                                                       dateTime:date];

    [self.happynessEntryView setHappynessEntry:testEntry];
}

- (void)calendarView:(CKCalendarView *)CalendarView willSelectDate:(NSDate *)date {
}

@end
