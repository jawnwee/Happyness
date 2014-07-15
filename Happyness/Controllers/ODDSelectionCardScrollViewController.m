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

@end

@implementation ODDSelectionCardScrollViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cardClass = [ODDSelectionCardCollectionViewCell class];
        _selectedCard = -1;
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
    self.selectedCard = indexPath.row % 5;
    NSDate *date = [NSDate date];
    ODDHappyness *happyness = [[ODDHappyness alloc] initWithFace:self.selectedCard + 1];
    ODDNote *note = [[ODDNote alloc] init];
    ODDHappynessEntry *entry = [[ODDHappynessEntry alloc] initWithHappyness:happyness
                                                                           note:note
                                                                       dateTime:date];
    [[ODDHappynessEntryStore sharedStore] addEntry:entry];
    [[ODDHappynessEntryStore sharedStore] sortStore:YES];
    [self.delegate submit];
    [self reloadCollectionData];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODDSelectionCardCollectionViewCell *cell =
                                [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell"
                                                                          forIndexPath:indexPath];
    // Needed because card names start from oddLook_card_1
    [cell setCardValue:((indexPath.row % 5) + 1)];
    if (self.selectedCard == indexPath.row % 5) {
        [cell selectCard];
    } else {
        [cell deselect];
    }
    return cell;
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

@end
