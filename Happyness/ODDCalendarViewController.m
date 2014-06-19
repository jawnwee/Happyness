//
//  ODDCalendarViewController.m
//  Happyness
//
//  Created by John Lee on 6/17/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarViewController.h"
#import "ODDHappynessEntryView.h"
#import "CalendarKit.h"

@interface ODDCalendarViewController ()
@property (weak, nonatomic) IBOutlet CKCalendarView *calendar;

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
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ODDHappynessEntryView *happynessEntryView = [ODDHappynessEntryView createHappynessEntryView];

    CGRect adjustedFrame = CGRectMake(0.0, self.view.bounds.size.height - self.calendar.bounds.size.height, happynessEntryView.bounds.size.width, happynessEntryView.bounds.size.height);

    happynessEntryView.frame = adjustedFrame;
    
    [self.view addSubview:happynessEntryView];
    // Do any additional setup after loading the view.
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
