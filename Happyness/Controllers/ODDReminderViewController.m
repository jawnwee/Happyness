//
//  ODDReminderViewController.m
//  Happyness
//
//  Created by Matthew Chiang on 7/10/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "GAIDictionaryBuilder.h"
#import "ODDReminderViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SSFlatDatePicker.h"
#import "ODDCustomReminderSwitchView.h"
#import "ODDCustomColor.h"

#define HEADER_HEIGHT 45
#define STATUS_BAR_HEIGHT 20 // Should always be 20 points

@interface ODDReminderViewController ()

@property (nonatomic, strong) SSFlatDatePicker *picker;
@property (nonatomic, strong) ODDCustomReminderSwitchView *reminderSwitch;
@property (nonatomic) BOOL reminderIsOn;
@property (nonatomic, strong) UIView *pickerOffView;
@property (nonatomic, strong) UIView *reminderButtonShadow;

@end

@implementation ODDReminderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width,
                                 self.view.frame.size.height * SCROLLVIEW_HEIGHT_RATIO + 20);
    self.view.layer.cornerRadius = 10.0f;
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpSwitch];
    [self setUpPicker];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Reminder"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

}

- (void)setUpSwitch {
    CGRect headerFrame = CGRectMake(0.0, 0.0,
                                    self.view.frame.size.width,
                                    STATUS_BAR_HEIGHT + HEADER_HEIGHT);
    UIView *headerView = [[UIView alloc] initWithFrame:headerFrame];
    CGFloat adjustedHeight = STATUS_BAR_HEIGHT - 5.0;
    CGFloat titleOfMonthWidth = 190;
    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2) - (titleOfMonthWidth / 2),
                                                                       adjustedHeight,
                                                                       titleOfMonthWidth,
                                                                       HEADER_HEIGHT)];
    reminderLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    reminderLabel.text = @"Push Notification";
    reminderLabel.textColor = [ODDCustomColor textColor];
    reminderLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:headerView];
    [headerView addSubview:reminderLabel];


    CGRect switchFrame = CGRectMake(0, 0, self.view.frame.size.width * 0.2, self.view.frame.size.height * 0.1);
    self.reminderSwitch = [[ODDCustomReminderSwitchView alloc]
                           initWithFrame:switchFrame];
    CGPoint center = self.view.center;
    center.y -= self.view.frame.size.height * 0.30;
    self.reminderSwitch.center = center;


    [self.reminderSwitch addTarget:self
                            action:@selector(switchToggled)
                  forControlEvents:UIControlEventTouchUpInside];

    self.reminderButtonShadow = [[UIView alloc]
                                 initWithFrame:CGRectMake(self.reminderSwitch.frame.origin.x,
                                                           self.reminderSwitch.frame.origin.y + 3,
                                                           self.reminderSwitch.frame.size.width,
                                                           self.reminderSwitch.frame.size.height)];
    self.reminderButtonShadow.backgroundColor = [UIColor grayColor];
    self.reminderButtonShadow.layer.cornerRadius = 5.0f;

    [self.view addSubview:self.reminderButtonShadow];
    [self.view addSubview:self.reminderSwitch];
}

- (void)setUpPicker {
    CGRect frame = CGRectMake(self.view.frame.size.width * 0.1, self.view.frame.size.height * 0.35,
                              self.view.frame.size.width * 0.8, self.view.frame.size.height * 0.5);
    self.picker = [[SSFlatDatePicker alloc] initWithFrame:frame];
    self.picker.datePickerMode = SSFlatDatePickerModeTime;
    self.picker.gradientColor = self.picker.backgroundColor = [ODDCustomColor customReminderOffColor];
    self.picker.textColor = [ODDCustomColor customPickerTextColor];
    [self.picker addTarget:self
                    action:@selector(pickerToggled)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.picker];
    [self switchToggled];
}

#pragma mark - Switch and Picker Handling

- (void)scheduleReminder {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if (self.reminderIsOn && ![[NSUserDefaults standardUserDefaults] objectForKey:@"Reminder"]) {
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        calendar.timeZone = [NSTimeZone defaultTimeZone];
        NSDate *currentDate = [NSDate date];
        NSDate *pickerDate = self.picker.date;
        NSDateComponents *dateComp = [calendar components:(kCFCalendarUnitYear |
                                                           kCFCalendarUnitMonth |
                                                           kCFCalendarUnitDay)
                                                 fromDate:currentDate];

        NSDateComponents *pickerComp = [calendar components:(kCFCalendarUnitHour |
                                                             kCFCalendarUnitMinute)
                                                   fromDate:pickerDate];

        NSDateComponents *comp = [[NSDateComponents alloc] init];

        [comp setYear:dateComp.year];
        [comp setMonth:dateComp.month];
        [comp setMinute:pickerComp.minute];
        [comp setDay:dateComp.day];
        [comp setHour:pickerComp.hour];

        UILocalNotification *reminder = [[UILocalNotification alloc] init];
        reminder.alertBody = [NSString stringWithFormat:@"Hey, how was your day?"];
        reminder.alertAction = @"Tell me how it went!";
        reminder.soundName = UILocalNotificationDefaultSoundName;
        reminder.fireDate = [calendar dateFromComponents:comp];
        reminder.timeZone = [NSTimeZone defaultTimeZone];
        reminder.repeatInterval = kCFCalendarUnitDay;
        reminder.applicationIconBadgeNumber = 0;

        [[UIApplication sharedApplication] scheduleLocalNotification:reminder];

        /* //Testing for correct notification fire time
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         [formatter setTimeStyle:NSDateFormatterFullStyle];
         [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
         NSLog(@"Setting reminder for time: %@", [formatter stringFromDate:reminder.fireDate]);
         */
    }
}

- (void)switchToggled {
    CGRect slideFrame = self.reminderSwitch.frame;
    self.reminderIsOn = !self.reminderIsOn;
    if (self.reminderIsOn) {
        [self turnOnPicker];
        [self turnOnReminderSwitch];
        slideFrame.origin.y = self.reminderSwitch.frame.origin.y + 3;
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.reminderSwitch.frame = slideFrame;
                         }];

    } else {
        [self turnOffPicker];
        [self turnOffReminderSwitch];
        slideFrame.origin.y = self.reminderSwitch.frame.origin.y - 3;
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.reminderSwitch.frame = slideFrame;
                         }];
    }
    [self scheduleReminder];
}

- (void)pickerToggled {
    if (self.reminderIsOn) {
        [self scheduleReminder];
    }
}

- (void)turnOnReminderSwitch {
    self.reminderSwitch.backgroundColor = [ODDCustomColor customTealColor];
    self.reminderSwitch.label.text = @"ON";
    self.reminderSwitch.label.textColor = [ODDCustomColor whiteColor];
}

- (void)turnOffReminderSwitch {
    self.reminderSwitch.backgroundColor = [ODDCustomColor customReminderOffColor];
    self.reminderSwitch.label.text = @"OFF";
    self.reminderSwitch.label.textColor = [UIColor lightGrayColor];
}

- (void)turnOffPicker {
    self.pickerOffView = [[UIView alloc] initWithFrame:self.picker.frame];
    self.pickerOffView.layer.cornerRadius = 10.0f;
    self.picker.textColor = [[ODDCustomColor customPickerTextColor] colorWithAlphaComponent:0.5];
    self.pickerOffView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    [self.view addSubview:self.pickerOffView];
}

- (void)turnOnPicker {
    self.picker.gradientColor = self.picker.backgroundColor = [ODDCustomColor customReminderOffColor];
    self.picker.textColor = [ODDCustomColor customPickerTextColor];
    [self.pickerOffView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
