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

@property (nonatomic, strong) NSMutableArray *entries;
@property (nonatomic, strong) NSMutableArray *headers;
@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, strong) NSDateFormatter *monthDateFormatter;

@end

@implementation ODDCalendarCardScrollCollectionViewController
@synthesize currentDate = _currentDate;

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

- (NSInteger)collectionView:(UICollectionView *)collectionView 
     numberOfItemsInSection:(NSInteger)section {
    return [[self.data objectForKey:self.currentDate] count];
}

// Note: Make sure the cells are the same height as |cardCollectionVeiw|
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODDCalendarCardCollectionViewCell *cell =
                                [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell" 
                                                                          forIndexPath:indexPath];
    ODDHappynessEntry *entry = [[self.data objectForKey:self.currentDate] 
                                            objectAtIndex:indexPath.row];
    [cell setHappynessEntry:entry];
    return cell;
    // When cardCellView is ready uncomment below and above three lines
    // return self.cards[index.row];
}

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                        NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];

    NSInteger index = [components day] - 1;
    if ([[self.data objectForKey:self.currentDate] count] >= index) {
        [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index 
                                                                            inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft 
                                                animated:animated];
    }
}





@end
