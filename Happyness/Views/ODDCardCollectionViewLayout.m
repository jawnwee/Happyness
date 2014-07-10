//
//  ODDCardCollectionViewLayout.m
//  Happyness
//
//  Created by Yujun Cho on 7/9/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCardCollectionViewLayout.h"

@interface ODDCardCollectionViewLayout ()

@property (nonatomic) CGSize cardSize;

@end

@implementation ODDCardCollectionViewLayout

#pragma mark - Alloc/Init

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // This is used to determine the spacing between each item in the collection
    self.minimumLineSpacing = 18;
    [self setScrollDirection:UICollectionViewScrollDirectionHorizontal];
}

#pragma mark - Getters

- (CGSize)collectionViewContentSize {
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    NSInteger pages = ceil(itemCount / 4);
    
    // When cardCellView is done uncomment bellow and delete above
    // NSInteger pages = ceil(itemCount / self.cardSize.width);
    
    return CGSizeMake(300 * pages, self.collectionView.frame.size.height);
}

#pragma mark - Setters

- (void)setCardSize:(CGSize)size {
    self.cardSize = size;
}

@end
