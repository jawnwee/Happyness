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

@interface ODDReminderViewController ()

@property (nonatomic, strong) SSFlatDatePicker *picker;
@property (nonatomic, strong) UISwitch *reminderSwitch;

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
    UILabel *reminderLabel = [[UILabel alloc] initWithFrame:CGRectMake(125, 30, 90, 31)];
    reminderLabel.text = @"Reminder";
    self.reminderSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(135, 80, 51, 31)];
    [self.reminderSwitch addTarget:self
                            action:@selector(switchOrPickerToggled)
                  forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:reminderLabel];
    [self.view addSubview:self.reminderSwitch];
}

- (void)setUpPicker {
    self.picker = [[SSFlatDatePicker alloc] initWithFrame:CGRectMake(40, 150, 240, 200)];
    self.picker.datePickerMode = SSFlatDatePickerModeTime;
    self.picker.gradientColor = self.picker.backgroundColor = [UIColor colorWithRed:240.0 / 255.0
                                                                              green:240.0 / 255.0
                                                                               blue:240.0 / 255.0
                                                                              alpha:1.0];
    self.picker.textColor = [UIColor colorWithRed:81.0 / 255.0
                                            green:81.0 / 255.0
                                             blue:81.0 / 255.0
                                            alpha:1.0];
    [self.picker addTarget:self
                    action:@selector(switchOrPickerToggled)
          forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:self.picker];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Show selected time
}

#pragma mark - Switch and Picker Handling

- (void)switchOrPickerToggled {
    if (self.reminderSwitch.isOn) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
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
        reminder.alertBody = @"Tell me how your day went!";
        reminder.soundName = UILocalNotificationDefaultSoundName;
        reminder.fireDate = [calendar dateFromComponents:comp];
        reminder.repeatInterval = kCFCalendarUnitDay;

        [[UIApplication sharedApplication] scheduleLocalNotification:reminder];

        /* Testing for correct notification fire time
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeStyle:NSDateFormatterFullStyle];
        [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
        NSLog(@"Setting reminder for time: %@", [formatter stringFromDate:reminder.fireDate]);
         */
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
