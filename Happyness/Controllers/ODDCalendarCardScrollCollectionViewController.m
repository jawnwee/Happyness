//
//  ODDCalendarCardScrollCollectionViewController.m
//  Happyness
//
//  Created by John Lee on 7/9/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarCardScrollCollectionViewController.h"
#import "ODDCalendarCardCollectionViewCell.h"
#import "ODDHappynessHeader.h"

@interface ODDCalendarCardScrollCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *entries;
@property (strong, nonatomic) NSMutableArray *headers;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (strong, nonatomic) NSDateFormatter *monthDateFormatter;

@end

@implementation ODDCalendarCardScrollCollectionViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cardClass = [ODDCalendarCardCollectionViewCell class];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resortAndReload];
}

- (CGSize)cardSizeForLayout {
    CGSize size = CGSizeMake(120, 204.48);
    return size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resortAndReload {
    _data = [[NSMutableDictionary alloc] init];
    _headers = [[NSMutableArray alloc] init];
    [[ODDHappynessEntryStore sharedStore] sortStore:YES];
    _entries = [[ODDHappynessEntryStore sharedStore] sortedStore];
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

    // Reload table view data
    [self reloadCollectionData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self.data objectForKey:self.currentDate] count];
}

// Note: Make sure the cells are the same height as |cardCollectionVeiw|
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODDCalendarCardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell"
                                                                                        forIndexPath:indexPath];
    ODDHappynessEntry *entry = [[self.data objectForKey:self.currentDate] objectAtIndex:indexPath.row];
    [cell setHappynessEntry:entry];
    return cell;
    // When cardCellView is ready uncomment below and above three lines
    // return self.cards[index.row];
}



@end
