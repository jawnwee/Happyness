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
    self.screenName = @"Reminder";
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
    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 30, 150, 31)];
    reminderLabel.font = [UIFont fontWithName:@"GothamNarrow-Light" size:36];
    reminderLabel.text = @"Reminder";
    self.reminderSwitch = [[ODDCustomReminderSwitchView alloc]
                           initWithFrame:CGRectMake(125, 75, 70, 35)];

    [self.reminderSwitch addTarget:self
                            action:@selector(switchToggled)
                  forControlEvents:UIControlEventTouchUpInside];

    self.reminderButtonShadow = [[UIView alloc] initWithFrame:CGRectMake(self.reminderSwitch.frame.origin.x,
                                                           self.reminderSwitch.frame.origin.y + 3,
                                                           self.reminderSwitch.frame.size.width,
                                                           self.reminderSwitch.frame.size.height)];
    self.reminderButtonShadow.backgroundColor = [UIColor grayColor];
    self.reminderButtonShadow.layer.cornerRadius = 5.0f;

    [self.view addSubview:self.reminderButtonShadow];
    [self.view addSubview:reminderLabel];
    [self.view addSubview:self.reminderSwitch];
}

- (void)setUpPicker {
    self.picker = [[SSFlatDatePicker alloc] initWithFrame:CGRectMake(40, 130, 240, 200)];
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
    if (self.reminderIsOn) {
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
        [comp setDay:dateComp.day];
        [comp setHour:pickerComp.hour];
        [comp setMinute:pickerComp.minute];


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
    self.reminderSwitch.label.textColor = [ODDCustomColor customPickerTextColor];
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
