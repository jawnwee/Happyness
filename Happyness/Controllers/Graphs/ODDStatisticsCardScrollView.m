//
//  ODDStatisticsCardScrollView.m
//  Happyness
//
//  Created by Yujun Cho on 7/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDStatisticsCardScrollView.h"
#import "ODDStatisticsCollectionViewCell.h"
#import "ODDHappynessHeader.h"

@implementation ODDStatisticsCardScrollView
@synthesize longestStreak = _longestStreak;
@synthesize cardOccurences = _cardOccurences;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cardClass = [ODDStatisticsCollectionViewCell class];
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
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODDStatisticsCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell"
                                              forIndexPath:indexPath];
    
    // Needed because card names start from oddLook_card_1
    NSUInteger index = -indexPath.row + 5;
    [cell setCardValueAndLabelsShadow:index];
    
    
    [cell setOccurencesText:self.cardOccurences[index - 1]];
    //[cell setLongestStreakText:self.longestStreak[index - 1]];

    return cell;
}

@end
