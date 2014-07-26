//
//  ODDAppDelegate.m
//  Happyness
//
//  Created by Yujun Cho on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//
#import <Crashlytics/Crashlytics.h>
#import "ODDAppDelegate.h"
#import "ODDMainViewController.h"
#import "ODDWelcomeScreenViewController.h"
#import "ODDBottomRootViewController.h"
#import "ODDOverallCalendarViewController.h"
#import "ODDRootViewController.h"
#import "ODDCurveFittingViewController.h"
#import "ODDDayAveragesViewController.h"
#import "ODDManyGraphsViewController.h"
#import "ODDCardScrollViewController.h"
#import "ODDCalendarCardScrollViewController.h"
#import "ODDCardCollectionViewCell.h"
#import "ODDFeedbackViewController.h"
#import "ODDSelectionCardScrollViewController.h"
#import "ODDReminderViewController.h"
#import "ODDCardQuoteScrollViewController.h"
#import "ODDStatisticsCardScrollView.h"
#import "ODDHappynessHeader.h"

@implementation ODDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // iOS8 Notification Implementation
    /* [[UIApplication sharedApplication] registerUserNotificationSettings:
                           [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound
                                                                      | UIUserNotificationTypeAlert 
                                                                      | UIUserNotificationTypeBadge) 
                                                             categories:nil]];

    [[UIApplication sharedApplication] registerForRemoteNotifications]; */

    // Override point for customization after application launch.
    /* for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);

        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    } */

    // Google Analytics
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    [GAI sharedInstance].dispatchInterval = 20;
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-51721437-2"];

    // Crashyltics
    [Crashlytics startWithAPIKey:@"15cff1e39186231362a287dbc7407a93ea1631de"];

    // Core Data
    [MagicalRecord setupCoreDataStack];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSArray *allEntries = [ODDHappynessEntry MR_findAll];
    ODDHappynessEntry *entry;
    for (entry in allEntries) {
        [[ODDHappynessEntryStore sharedStore] addEntry:entry];
    }

    /*// Testing purposes, 500 random data for previous days
    for (int i = 1; i <= 20; i++) {
        NSNumber *value = [NSNumber numberWithInt:arc4random_uniform(5) + 1];
        int randomTimeDelta = 1;
        //int randomTimeDelta = arc4random_uniform(2);
        // i += randomTimeDelta;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(-86400 * randomTimeDelta * i)];
        ODDHappynessEntry *testEntry = [ODDHappynessEntry MR_createEntity];
        ODDHappyness *testHappyness = [ODDHappyness MR_createEntity];
        testHappyness.value = value;
        testHappyness.entry = testEntry;
        ODDNote *note = [ODDNote MR_createEntity];
        note.noteString = [NSMutableString
                           stringWithFormat:@"testing123. dont tap me, i dont do anything yet!"];
        note.entry = testEntry;

        testEntry.happyness = testHappyness;
        testEntry.note = note;
        testEntry.date = date;

        [[ODDHappynessEntryStore sharedStore] addEntry:testEntry];
    }
    [[ODDHappynessEntryStore sharedStore] sortStore:YES];
    ////////////////////////////////////////////////////// */

    // Feedback
    ODDSelectionCardScrollViewController *selectionBottom =
                                       [[ODDSelectionCardScrollViewController alloc] init];
    ODDFeedbackViewController *fvc = [[ODDFeedbackViewController alloc]
                                                    initWithCardSelectionController:selectionBottom];

    // Calendar
    ODDCalendarCardScrollViewController *calendarBottom =
                                       [[ODDCalendarCardScrollViewController alloc] init];
    ODDOverallCalendarViewController *calendar =
                 [[ODDOverallCalendarViewController alloc] initWithbottomController:calendarBottom];

    // Graphs
    ODDCurveFittingViewController *cfvc = [[ODDCurveFittingViewController alloc] init];
    ODDDayAveragesViewController *davc = [[ODDDayAveragesViewController alloc] init];
    davc.numberOfBars = 7;
    ODDStatisticsCardScrollView *graphBottom = [[ODDStatisticsCardScrollView alloc] init];
    ODDManyGraphsViewController *mgvc = [[ODDManyGraphsViewController alloc] initWithGraphs:@[cfvc, davc]];
    mgvc.cards = graphBottom;


    // Reminder
    ODDCardQuoteScrollViewController *reminderBottom = [[ODDCardQuoteScrollViewController alloc] init];
    ODDReminderViewController *reminderViewController = [[ODDReminderViewController alloc] init];

    // Bottom View Controllers
    NSArray *bottomViewControllers = @[selectionBottom, calendarBottom, graphBottom, reminderBottom];
    ODDBottomRootViewController *brvc = [[ODDBottomRootViewController alloc] initWithViewControllers:bottomViewControllers];

    // Top View Controllers
    ODDRootViewController *rvc = [[ODDRootViewController alloc] init];
    rvc.viewControllers = @[fvc, calendar, mgvc, reminderViewController];

    // Root View Controller
    ODDMainViewController *mainvc = [[ODDMainViewController alloc] initWithScrollViewController:rvc bottomViewController:brvc];

    ODDWelcomeScreenViewController *welcomeScreen = [[ODDWelcomeScreenViewController alloc] initWithMainController:mainvc];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"tutorialComplete"]) {
        self.window.rootViewController = mainvc;
    } else {
        self.window.rootViewController = welcomeScreen;
    }

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
