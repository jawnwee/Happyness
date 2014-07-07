//
//  ODDOverallCalendarView.m
//  Happyness
//
//  Created by John Lee on 7/5/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDOverallCalendarViewController.h"
#import "ODDHappynessHeader.h"
#import "ODDCalendarView.h"
#import "ODDCalendarRowCell.h"

@interface ODDOverallCalendarViewController () <TSQCalendarViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *calendarHeader;
@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) NSDate *dayOneInCurrentMonth;
@property (strong, nonatomic) NSDate *lastDayInCurrentMonth;
@property (strong, nonatomic) NSDate *selectedDate;

@end

@implementation ODDOverallCalendarViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    }
    return self;
}

- (void)viewDidLoad {
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width,
                                 self.view.frame.size.height * SCROLLVIEW_HEIGHT_RATIO);
    self.view.layer.cornerRadius = 10.0f;
    self.view.layer.masksToBounds = YES;

    NSDate *referenceDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    NSDateComponents *offset = [NSDateComponents new];
    offset.day = 1;
    NSMutableArray *headerLabels = [NSMutableArray arrayWithCapacity:7];

    NSDateFormatter *dayFormatter = [NSDateFormatter new];
    dayFormatter.calendar = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
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
                                  self.calendarHeader.bounds.size.height - 15.0, 30.0, 40.0);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [dayFormatter stringFromDate:referenceDate];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
        //label.backgroundColor = self.backgroundColor;
        label.textColor = [UIColor darkGrayColor];
        [label sizeToFit];
        headerLabels[ordinality - 1] = label;
        [self.calendarHeader addSubview:label];

        referenceDate = [dayFormatter.calendar dateByAddingComponents:offset toDate:referenceDate options:0];
    }


    [self setupCalendarLogic];
}

- (void)setupCalendarLogic {
    NSDate *todayDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *components = [gregorian
                                    components:(NSCalendarUnitEra |
                                                NSCalendarUnitYear | NSCalendarUnitMonth) 
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
    calendarView.calendar = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendarView.delegate = self;
    calendarView.firstDate = self.dayOneInCurrentMonth;
    calendarView.lastDate = self.lastDayInCurrentMonth;
    calendarView.rowCellClass = [ODDCalendarRowCell class];
    calendarView.pagingEnabled = NO;
    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);

    return calendarView;
}

- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];
    NSString *monthName = [formatter stringFromDate:date];

    if (![self.month.text isEqualToString:monthName]) {
        NSComparisonResult result = [self.dayOneInCurrentMonth compare:date];
        self.selectedDate = date;
        if (result == NSOrderedAscending) {
            [self increaseMonth:nil];
        } else {
            [self decreaseMonth:self];
        }
    } else {
        // TODO when cards are implemented
    }
}


- (void)setCurrentDate {
    NSDate *currentDate = self.dayOneInCurrentMonth;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM"];

    NSString *monthName = [formatter stringFromDate:currentDate];
    self.month.text = monthName;

    [formatter setDateFormat:@"YYYY"];

    NSString *year = [formatter stringFromDate:currentDate];
    self.year.text = year;
}

- (IBAction)increaseMonth:(id)sender {
    NSDate *firstDate = self.dayOneInCurrentMonth;
    NSDate *lastDate = self.lastDayInCurrentMonth;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra |
                                                          NSCalendarUnitYear |
                                                          NSCalendarUnitMonth) 
                                                fromDate:firstDate];

    NSDateComponents *lastComponents = [gregorian components:(NSCalendarUnitEra |
                                                              NSCalendarUnitYear |
                                                              NSCalendarUnitMonth) 
                                                    fromDate:lastDate];

    components.month += 1;
    NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
    lastComponents.month += 2;
    lastComponents.day = 0;
    NSDate *lastDayInCurrentMonth = [gregorian dateFromComponents:lastComponents];

    self.dayOneInCurrentMonth = dayOneInCurrentMonth;
    self.lastDayInCurrentMonth = lastDayInCurrentMonth;

    ODDCalendarView *calendarView = [self createCalendarView];
    calendarView.alpha = 0.0;
    // Start the second calendar above the current calendar; hardcoded y  value used.
    CGRect incomingFrame = calendarView.frame;
    incomingFrame.origin.y += 200;
    calendarView.frame = incomingFrame;
    [self.view insertSubview:calendarView belowSubview:self.calendarHeader];

    [self animateCalendarUp:calendarView];
    [self setCurrentDate];
    // This happens to make sure selected date is always the first
}

