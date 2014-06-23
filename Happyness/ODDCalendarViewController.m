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

@interface ODDCalendarViewController () <CKCalendarViewDelegate>

@property (strong, nonatomic) IBOutlet CKCalendarView *calendar;
@property (strong, nonatomic) ODDHappynessEntryView *happynessEntryView;

@end

@implementation ODDCalendarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.calendar setDelegate:self];
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
    _calendar = [CKCalendarView new];
    [_calendar setDelegate:self];
    [[self view] addSubview:self.calendar];
    _happynessEntryView = [ODDHappynessEntryView createHappynessEntryView];

    CGRect adjustedFrame = CGRectMake(0.0,
                                self.view.bounds.size.height - self.calendar.bounds.size.height,
                                self.happynessEntryView.bounds.size.width,
                                self.happynessEntryView.bounds.size.height);

    self.happynessEntryView.frame = adjustedFrame;
    
    [self.view addSubview:self.happynessEntryView];
    NSDate *key = [self.calendar date];
    ODDHappynessEntry *initialEntry = [[ODDHappynessEntryStore sharedStore] ]
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
