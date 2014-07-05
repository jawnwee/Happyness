//
//  ODDAppDelegate.m
//  Happyness
//
//  Created by Yujun Cho on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDAppDelegate.h"
#import "ODDCustomTabBarController.h"
#import "ODDTodayViewController.h"
#import "ODDCalendarNavigationViewController.h"
#import "ODDCalendarViewController.h"
#import "ODDAnalysisScrollViewController.h"
#import "ODDSettingsViewController.h"
#import "ODDAnalysisViewController.h"
#import "ODDLandscapeAnalysisViewController.h"
#import "ODDRootViewController.h"

@implementation ODDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications]; // you can also set here for local notification.

    // Override point for customization after application launch.

//    // All temporary inits, may or may not need changing later, these are the base views for the tab
//    NSBundle *appBundle = [NSBundle mainBundle];
//    ODDTodayViewController *today = [[ODDTodayViewController alloc] initWithNibName:@"ODDTodayViewController" bundle:appBundle];
//    ODDCalendarViewController *calendar = [[ODDCalendarViewController alloc] init];
//    ODDAnalysisScrollViewController *analysisScroll = [[ODDAnalysisScrollViewController alloc] init];
//    ODDSettingsViewController *settings = [[ODDSettingsViewController alloc] initWithNibName:@"ODDSettingsViewController" bundle:appBundle];
//    ODDCalendarNavigationViewController *calendarNav = [[ODDCalendarNavigationViewController alloc] initWithRootViewController:calendar];
//    ODDCustomTabBarController *tbvc = [[ODDCustomTabBarController alloc] init];
//    tbvc.viewControllers = @[today, calendarNav, analysisScroll, settings];
//
//    // Push tab bar icons down
//    for (UITabBarItem *item in tbvc.tabBar.items) {
//        item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    }
//
//    self.window.rootViewController = tbvc;
    
    ODDRootViewController *rvc = [[ODDRootViewController alloc] init];
    self.window.rootViewController = rvc;
    
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
