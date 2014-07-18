//
//  ODDSelectionCardScrollViewController.m
//  Happyness
//
//  Created by John Lee on 7/14/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDSelectionCardScrollViewController.h"
#import "ODDSelectionCardCollectionViewCell.h"
#import "ODDHappynessHeader.h"

@interface ODDSelectionCardScrollViewController ()

@property (nonatomic) NSInteger selectedCard;
@property (nonatomic, strong) ODDHappynessEntry *entryForToday;

@end

@implementation ODDSelectionCardScrollViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cardClass = [ODDSelectionCardCollectionViewCell class];
        _selectedCard = -1;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(clearCards)
                                                    name:UIApplicationSignificantTimeChangeNotification
                                                    object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cardCollectionView.showsHorizontalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 10;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCard = -(indexPath.row % 5) + 5;
    NSNumber *value = [NSNumber numberWithLong:self.selectedCard];
    if (self.entryForToday) {
        self.entryForToday.happyness.value = value;
    } else {
        NSDate *date = [NSDate date];
        self.entryForToday = [ODDHappynessEntry MR_createEntity];
        ODDHappyness *happyness = [ODDHappyness MR_createEntity];
        happyness.rating = value;
        happyness.value = value;
        happyness.entry = self.entryForToday;

        ODDNote *note = [ODDNote MR_createEntity];
        note.entry = self.entryForToday;

        self.entryForToday.happyness = happyness;
        self.entryForToday.note = note;
        self.entryForToday.date = date;

        [[ODDHappynessEntryStore sharedStore] addEntry:self.entryForToday];
        [[ODDHappynessEntryStore sharedStore] sortStore:YES];
    }
    [self.delegate submit];
    [self reloadCollectionData];
    [self saveContext];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODDSelectionCardCollectionViewCell *cell =
                                [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell"
                                                                          forIndexPath:indexPath];
    // Needed because card names start from oddLook_card_1
    [cell setCardValue:(-(indexPath.row % 5) + 5)];
    if (self.selectedCard == (-(indexPath.row % 5) + 5)) {
        [cell selectCard];
    } else {
        [cell deselect];
    }
    return cell;
}

- (void)clearCards {
    self.selectedCard = -1;
    self.entryForToday = nil;
    [self reloadCollectionData];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    CGFloat contentWidth = scrollView.contentSize.width;
    if (currentOffsetX > ((contentWidth * 5) / 8.0)) {
        scrollView.contentOffset = CGPointMake(currentOffsetX - (contentWidth / 2.0), currentOffsetY);
    }
    if (currentOffsetX < (contentWidth / 8.0)) {
        scrollView.contentOffset = CGPointMake(currentOffsetX + (contentWidth / 2.0), currentOffsetY);
    }
}

- (void)saveContext {
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
    [defaultContext MR_saveToPersistentStoreAndWait];
}

@end
