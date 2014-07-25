//
//  ODDManyGraphsViewController.m
//  Happyness
//
//  Created by Yujun Cho on 7/6/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "GAIDictionaryBuilder.h"
#import "ODDManyGraphsViewController.h"
#import "ODDGraphViewController.h"
#import "ODDCustomColor.h"
#import "ODDStatisticsCardScrollView.h"

#define HEADER_HEIGHT 45
#define STATUS_BAR_HEIGHT 20 // Should always be 20 points

@interface ODDManyGraphsViewController ()

@property (nonatomic, strong) IBOutlet UIButton *up;
@property (nonatomic, strong) IBOutlet UIButton *down;
@property (nonatomic, strong) UILabel *titleOfGraph;
@property (nonatomic, strong) NSArray *graphs;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSDictionary* colors;
@property NSInteger currentGraph;

@end

@implementation ODDManyGraphsViewController
@synthesize cards = _cards;

#pragma mark - Alloc/Init

- (instancetype)initWithGraphs:(NSArray *)graphs {
    self = [super init];
    if (self) {
        if (graphs.count == 0) {
            @throw [NSException exceptionWithName:@"InputException"
                                           reason:@"|graphs| must have a count greater than 0"
                                         userInfo:nil];
        }
        self.view.frame = CGRectMake(0,
                                     0,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height * SCROLLVIEW_HEIGHT_RATIO + 20);
        self.view.layer.cornerRadius = 10.0f;
        self.view.layer.masksToBounds = YES;
        self.view.backgroundColor = [UIColor whiteColor];
        _graphs = graphs;
        _headerView = [[UIView alloc] init];
        _currentGraph = 0;
        _titleOfGraph = [[UILabel alloc] init];
        _up = [[UIButton alloc] init];
        _down = [[UIButton alloc] init];
        _colors = [ODDCustomColor customColorDictionary];
        [self setupGraphSizes];
        ODDGraphViewController *currentGraphController = (ODDGraphViewController *)_graphs[_currentGraph];
        [self layoutGraph:currentGraphController atY:0];
        [self initializeHeader];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Analysis"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];

    ODDGraphViewController *currentGraphController = (ODDGraphViewController *)self.graphs[self.currentGraph];
    [currentGraphController reloadDataStore];
    //TODO: Uncomment once completed
//    [self setupCardStatistics];
}

#pragma mark - Subviews Init/Layout

- (void)initializeHeader {
    // Setup Header frame
    CGSize rootFrameSize = self.view.frame.size;
    CGRect headerViewFrame = CGRectMake(0, 0, rootFrameSize.width, HEADER_HEIGHT + STATUS_BAR_HEIGHT);
    self.headerView.layer.cornerRadius = 10.0f;
    self.headerView.layer.masksToBounds = YES;
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.headerView setFrame:headerViewFrame];
    [self.view addSubview:self.headerView];
    
    // Setup Title
    CGFloat adjustedHeight = STATUS_BAR_HEIGHT - 5.0;
    CGFloat titleOfGraphWidth = 190;
    CGRect titleOfGraphFrame = CGRectMake((rootFrameSize.width / 2) - (titleOfGraphWidth / 2),
                                          adjustedHeight,
                                          titleOfGraphWidth,
                                          HEADER_HEIGHT);
    self.titleOfGraph.backgroundColor = [UIColor grayColor];
    [self.titleOfGraph setFrame:titleOfGraphFrame];
    NSString *graphTitle = ((ODDGraphViewController *)self.graphs[self.currentGraph]).graphTitle;
    self.titleOfGraph.text = graphTitle;
    self.titleOfGraph.backgroundColor = [UIColor clearColor];
    self.titleOfGraph.textColor = self.colors[@"oddLook_textcolor"];
    self.titleOfGraph.font = [UIFont fontWithName:@"Helvetica"
                                             size:22];
    self.titleOfGraph.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:self.titleOfGraph];
    
    // Setup |up| and |down| buttons
    [self.up addTarget:self
                action:@selector(showNewGraphFromBelow:)
      forControlEvents:UIControlEventTouchDown];
    [self.down addTarget:self
                  action:@selector(showNewGraphFromAbove:)
        forControlEvents:UIControlEventTouchDown];
    self.up.backgroundColor = [UIColor clearColor];
    [self.up setImage:[UIImage imageNamed:@"increasing.png"] forState:UIControlStateNormal];

    // Header Buttons
    CGFloat buttonWidth = 45;
    CGRect upFrame = CGRectMake(titleOfGraphFrame.origin.x + titleOfGraphFrame.size.width,
                                adjustedHeight,
                                buttonWidth,
                                HEADER_HEIGHT);
    [self.up setFrame:upFrame];
    self.down.backgroundColor = [UIColor clearColor];
    [self.down setImage:[UIImage imageNamed:@"decreasing.png"] forState:UIControlStateNormal];
    CGRect downFrame = upFrame;
    downFrame.origin.x = titleOfGraphFrame.origin.x - buttonWidth;
    [self.down setFrame:downFrame];
    [self.headerView addSubview:self.up];
    [self.headerView addSubview:self.down];
}

- (void)layoutGraph:(ODDGraphViewController *)graphController atY:(CGFloat)y {
    CGPoint currentGraphPosition = graphController.view.frame.origin;
    currentGraphPosition.y = y;
    CGFloat heightPadding = HEADER_HEIGHT + STATUS_BAR_HEIGHT;
    currentGraphPosition.y += heightPadding;
    [graphController setFramePosition:currentGraphPosition];
    [self.view addSubview:graphController.view];
    [self.view sendSubviewToBack:graphController.view];
    [graphController reloadDataStore];
}

