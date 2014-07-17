//
//  ODDReminderViewController.m
//  Happyness
//
//  Created by Matthew Chiang on 7/10/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

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

@end

@implementation ODDReminderViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width,
                                 self.view.frame.size.height * SCROLLVIEW_HEIGHT_RATIO);
    self.view.layer.cornerRadius = 10.0f;
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpSwitch];
    [self setUpPicker];

}

- (void)setUpSwitch {
    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 30, 150, 31)];
    reminderLabel.font = [UIFont fontWithName:@"GothamNarrow-Light" size:36];
    reminderLabel.text = @"Reminder";
    self.reminderSwitch = [[ODDCustomReminderSwitchView alloc] initWithFrame:CGRectMake(125, 75, 70, 35)];

    [self.reminderSwitch addTarget:self
                            action:@selector(switchToggled)
                  forControlEvents:UIControlEventTouchUpInside];

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
    if (!self.reminderIsOn) {
        [self turnOnPickerCover];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Switch and Picker Handling

- (void)scheduleReminder {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if (self.reminderIsOn) {
        NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
        calendar.timeZone = [NSTimeZone defaultTimeZone];
        NSDate *currentDate = [NSDate date];
        NSDate *pickerDate = self.picker.date;
        NSDateComponents *dateComp = [calendar components:(kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay) fromDate:currentDate];
        NSDateComponents *pickerComp = [calendar components:(kCFCalendarUnitHour | kCFCalendarUnitMinute) fromDate:pickerDate];
        NSDateComponents *comp = [[NSDateComponents alloc] init];

        [comp setYear:dateComp.year];
        [comp setMonth:dateComp.month];
        [comp setDay:dateComp.day];
        [comp setHour:pickerComp.hour];
        [comp setMinute:pickerComp.minute];


        UILocalNotification *reminder = [[UILocalNotification alloc] init];
        reminder.alertBody = [NSString stringWithFormat:@"It's %ld:%ld! How was your day?", (long)comp.hour, (long)comp.minute];
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
    self.reminderIsOn = !self.reminderIsOn;
    UIView *slider = [[self.reminderSwitch subviews] objectAtIndex:0];
    if (self.reminderIsOn) {
        [self turnOffPickerCover];
        self.picker.gradientColor = self.picker.backgroundColor = [ODDCustomColor customReminderOffColor];
        CGRect slideRightFrame = slider.frame;
        slideRightFrame.origin.x += self.reminderSwitch.frame.size.width / 2;
        [UIView animateWithDuration:0.2
                         animations:^{
                             slider.frame = slideRightFrame;
                             self.reminderSwitch.backgroundColor = [ODDCustomColor customTealColor];
                         }];
    } else {
        [self turnOnPickerCover];
        CGRect slideLeftFrame = slider.frame;
        slideLeftFrame.origin.x -= self.reminderSwitch.frame.size.width / 2;
        [UIView animateWithDuration:0.2
                         animations:^{
                             slider.frame = slideLeftFrame;
                             self.reminderSwitch.backgroundColor = [ODDCustomColor customReminderOffColor];
                         }];
    }
    [self scheduleReminder];
}

- (void)pickerToggled {
    if (self.reminderIsOn) {
        [self scheduleReminder];
    }
}

- (void)turnOnPickerCover {
    self.pickerOffView = [[UIView alloc] initWithFrame:self.picker.frame];
    self.pickerOffView.layer.cornerRadius = 10.0f;
    self.picker.textColor = [[ODDCustomColor customPickerTextColor] colorWithAlphaComponent:0.5];
    self.pickerOffView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.25];
    [self.view addSubview:self.pickerOffView];
}

- (void)turnOffPickerCover {
    self.picker.textColor = [ODDCustomColor customPickerTextColor];
    [self.pickerOffView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
