//
//  ODDCardScrollView.m
//  Happyness
//
//  Created by Yujun Cho on 7/9/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCardScrollViewController.h"
#import "ODDCardCollectionViewLayout.h"

@interface ODDCardScrollViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *cardCollectionView;

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
    _cardCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                             collectionViewLayout:cardLayout];
    _cardCollectionView.backgroundColor = [UIColor grayColor];
    _cardCollectionView.delegate = self;
    _cardCollectionView.dataSource = self;
    _cardCollectionView.showsVerticalScrollIndicator = NO;
    // Horizontal indicator is set to yes for now for debugging purposes
    _cardCollectionView.showsHorizontalScrollIndicator = YES;
    [_cardCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:_cardCollectionView];
}

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return 15;
    // When cardCellView is ready uncomment bellow and remove line above
    // return self.cards.count;
}

// Note: Make sure the cells are the same height as |cardCollectionVeiw|
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier"
                                                                           forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
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
