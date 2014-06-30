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
#import "ODDCalendarView.h"
#import "ODDCalendarRowCell.h"
#import "ODDTimelineTableViewController.h"

@interface ODDCalendarViewController ()

@property (strong, nonatomic) IBOutlet ODDCalendarView *calendar;
@property (strong, nonatomic) IBOutlet ODDHappynessEntryView *happynessEntryView;
@property (strong, nonatomic) ODDTimelineTableViewController *timeline;

@end

@implementation ODDCalendarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImage *calendarSelected = [UIImage imageNamed:@"CalendarTabSelected60.png"];
        UIImage *calendarUnselected = [UIImage imageNamed:@"CalendarTabUnselected60.png"];
        calendarSelected = [calendarSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        calendarUnselected = [calendarUnselected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *calendarTabBarItem = [[UITabBarItem alloc] initWithTitle:nil 
                                                                         image:calendarUnselected 
                                                                 selectedImage:calendarSelected];
        self.tabBarItem = calendarTabBarItem;

        self.edgesForExtendedLayout = UIRectEdgeNone;

        [[UINavigationBar appearance] setTitleTextAttributes: @{
            NSForegroundColorAttributeName: [UIColor darkGrayColor],
                       NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:22.0f],
                                                                }];

        // Basic sanity test //
        /* for (int i = 1 ; i <= 500; i++) {
            int test = arc4random_uniform(5) + 1;
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(-86400 * i)];
            ODDHappyness *testing = [[ODDHappyness alloc] initWithFace:test];
            ODDNote *testNote = [[ODDNote alloc] init];
            testNote.noteString = [NSMutableString stringWithFormat:@"testing123"];
            ODDHappynessEntry *testEntry = [[ODDHappynessEntry alloc] initWithHappyness:testing
                                                                                   note:testNote
                                                                               dateTime:date];
            [[ODDHappynessEntryStore sharedStore] addEntry:testEntry];
        } */
        /////////////////////////////////////////////////////////////////////////////////////

        ODDCalendarView *calendarView = [[ODDCalendarView alloc] init];
        calendarView.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        calendarView.firstDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 365 * 5];
        calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 1];
        calendarView.rowCellClass = [ODDCalendarRowCell class];
        calendarView.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:247.0 / 255.0 blue:249.0 / 255.0 alpha:1.0];
        calendarView.pagingEnabled = YES;
        CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
        calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);
        self.view = calendarView;

        UIBarButtonItem *today = [[UIBarButtonItem alloc] init];
        today.title = @"Today";
        today.target = self;
        today.action = @selector(moveToToday);
        self.navigationItem.leftBarButtonItem = today;

        UIBarButtonItem *timeline = [[UIBarButtonItem alloc] init];
        timeline.title = @"Timeline";
        timeline.target = self;
        timeline.action = @selector(segueToTimeline);
        self.navigationItem.rightBarButtonItem = timeline;

        _timeline = [[ODDTimelineTableViewController alloc] initWithStyle:UITableViewStylePlain];

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [(ODDCalendarView *)self.view reload];
    // [self.happynessEntryView setHappynessEntry:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)segueToTimeline {
    [self.navigationController pushViewController:self.timeline animated:YES];
}

@end
