//
//  ODDCalendarCardScrollCollectionViewController.m
//  Happyness
//
//  Created by John Lee on 7/9/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCalendarCardScrollCollectionViewController.h"
#import "ODDCalendarCardCollectionViewCell.h"

@interface ODDCalendarCardScrollCollectionViewController ()

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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}


@end