- (IBAction)decreaseMonth:(id)sender {

    NSDate *firstDate = self.dayOneInCurrentMonth;
    NSDate *lastDate = self.lastDayInCurrentMonth;
    NSCalendar *gregorian = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra |
                                                          NSCalendarUnitYear |
                                                          NSCalendarUnitMonth) 
                                                fromDate:firstDate];

    NSDateComponents *lastComponents = [gregorian components:(NSCalendarUnitEra |
                                                              NSCalendarUnitYear |
                                                              NSCalendarUnitMonth) 
                                                    fromDate:lastDate];

    components.month -= 1;
    NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
    components.month += 1;
    lastComponents.day = 0;
    NSDate *lastDayInCurrentMonth = [gregorian dateFromComponents:lastComponents];

    self.dayOneInCurrentMonth = dayOneInCurrentMonth;
    self.lastDayInCurrentMonth = lastDayInCurrentMonth;

    ODDCalendarView *calendarView = [self createCalendarView];
    calendarView.alpha = 0.0;
    // Start the second calendar above the current calendar; hardcoded y  value used.
    CGRect incomingFrame = calendarView.frame;
    incomingFrame.origin.y -= 200;
    calendarView.frame = incomingFrame;
    [self.view insertSubview:calendarView belowSubview:self.calendarHeader];

    [self animateCalendarDown:calendarView];
    [self setCurrentDate];
    // This happens to make sure selected date is always the first
    calendarView.selectedDate = self.dayOneInCurrentMonth;
}

- (IBAction)increaseYear:(id)sender {
    NSDate *firstDate = self.dayOneInCurrentMonth;
    NSDate *lastDate = self.lastDayInCurrentMonth;
    NSCalendar *gregorian = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra |
                                                          NSCalendarUnitYear |
                                                          NSCalendarUnitMonth) 
                                                fromDate:firstDate];

    NSDateComponents *lastComponents = [gregorian components:(NSCalendarUnitEra |
                                                              NSCalendarUnitYear |
                                                              NSCalendarUnitMonth) 
                                                    fromDate:lastDate];

    components.year += 1;
    NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
    lastComponents.year += 1;
    lastComponents.month += 1;
    lastComponents.day = 0;
    NSDate *lastDayInCurrentMonth = [gregorian dateFromComponents:lastComponents];

    self.dayOneInCurrentMonth = dayOneInCurrentMonth;
    self.lastDayInCurrentMonth = lastDayInCurrentMonth;

    ODDCalendarView *calendarView = [self createCalendarView];
    calendarView.alpha = 0.0;
    // Start the second calendar above the current calendar; hardcoded y  value used.
    CGRect incomingFrame = calendarView.frame;
    incomingFrame.origin.y += 200;
    calendarView.frame = incomingFrame;
    [self.view insertSubview:calendarView belowSubview:self.calendarHeader];

    [self animateCalendarUp:calendarView];
    [self setCurrentDate];
}

- (IBAction)decreaseYear:(id)sender {
    NSDate *firstDate = self.dayOneInCurrentMonth;
    NSDate *lastDate = self.lastDayInCurrentMonth;
    NSCalendar *gregorian = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *components = [gregorian components:(NSCalendarUnitEra |
                                                          NSCalendarUnitYear |
                                                          NSCalendarUnitMonth) fromDate:firstDate];

    NSDateComponents *lastComponents = [gregorian components:(NSCalendarUnitEra |
                                                              NSCalendarUnitYear |
                                                              NSCalendarUnitMonth) 
                                                    fromDate:lastDate];

    components.year -= 1;
    NSDate *dayOneInCurrentMonth = [gregorian dateFromComponents:components];
    lastComponents.year -= 1;
    lastComponents.month += 1;
    lastComponents.day = 0;
    NSDate *lastDayInCurrentMonth = [gregorian dateFromComponents:lastComponents];

    self.dayOneInCurrentMonth = dayOneInCurrentMonth;
    self.lastDayInCurrentMonth = lastDayInCurrentMonth;

    ODDCalendarView *calendarView = [self createCalendarView];
    calendarView.alpha = 0.0;
    // Start the second calendar above the current calendar; hardcoded y  value used.
    CGRect incomingFrame = calendarView.frame;
    incomingFrame.origin.y -= 200;
    calendarView.frame = incomingFrame;
    [self.view insertSubview:calendarView belowSubview:self.calendarHeader];

    [self animateCalendarDown:calendarView];
    [self setCurrentDate];
    
}

- (void)animateCalendarUp:(ODDCalendarView *)calendarView {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionTransitionCurlDown
                     animations:^{
                         ODDCalendarView *first = (ODDCalendarView *)[self.view viewWithTag:1];
                         CGRect frame = first.frame;
                         frame.origin.y -= 300;
                         [first setFrame:frame];
                         first.alpha = 0.0;

                         CGRect frame2 = calendarView.frame;
                         frame2.origin.y -= 200;
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

- (void)animateCalendarDown:(ODDCalendarView *)calendarView {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionTransitionCurlDown
                     animations:^{
                         ODDCalendarView *first = (ODDCalendarView *)[self.view viewWithTag:1];
                         CGRect frame = first.frame;
                         frame.origin.y += 300;

                         [first setFrame:frame];
                         first.alpha = 0.0;

                         CGRect frame2 = calendarView.frame;
                         frame2.origin.y += 200;
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
