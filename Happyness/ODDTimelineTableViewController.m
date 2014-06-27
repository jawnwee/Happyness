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
        _data = [[NSMutableDictionary alloc] init];
        _headers = [[NSMutableArray alloc] init];
        _entries = [[NSMutableArray alloc] initWithArray:
                            [[[ODDHappynessEntryStore sharedStore] happynessEntries] allValues]];

        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];

        _entries = [[NSMutableArray alloc] initWithArray:
                        [_entries sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];

        NSDateFormatter *monthDateFormatter = [[NSDateFormatter alloc] init];
        NSString *dateComponents = @"MMMM YYYY";
        [monthDateFormatter setDateFormat:dateComponents];

        for (ODDHappynessEntry *entry in _entries) {
            NSString *header = [monthDateFormatter stringFromDate:[entry date]];
            if (![self.headers containsObject:header]) {
                [self.headers addObject:header];
                NSMutableArray *sectionEntries = [[NSMutableArray alloc] init];
                [sectionEntries addObject:entry];
                [self.data setObject:sectionEntries forKey:header];
            } else {
                [[self.data objectForKey:header] addObject:entry];
            }

        }

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"ODDHappynessEntryView" bundle:nil];

    [self.tableView registerNib:nib forCellReuseIdentifier:@"ODDHappynessEntryView"];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string = [self.headers objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:245.0 / 255.0 green:247.0 / 255.0 blue:249.0 / 255.0 alpha:1.0]];

    return view;
}

/* Must be hardcoded in */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *header = [self.headers objectAtIndex:section];
    return [[self.data objectForKey:header] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
