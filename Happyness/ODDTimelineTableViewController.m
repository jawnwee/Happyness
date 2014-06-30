//
//  ODDTimelineViewControllerTableViewController.m
//  Happyness
//
//  Created by John Lee on 6/26/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDTimelineTableViewController.h"
#import "ODDHappynessEntryStore.h"
#import "ODDHappynessEntry.h"
#import "ODDHappynessEntryView.h"
@interface ODDTimelineTableViewController ()

@property (strong, nonatomic) NSMutableArray *entries;
@property (strong, nonatomic) NSMutableArray *headers;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (strong, nonatomic) NSDateFormatter *monthDateFormatter;

@end

@implementation ODDTimelineTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[UINavigationBar appearance] setTitleTextAttributes: @{
                         NSForegroundColorAttributeName: [UIColor darkGrayColor],
                                    NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" 
                                                                         size:18.0f],
                                                                }];
        self.navigationItem.title = @"Timeline";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"ODDHappynessEntryView" bundle:nil];

    [self.tableView registerNib:nib forCellReuseIdentifier:@"ODDHappynessEntryView"];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    _data = [[NSMutableDictionary alloc] init];
    _headers = [[NSMutableArray alloc] init];
    _entries = [[ODDHappynessEntryStore sharedStore] sortedStoreWithAscending:NO];

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];

    _entries = [[NSMutableArray alloc] initWithArray:
                [_entries sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];

    _monthDateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateComponents = @"MMMM YYYY";
    [_monthDateFormatter setDateFormat:dateComponents];
    for (ODDHappynessEntry *entry in self.entries) {
        NSString *header = [self.monthDateFormatter stringFromDate:[entry date]];
        if (![self.headers containsObject:header]) {
            [self.headers addObject:header];
            NSMutableArray *sectionEntries = [[NSMutableArray alloc] init];
            [sectionEntries addObject:entry];
            [self.data setObject:sectionEntries forKey:header];
        } else {
            [[self.data objectForKey:header] addObject:entry];
        }
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.headers count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.headers objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:
                                            CGRectMake(0, 1, tableView.frame.size.width, 24)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];

    label.textAlignment = NSTextAlignmentCenter;
    [label setBackgroundColor:[UIColor whiteColor]];
    NSString *string = [self.headers objectAtIndex:section];
    [label setText:string];

    CALayer *topSublayer = [CALayer layer];
    topSublayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    topSublayer.frame = CGRectMake(0, 0, CGRectGetWidth(label.frame), 1.0f);

    CALayer *bottomSublayer = [CALayer layer];
    bottomSublayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    bottomSublayer.frame = CGRectMake(0, CGRectGetHeight(label.frame), 
                                      CGRectGetWidth(label.frame), 1.0);

    [label.layer addSublayer:topSublayer];
    [label.layer addSublayer:bottomSublayer];

    
    return label;
}

/* Must be hardcoded in */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74.0;
}

#pragma mark - TableView delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *header = [self.headers objectAtIndex:section];
    return [[self.data objectForKey:header] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODDHappynessEntryView *cell =
        [tableView dequeueReusableCellWithIdentifier:@"ODDHappynessEntryView" 
                                        forIndexPath:indexPath];
    NSString *header = [self.headers objectAtIndex:indexPath.section];
    ODDHappynessEntry *entry = [[self.data objectForKey:header] objectAtIndex:indexPath.row];
    [cell setHappynessEntry:entry];
    
    return cell;
}

@end
