//
//  ODDCalendarCardScrollCollectionViewController.m
//  Happyness
//
//  Created by John Lee on 7/9/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarCardScrollViewController.h"
#import "ODDCalendarCardCollectionViewCell.h"
#import "ODDCalendarModalViewController.h"
#import "ODDDismissingAnimator.h"
#import "ODDPresentingAnimator.h"
#import "ODDHappynessHeader.h"

@interface ODDCalendarCardScrollViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSMutableArray *entries;
@property (nonatomic, strong) NSMutableArray *headers;
@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, strong) NSDateFormatter *monthDateFormatter;
@property (nonatomic, strong) ODDCalendarCardCollectionViewCell *selectedCell;

@end

@implementation ODDCalendarCardScrollViewController
@synthesize currentDate = _currentDate;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cardClass = [ODDCalendarCardCollectionViewCell class];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resortAndReload];
}


- (void)didReceiveMemoryWarning {
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

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [ODDPresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    ODDHappynessEntry *entry = ((ODDCalendarModalViewController *)dismissed).selectedHappyness;
    if (entry) {
        ODDNote *note = entry.note;
        note.noteString = ((ODDCalendarModalViewController *)dismissed).text;
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            ODDHappynessEntry *localEntry = [entry MR_inContext:localContext];
            ODDNote *localNote = [note MR_inContext:localContext];
            localNote.noteString = ((ODDCalendarModalViewController *)dismissed).text;
            localEntry.note = localNote;
        }];
        [self.selectedCell setHappynessEntry:entry];
        [self.delegate changedEntry];
        //[self reloadCollectionData];
    }

    return [ODDDismissingAnimator new];
}

#pragma mark - UICollectionViewDelegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView 
     numberOfItemsInSection:(NSInteger)section {
    return [[self.data objectForKey:self.currentDate] count];
}

- (void)collectionView:(UICollectionView *)collectionView 
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    self.selectedCell =
             (ODDCalendarCardCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    ODDHappynessEntry *selectedEntry = self.selectedCell.currentEntry;
    
    ODDCalendarModalViewController *noteViewController = [[ODDCalendarModalViewController alloc] init];
    noteViewController.selectedHappyness = selectedEntry;
    if (selectedEntry) {
        noteViewController.text = selectedEntry.note.noteString;
    }
    noteViewController.transitioningDelegate = self;
    noteViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:noteViewController
                       animated:YES
                     completion:NULL];

}

// Note: Make sure the cells are the same height as cardCollectionVeiw|
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODDCalendarCardCollectionViewCell *cell =
                                [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell" 
                                                                          forIndexPath:indexPath];
    ODDHappynessEntry *entry = [[self.data objectForKey:self.currentDate] 
                                            objectAtIndex:indexPath.row];
    [cell setHappynessEntry:entry];
    return cell;
}

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:
                                        NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                   fromDate:date];
    NSString *key = [NSString stringWithFormat:@"%ld/%ld/%ld",
                     (long)[components year], (long)[components month], (long)[components day]];
    ODDHappynessEntry *entry = [[[ODDHappynessEntryStore sharedStore] happynessEntries]
                                                                      objectForKey:key];

    NSInteger index = [[self.data objectForKey:self.currentDate] indexOfObject:entry];
    if ([[self.data objectForKey:self.currentDate] count] >= index && entry) {

        [self.cardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index 
                                                                            inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft 
                                                animated:animated];
    }
}





@end
