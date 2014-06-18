//
//  ODDTodayViewController.m
//  Happyness
//
//  Created by John Lee on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDTodayViewController.h"
#import "ODDHappyness.h"

@interface ODDTodayViewController () <UIScrollViewDelegate>

@end

@implementation ODDTodayViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Today";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Replace colors with Happyness objects and Happyness views
    ODDHappyness *verySadObject = [[ODDHappyness alloc] initWithFace:1];
    ODDHappyness *sadObject = [[ODDHappyness alloc] initWithFace:2];
    ODDHappyness *soSoObject = [[ODDHappyness alloc] initWithFace:3];
    ODDHappyness *happyObject = [[ODDHappyness alloc] initWithFace:4];
    ODDHappyness *veryHappyObject = [[ODDHappyness alloc] initWithFace:5];

    NSArray *happynessObjects = [NSArray arrayWithObjects:verySadObject, sadObject, soSoObject, 
                                 happyObject, veryHappyObject, nil];

    for (int i = 0; i < happynessObjects.count; i++) {
        CGRect frame;
        frame.origin.x = _scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _scrollView.frame.size;

        UIView *subview = [[UIView alloc] initWithFrame:frame];
        ODDHappyness *temp = [happynessObjects objectAtIndex:i];
        subview.backgroundColor = temp.color;

        [self.scrollView addSubview:subview];
    }

    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * happynessObjects.count, _scrollView.frame.size.height);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update the page control to display correct view when scrolling
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
