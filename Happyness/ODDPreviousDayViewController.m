//
//  ODDPreviousDayViewController.m
//  Happyness
//
//  Created by John Lee on 6/30/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDPreviousDayViewController.h"
#import "ODDHappynessHeader.h"
#import "ODDHappynessView.h"
#import "ODDTodayNoteView.h"

@interface ODDPreviousDayViewController ()

@property (strong, nonatomic) ODDHappynessEntry *currentEntry;
@property (strong, nonatomic) NSDate *currentDate;

@end

@implementation ODDPreviousDayViewController

- (instancetype)initWithHappynessEntry:(ODDHappynessEntry *)entry forDate:(NSDate *)date{
    self = [super initWithNibName:@"ODDTodayViewController" bundle:nil];
    if (self) {
        _currentDate = date;
        _currentEntry = entry;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    [self.view sendSubviewToBack:self.grayView];
    self.tabBarController.tabBar.hidden = YES;

    ODDHappyness *happyness = [self.currentEntry happyness];
    ODDNote *previousNote = [self.currentEntry note];
    NSInteger page = 2;
    NSString *note = @"";
    if (happyness) {
        page = [happyness value] - 1;
        note = [previousNote noteString];
    }
    self.noteView.text = note;

    CGRect initialFrame;
    initialFrame.size = CGSizeMake(self.scrollView.frame.size.width,
                                   self.scrollView.frame.size.height);
    initialFrame.origin.x = self.scrollView.frame.size.width * page;
    initialFrame.origin.y = 0;
    [self.scrollView scrollRectToVisible:initialFrame animated:NO];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self submit];
    self.tabBarController.tabBar.hidden = NO;
}

/* Submit after user leaves today view controller*/
- (void)submit {
    ODDNote *note = [[ODDNote alloc] initWithNote:self.noteView.text];
    ODDHappyness *happyness = [[ODDHappyness alloc]
                                             initWithFace:(self.pageControl.currentPage + 1)];
    ODDHappynessEntry *entry = [[ODDHappynessEntry alloc] initWithHappyness:happyness
                                                                       note:note
                                                                   dateTime:self.currentDate];
    [[ODDHappynessEntryStore sharedStore] addEntry:entry];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resortAndReload" object:self];
}

@end
