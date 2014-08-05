//
//  ODDCardQuoteViewController.m
//  Happyness
//
//  Created by Matthew Chiang on 7/15/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Parse/Parse.h>
#import "ODDCardQuoteScrollViewController.h"
#import "ODDCardQuoteCollectionViewCell.h"

@interface ODDCardQuoteScrollViewController ()

@property (nonatomic, strong) NSMutableDictionary *quoteDictionary;
@property (nonatomic, strong) NSString *filePath;


@end

@implementation ODDCardQuoteScrollViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cardClass = [ODDCardQuoteCollectionViewCell class];
        _quoteDictionary = [[NSMutableDictionary alloc] init];
        _filePath = [[NSBundle mainBundle]pathForResource:@"quotationCards" ofType:@"json"];

        NSData *allFeedbackData = [[NSData alloc] initWithContentsOfFile:_filePath];
        NSError *error;
        _quoteDictionary = [NSJSONSerialization JSONObjectWithData:allFeedbackData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];

        if ([self connected]) {
            PFQuery *query = [PFQuery queryWithClassName:@"QuotationCards"];
            [query getObjectInBackgroundWithId:@"XC2RMfSpjh"
                                         block:^(PFObject *object, NSError *error) {
                NSMutableDictionary *newQuotations = [[NSMutableDictionary alloc] init];
                for (NSString *key in [object allKeys]) {
                    [newQuotations setObject:[object valueForKey:key] forKey:key];
                }
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSData *result = [NSJSONSerialization dataWithJSONObject:newQuotations 
                                                                 options:NSJSONWritingPrettyPrinted 
                                                                   error:&error];
                [fileManager createFileAtPath:self.filePath contents:result attributes:nil];
            }];
        }
    }
    return self;
}

- (BOOL)connected
{
    NSURL *scriptUrl = [NSURL URLWithString:@"http://google.com"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data) {
        return YES;
    } else {
        return NO;
    }
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
    NSString *quote = [NSString stringWithFormat:@"quote%ld", (long)(-indexPath.row + 5)];
    [cell setQuoteText:[self.quoteDictionary objectForKey:quote]];

    return cell;
}

@end
