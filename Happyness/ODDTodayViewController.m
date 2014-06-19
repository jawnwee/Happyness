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

@property (nonatomic) BOOL hasBeenClickedToday;

@end

@implementation ODDTodayViewController

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize grayView = _grayView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"Today";
         // I'm not sure if init/loading will incorrectly toggbecause things should only init once right? I'm declaring this explicity as a reminder to resolve this issue later
        _hasBeenClickedToday = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpViewDidLoad];

    // If a happyness hasn't been added today, the screen will be gray
    if (_hasBeenClickedToday == NO) {
        // every 24 hours, grayView should be back at the initial frame position
        _grayView.backgroundColor = [UIColor grayColor];
    }
}

// Helper method for setting up Today
- (void)setUpViewDidLoad {
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

    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * happynessObjects.count,
                                         _scrollView.frame.size.height);

    // Set up initial happyness view to show
    CGRect initialFrame;
    initialFrame.size = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height);
    initialFrame.origin.x = _scrollView.frame.size.width * 2;
    initialFrame.origin.y = 0;
    [_scrollView scrollRectToVisible:initialFrame animated:NO];

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

# pragma mark - Note

- (IBAction)addNote:(id)sender {
    NSLog(@"LEGGO");
}


# pragma mark - Screen Transitions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (_hasBeenClickedToday == NO) {
        CGRect slideUpFrame = _grayView.frame;
        slideUpFrame.origin.y -= slideUpFrame.size.height;
        [UIView animateWithDuration:0.2
                         animations:^{
                                  _grayView.frame = slideUpFrame;
                              }
                         completion:^(BOOL finished) {
                                     //[_grayView removeFromSuperview]; // or use bringSubviewToFront: sendSubviewToBack for speed or hide it...so many options
                         }];
        _hasBeenClickedToday = YES;
    }
}

@end