- (void)setupGraphSizes {
    CGFloat heightPadding = HEADER_HEIGHT + STATUS_BAR_HEIGHT;
    for (ODDGraphViewController * graphViewController in self.graphs) {
        CGSize currentGraphSize = graphViewController.view.frame.size;
        currentGraphSize.height = self.view.frame.size.height - heightPadding;
        [graphViewController setFrameSize:currentGraphSize];
    }
}

#pragma mark - Button IBActions

// Do we want users to be able to click this as quickly as possible?
- (IBAction)showNewGraphFromAbove:(id)sender {
    NSInteger oldGraph = self.currentGraph;
    NSInteger newGraph = self.currentGraph - 1;
    if (newGraph < 0) {
        newGraph = self.graphs.count - 1;
    }
    self.currentGraph = newGraph;
    NSString *graphTitle = ((ODDGraphViewController *)self.graphs[self.currentGraph]).graphTitle;
    self.titleOfGraph.text = graphTitle;
    self.down.userInteractionEnabled = NO;
    self.up.userInteractionEnabled = NO;
    [self slideOldGraph:oldGraph byDelta:300 slideNewGraph:newGraph byDelta:200];
}

- (IBAction)showNewGraphFromBelow:(id)sender {
    NSInteger oldGraph = self.currentGraph;
    NSInteger newGraph = self.currentGraph + 1;
    if (newGraph == self.graphs.count) {
        newGraph = 0;
    }
    self.currentGraph = newGraph;
    NSString *graphTitle = ((ODDGraphViewController *)self.graphs[self.currentGraph]).graphTitle;
    self.titleOfGraph.text = graphTitle;
    self.down.userInteractionEnabled = NO;
    self.up.userInteractionEnabled = NO;
    [self slideOldGraph:oldGraph byDelta:-300 slideNewGraph:newGraph byDelta:-200];
}

#pragma mark - Animations

- (void)slideOldGraph:(NSUInteger)oldGraph
              byDelta:(NSInteger)oldGraphDelta
        slideNewGraph:(NSUInteger)newGraph
              byDelta:(NSInteger)newGraphDelta {
    ODDGraphViewController *oldGraphController = (ODDGraphViewController *)self.graphs[oldGraph];
    ODDGraphViewController *newGraphController = (ODDGraphViewController *)self.graphs[newGraph];
    newGraphController.view.alpha = 0.0;
    [self layoutGraph:newGraphController atY:-newGraphDelta];
    UIView *oldGraphView = oldGraphController.view;
    UIView *newGraphView = newGraphController.view;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionTransitionCurlDown
                     animations:^{
                         CGRect oldGraphFrame = oldGraphView.frame;
                         oldGraphFrame.origin.y += oldGraphDelta;
                         [oldGraphView setFrame:oldGraphFrame];
                         oldGraphView.alpha = 0.0;
                         
                         CGRect newGraphFrame = newGraphView.frame;
                         newGraphFrame.origin.y += newGraphDelta;
                         [newGraphView setFrame:newGraphFrame];
                         newGraphView.alpha = 1.0;
                         
                     }
                     completion:^(BOOL finished){
                         [oldGraphView removeFromSuperview];
                         self.down.userInteractionEnabled = YES;
                         self.up.userInteractionEnabled = YES;
                     }];
}

#pragma mark - Setup card statistics


// TODO: Complete this method
// If we want longest streak the current method doesn't work
- (void)setupCardStatistics {
    NSArray *entries = ((ODDGraphViewController *)self.graphs[0]).entries;
    NSRange longestStreaks[5] = { NSMakeRange(0, 0),
        NSMakeRange(0, 0),
        NSMakeRange(0, 0),
        NSMakeRange(0, 0),
        NSMakeRange(0, 0) };
    uint totalCounts[5] = { 0, 0, 0, 0, 0 };
    NSUInteger lastRating = [((ODDHappynessEntry *)entries[0]).happyness.rating integerValue],
    currentCount = 1,
    index = 0;
    for (ODDHappynessEntry *entry in entries) {
        NSUInteger rating = [entry.happyness.rating integerValue];
        totalCounts[rating - 1]  +=  1;
        if (rating == lastRating) {
            currentCount += 1;
        } else {
            if (currentCount >= longestStreaks[rating - 1].length) {
                longestStreaks[rating - 1].location = index - currentCount;
                longestStreaks[rating - 1].length = currentCount - 1;
            }
            currentCount = 1;
        }
        lastRating = [entry.happyness.rating integerValue];
        index++;
    }
    
    NSMutableArray *totalCountArray = [[NSMutableArray alloc] initWithCapacity:5],
                *longestStreakArray = [[NSMutableArray alloc] initWithCapacity:5];
    NSString *countString, *streakString, *firstDate, *lastDate;
    ODDHappynessEntry *firstEntry, *lastEntry;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d"];
    for (NSUInteger i = 0; i < 5; i++) {
        countString = [NSString stringWithFormat:@"Total Count:\n%d", totalCounts[i]];
        totalCountArray[i] = countString;
        firstEntry = (ODDHappynessEntry *)entries[longestStreaks[i].location];
        lastEntry = (ODDHappynessEntry *)entries[longestStreaks[i].location +
                                                 longestStreaks[i].length];
        firstDate = [dateFormatter stringFromDate:firstEntry.date];
        lastDate = [dateFormatter stringFromDate:lastEntry.date];
        if (totalCounts[i] == 0) {
            streakString = @"Longest Streak:\tNone";
        } else {
            streakString = [NSString stringWithFormat:@"Longest Streak:\n%@ - %@", firstDate, lastDate];
        }
        longestStreakArray[i] = streakString;
    }
    
    self.cards.cardOccurences = totalCountArray;
    self.cards.longestStreak = longestStreakArray;
}

@end
