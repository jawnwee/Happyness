//
//  ODDCardQuoteViewController.m
//  Happyness
//
//  Created by Matthew Chiang on 7/15/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCardQuoteScrollViewController.h"
#import "ODDCardQuoteCollectionViewCell.h"

@interface ODDCardQuoteScrollViewController ()

@property (nonatomic, strong) NSDictionary *quoteDictionary;

@end

@implementation ODDCardQuoteScrollViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cardClass = [ODDCardQuoteCollectionViewCell class];
        _quoteDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSString stringWithFormat:@"For every minute you are angry, you lose sixty seconds of happiness \n\n - Ralph Waldo Emerson"], @"quote_1",
                            [NSString stringWithFormat:@"The best way to cheer yourself up is to try cheer someone else up \n\n - Mark Twain"], @"quote_2",
                            [NSString stringWithFormat:@"If you think sunshine brings you happiness, then you haven't danced in the rain \n\n - Anonymous"], @"quote_3",
                            [NSString stringWithFormat:@"Yesterday I was clever, so I wanted to change the world. Today I am wise, so I am changing myself \n\n - Rumi"], @"quote_4",
                            [NSString stringWithFormat:@"Happiness is as a butterfly which, when pursued, is always beyond our grasp, but which if you will sit down quietly, may alight upon you \n\n - Nathaniel Hawthorne"], @"quote_5",
                            nil];
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
    ODDCardQuoteCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell"
                                              forIndexPath:indexPath];
    // Needed because card names start from oddLook_card_1
    [cell setCardValueAndQuoteTextShadow:-indexPath.row + 5];
    NSString *quote = [NSString stringWithFormat:@"quote_%ld", (long)(-indexPath.row + 5)];
    [cell setQuoteText:[self.quoteDictionary objectForKey:quote]];

    return cell;
}

@end
