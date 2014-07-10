//
//  ODDBottomRootViewController.m
//  Happyness
//
//  Created by John Lee on 7/7/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDBottomRootViewController.h"

@interface ODDBottomRootViewController ()

@property (strong, nonatomic) NSArray *viewControllers;

@end

@implementation ODDBottomRootViewController

/* This init is loading the first scroll view's bottom screen; for some reason
 viewDidLoad gets called before this init and the viewControllers array is empty
 so this is loaded here */
- (instancetype)initWithViewControllers:(NSArray *)bottomViewControllers {
    self = [super init];
    if (self) {
        CGRect frame = self.view.frame;
        frame.origin.y += (frame.size.height * SCROLLVIEW_HEIGHT_RATIO);
        self.view.frame = frame;
        _viewControllers = bottomViewControllers;
        [self.view addSubview:[[self.viewControllers objectAtIndex:0] view]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView:(NSInteger)index {
    self.view = [[self.viewControllers objectAtIndex:index] view];
}

@end
