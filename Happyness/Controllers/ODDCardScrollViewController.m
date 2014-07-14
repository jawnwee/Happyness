//
//  ODDCardScrollView.m
//  Happyness
//
//  Created by Yujun Cho on 7/9/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCardScrollViewController.h"
#import "ODDCardCollectionViewLayout.h"
#import "ODDCardCollectionViewCell.h"
#import "ODDcalendarCardCollectionViewCell.h"

@interface ODDCardScrollViewController ()

@end

@implementation ODDCardScrollViewController
@synthesize cards = _cards;

#pragma mark - Alloc/Init

- (instancetype)init {
    self = [super init];
    if (self) {
        // Customization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCollectionView];
}

#pragma mark - Subviews Init/Layout

- (void)setupCollectionView{
    CGRect viewOriginalFrame = self.view.frame;
    viewOriginalFrame.size.height *= (1 - SCROLLVIEW_HEIGHT_RATIO);
    [self.view setFrame:viewOriginalFrame];
    ODDCardCollectionViewLayout *cardLayout = [[ODDCardCollectionViewLayout alloc] init];
    CGSize cardSize = [self cardSizeForLayout];
    [cardLayout setCardSize:cardSize];
    [cardLayout setItemSize:cardSize];
    _cardCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                             collectionViewLayout:cardLayout];
    _cardCollectionView.backgroundColor = [UIColor whiteColor];
    _cardCollectionView.delegate = self;
    _cardCollectionView.dataSource = self;
    _cardCollectionView.showsVerticalScrollIndicator = NO;
    _cardCollectionView.bounces = NO;
    // Horizontal indicator is set to yes for now for debugging purposes
    [_cardCollectionView registerClass:[self.cardClass class] forCellWithReuseIdentifier:@"cardCell"];
    [self.view addSubview:_cardCollectionView];
}

/* Override this method in subclasses if you want a different card size */
- (CGSize)cardSizeForLayout {
    CGSize size = CGSizeMake(120, 204.48);
    return size;
}

#pragma mark - ODDLook Card Setup
/* DO NOT proceed initializing this controller without setting up your own custom card class 
    extended from ODDCardCollectionViewCell */

- (Class)cardClass {
    if (!_cardClass) {
        _cardClass = [ODDCardCollectionViewCell class];
    }
    return _cardClass;
}

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 5;
}

// Note: Make sure the cells are the same height as |cardCollectionVeiw|
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODDCalendarCardCollectionViewCell *cell =
                                 [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell"
                                                                           forIndexPath:indexPath];
    return cell;
    // When cardCellView is ready uncomment below and above three lines
    // return self.cards[index.row];
}

#pragma mark - Handle Collection Data

- (void)reloadCollectionData {
    // TODO: update contentSize to get appropriate scrolling
    [self.cardCollectionView reloadData];
}

@end
