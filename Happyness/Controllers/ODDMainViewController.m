//
//  ODDMainViewController.m
//  Happyness
//
//  Created by John Lee on 7/7/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

// #import <Parse/Parse.h>
#import "ODDMainViewController.h"
#import "ODDBottomRootViewController.h"
#import "ODDRootViewController.h"
#import "ODDHappynessHeader.h"

@interface ODDMainViewController ()

@property (nonatomic, strong) ODDRootViewController *topView;
@property (nonatomic, strong) ODDBottomRootViewController *bottomView;

@end

@implementation ODDMainViewController

- (instancetype)initWithScrollViewController:(ODDRootViewController *)scrollView
                        bottomViewController:(ODDBottomRootViewController *)assistantView{
    self = [super init];
    if (self) {
        /* insert any additional custom inits here */
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(updateBottomView)
                       name:@"updateBottomView" object:nil];
        _bottomView = assistantView;
        _topView = scrollView;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSubviews];

    // Uncomment to track user data
    // [self updateUserDataInParse];
}

- (void)setupSubviews {
    [self.view addSubview:self.topView.view];
    [self.view addSubview:self.bottomView.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateBottomView {
    [self.bottomView updateView:[self.topView currentPage]];
}


/* - (void)updateUserDataInParse {
    PFQuery *query = [PFQuery queryWithClassName:@"HappynessUsers"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSString *deviceID = [self currentDevice];
        PFObject *currentUser;
        for (PFObject *object in objects) {
            if ([object[@"User"] isEqualToString:deviceID]) {
                currentUser = object;
            }
        }
        if (!currentUser) {
            PFObject *newUser = [PFObject objectWithClassName:@"HappynessUsers"];
            newUser[@"User"] = [self currentDevice];
            [newUser saveInBackground];
        } else {
            NSDictionary *entries = [[ODDHappynessEntryStore sharedStore] happynessEntries];
            for (NSString *key in [entries allKeys]) {
                NSCharacterSet *notAllowedChars =
                    [[NSCharacterSet characterSetWithCharactersInString:
                    @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
                NSString *resultString = [[key componentsSeparatedByCharactersInSet:notAllowedChars]
                                          componentsJoinedByString:@""];
                NSString *append = @"ODD";
                NSString *resultKey = [NSString stringWithFormat:@"%@%@", append, resultString];
                currentUser[resultKey] =
                                ((ODDHappynessEntry *)[entries objectForKey:key]).happyness.rating;
            }
            [currentUser saveInBackground];
        }
    }];
}

- (NSString *)currentDevice {
    NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return uniqueIdentifier;
} */

@end
