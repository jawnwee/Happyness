//
//  ODDSelectionModalViewController.m
//  Happyness
//
//  Created by John Lee on 7/24/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDSelectionModalViewController.h"
#import "ODDSelectionCardCollectionViewCell.h"
#import "ODDCardCollectionViewLayout.h"
#import "ODDHappynessHeader.h"
#import "ODDCustomColor.h"

@interface ODDSelectionModalViewController ()

@property (nonatomic) NSInteger currentHappyness;

@end
@implementation ODDSelectionModalViewController

- (instancetype)initWithHappynessEntry:(ODDHappynessEntry *)entry {
    self = [super init];
    if (self) {
        if (entry) {
            _currentEntry = entry;
            _currentHappyness = [entry.happyness.value integerValue];
        } else {
            _currentHappyness = -1;
        }
    }
    return self;
}

- (void)viewDidLoad {
    self.cardClass = [ODDSelectionCardCollectionViewCell class];
    [self setupCollectionView];
    [self selectLabel];
    [self addClearButton];
}

- (void)addClearButton {

    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.translatesAutoresizingMaskIntoConstraints = NO;

    [clearButton setImage:[UIImage imageNamed:@"clear_note.png"]
                 forState:UIControlStateNormal];

    [clearButton addTarget:self
                    action:@selector(dismiss)
          forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:clearButton];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:clearButton
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.f
                                                           constant:-15.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:clearButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];
}

- (void)selectLabel {
    UIButton *selectLabel = [UIButton buttonWithType:UIButtonTypeSystem];
    selectLabel.backgroundColor = [UIColor whiteColor];
    selectLabel.translatesAutoresizingMaskIntoConstraints = NO;
    selectLabel.enabled = NO;
    [selectLabel setTitleColor:[ODDCustomColor textColor] forState:UIControlStateNormal];
    selectLabel.titleLabel.font = [UIFont fontWithName:@"GothamRounded-Bold" size:18];
    selectLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
    [selectLabel setTitle:@"Select a face below:" forState:UIControlStateNormal];
    [self.view addSubview:selectLabel];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:selectLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:-5.f]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:selectLabel
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.f
                                                           constant:20.f]];

}

#pragma mark - Subviews Init/Layout

- (void)setupCollectionView{
    UIView *windowView = (UIView *)([[UIApplication sharedApplication] windows].firstObject);
    CGRect windowFrame = windowView.frame;
    CGRect frame;
    CGSize cardSize;
    if (IS_IPHONE_5) {
        frame = CGRectMake(0.0, 0.0,
                           windowFrame.size.width - 40.0,
                           windowFrame.size.height * SCROLLVIEW_HEIGHT_RATIO - 30.0);
        cardSize = CGSizeMake(120, 204.48);
    } else {
        frame = CGRectMake(0.0, 0.0,
                           windowFrame.size.width - 40.0,
                           windowFrame.size.height * SCROLLVIEW_HEIGHT_RATIO - 90.0);
        cardSize = CGSizeMake(self.view.frame.size.width / 3.5, self.view.frame.size.height * 0.28);
    }
    self.view = [[UIView alloc] initWithFrame:frame];
    ODDCardCollectionViewLayout *cardLayout = [[ODDCardCollectionViewLayout alloc] init];
    [cardLayout setCardSize:cardSize];
    [cardLayout setItemSize:cardSize];
    self.cardCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                             collectionViewLayout:cardLayout];
    self.cardCollectionView.layer.cornerRadius = 8.0;
    self.cardCollectionView.backgroundColor = [UIColor whiteColor];
    self.cardCollectionView.delegate = self;
    self.cardCollectionView.dataSource = self;
    self.cardCollectionView.showsVerticalScrollIndicator = NO;
    self.cardCollectionView.showsHorizontalScrollIndicator = NO;
    self.cardCollectionView.bounces = YES;
    // Horizontal indicator is set to yes for now for debugging purposes
    [self.cardCollectionView registerClass:[self.cardClass class] forCellWithReuseIdentifier:@"cardCell"];
    [self.view addSubview:self.cardCollectionView];
}

#pragma mark - UICollectionView Delegates
- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentHappyness = -(indexPath.row % 5) + 5;
    NSNumber *value = [NSNumber numberWithLong:self.currentHappyness];
    if (self.currentEntry) {
        ODDHappynessEntry *entry = self.currentEntry;
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            ODDHappynessEntry *local = [entry MR_inContext:localContext];
            local.happyness.value = value;
        }];
    } else {
        NSDate *date = self.selectedDate;
        self.currentEntry = [ODDHappynessEntry MR_createEntity];
        ODDHappyness *happyness = [ODDHappyness MR_createEntity];
        happyness.rating = value;
        happyness.value = value;
        happyness.entry = self.currentEntry;

        ODDNote *note = [ODDNote MR_createEntity];
        note.entry = self.currentEntry;

        self.currentEntry.happyness = happyness;
        self.currentEntry.note = note;
        self.currentEntry.date = date;

        [[ODDHappynessEntryStore sharedStore] addEntry:self.currentEntry];
        [[ODDHappynessEntryStore sharedStore] sortStore:YES];
    }
    [self reloadCollectionData];
    [self saveContext];
    [self dismiss];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODDSelectionCardCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"cardCell"
                                              forIndexPath:indexPath];
    // Needed because card names start from oddLook_card_1
    [cell setCardValue:(-(indexPath.row % 5) + 5)];
    if (self.currentHappyness == (-(indexPath.row % 5) + 5)) {
        [cell selectCard];
    } else {
        [cell deselect];
    }
    return cell;
}

- (void)saveContext {
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
    [defaultContext MR_saveToPersistentStoreAndWait];
}

- (void)clearCards {
    self.currentHappyness = -1;
    [self reloadCollectionData];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
