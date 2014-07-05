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

@interface ODDCalendarViewController () <TSQCalendarViewDelegate>

@property (strong, nonatomic) IBOutlet ODDCalendarView *calendar;
@property (strong, nonatomic) IBOutlet ODDHappynessEntryView *happynessEntryView;
@property (strong, nonatomic) ODDTimelineTableViewController *timeline;

@property (strong, nonatomic) NSDate *dayOneInCurrentMonth;
@property (strong, nonatomic) NSDate *lastDayInCurrentMonth;

@end

@implementation ODDCalendarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImage *calendarSelected = [UIImage imageNamed:@"CalendarTabSelected60.png"];
        UIImage *calendarUnselected = [UIImage imageNamed:@"CalendarTabUnselected60.png"];
        calendarSelected = [calendarSelected
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        calendarUnselected = [calendarUnselected
                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
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

        
        ODDCalendarView *calendarView = [[ODDCalendarView alloc] init];
        CGRect frame = [self.view frame];
        calendarView.frame = frame;
        calendarView.calendar = [[NSCalendar alloc]
                                        initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        calendarView.delegate = self;
        NSDate *firstEntry = [[ODDHappynessEntryStore sharedStore] firstDate];
//        calendarView.firstDate = [NSDate dateWithTimeInterval:-60 * 60 * 24 * 31 * 1
//                                                    sinceDate:firstEntry];

        // Still testing stuff
        NSDate *todayDate = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

        NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:todayDate];
        components.day = 1;

        _dayOneInCurrentMonth = [gregorian dateFromComponents:components];
        components.day = 27;
        _lastDayInCurrentMonth = [gregorian dateFromComponents:components];
        NSLog(@"first: %@ last: %@",self.dayOneInCurrentMonth, self.lastDayInCurrentMonth);
        //

        calendarView.firstDate = self.dayOneInCurrentMonth;
        calendarView.lastDate = self.lastDayInCurrentMonth;
        calendarView.rowCellClass = [ODDCalendarRowCell class];
        calendarView.pagingEnabled = NO;
        CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
        calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);
        [self.view addSubview:calendarView];

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
    //[(ODDCalendarView *)self.view reload];
    // [self.happynessEntryView setHappynessEntry:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.layer.cornerRadius = 10.0f;
    self.view.layer.masksToBounds = YES;
    // TODO: when view initally loads, must set the entryView to reflect current selected
    // NSDate *key = [self.calendar date];
    // ODDHappynessEntry *initialEntry = [[ODDHappynessEntryStore sharedStore] ]
}

- (void)updateTitle {
    //NSString *year = [(ODDCalendarView *)self.view currentYear];
//    if (year != self.navigationItem.title) {
//        self.navigationItem.title = year;
//    }
}

- (void)viewDidLayoutSubviews {
    //[(ODDCalendarView *)self.view scrollToDate:[NSDate date] animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moveToToday {
    //[(ODDCalendarView *)self.view scrollToDate:[NSDate date] animated:YES];
    NSDate *firstDate = self.dayOneInCurrentMonth;
    NSDate *lastDate = self.lastDayInCurrentMonth;
    NSLog(@"LasteDaye: %@", lastDate);
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:firstDate];

    NSDateComponents *lastComponents = [gregorian components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:lastDate];

    components.month -= 1;
    NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
    lastComponents.day = 0;
    NSDate *lastDayInCurrentMonth = [gregorian dateFromComponents:lastComponents];

    self.dayOneInCurrentMonth = dayOneInCurrentMonth;
    self.lastDayInCurrentMonth = lastDayInCurrentMonth;

    NSLog(@"first: %@ last: %@",dayOneInCurrentMonth, lastDayInCurrentMonth);



    ODDCalendarView *calendarView = [[ODDCalendarView alloc] init];
    CGRect frame = CGRectMake(self.view.frame.origin.x, -500, self.view.frame.size.width, self.view.frame.size.height);
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
                         [[[self.view subviews] objectAtIndex:0] setCenter:CGPointMake(self.view.center.x, 1000)];
                         [self.view addSubview:calendarView];
                         [[[self.view subviews] objectAtIndex:1] setCenter:CGPointMake(self.view.center.x, 250)];
                     }
                     completion:^(BOOL finished){
                         [[[self.view subviews] objectAtIndex:0] removeFromSuperview];
                     }];
}

#pragma mark - Segue to different View Controllers
- (void)segueToTimeline {
    [self.navigationController pushViewController:self.timeline animated:YES];
}

- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    NSDate *today = [calendar dateFromComponents:components];

    NSComparisonResult result = [today compare:date];
    if (result == NSOrderedSame) {
        
        self.tabBarController.selectedViewController =
                                            [self.tabBarController.viewControllers objectAtIndex:0];

    } else if (result == NSOrderedDescending) {
        NSDictionary *entries = [[ODDHappynessEntryStore sharedStore] happynessEntries];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                        NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                       fromDate:date];
        NSString *key = [NSString stringWithFormat:@"%ld/%ld/%ld",
                         (long)[components year], (long)[components month], (long)[components day]];
        ODDHappynessEntry *entry = [entries objectForKey:key];
        ODDPreviousDayViewController *previous = [[ODDPreviousDayViewController alloc]
                                                        initWithHappynessEntry:entry
                                                                       forDate:date];
        [self.navigationController pushViewController:previous animated:YES];
    }
}

@end
