//
//  ODDSelectionCardScrollViewController.m
//  Happyness
//
//  Created by John Lee on 7/14/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <POP/POP.h>
#import "ODDSelectionCardScrollViewController.h"
#import "ODDSelectionCardCollectionViewCell.h"
#import "ODDHappynessHeader.h"
#import "ODDTutorialHeaderView.h"
#import "ODDNoteModalViewController.h"
#import "ODDDismissingAnimator.h"
#import "ODDPresentingAnimator.h"

@interface ODDSelectionCardScrollViewController () <UIViewControllerTransitioningDelegate,
                                                    ODDTutorialHeaderViewDelegate>

@property (nonatomic) NSInteger selectedCard;
@property (nonatomic, strong) ODDHappynessEntry *entryForToday;

@end

@implementation ODDSelectionCardScrollViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cardClass = [ODDSelectionCardCollectionViewCell class];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ODDHappynessEntry *todayEntry = [[ODDHappynessEntryStore sharedStore] todayEntry];
    if (todayEntry) {
        _selectedCard = todayEntry.happyness.value.integerValue;
    } else {
        _selectedCard = -1;
    }
    [self reloadCollectionData];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"tutorialComplete"]) {
        [self exited];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES]
                                                  forKey:@"tutorialComplete"];
    }
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


- (void)collectionView:(UICollectionView *)collectionView
                                didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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

        ODDNoteModalViewController *noteViewController = [[ODDNoteModalViewController alloc] init];

        noteViewController.text = self.entryForToday.note.noteString;
        noteViewController.transitioningDelegate = self;
        noteViewController.modalPresentationStyle = UIModalPresentationCustom;
        [self.view.window.rootViewController presentViewController:noteViewController
                                                          animated:YES
                                                        completion:nil];

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
        
        // This part is slighty awkward, but do not get confused; this is called to reload
        // the piechart if someone randomly decides to change entry through calendar for currentDate
        [self.delegate submit];
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


- (void)saveContext {
    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
    [defaultContext MR_saveToPersistentStoreAndWait];
}

#pragma mark - Tutorial View+Animation

- (void)createTutorialHeader {
    ODDTutorialHeaderView *tutorialHeader = [[ODDTutorialHeaderView alloc]
                                             initWithText:@"To change content, swipe left and right."];
    tutorialHeader.delegate = self;
    tutorialHeader.tag = 222;

    [self.view.window.rootViewController.view addSubview:tutorialHeader];
}

- (void)createTouchButton {
    UIView *window = [[[UIApplication sharedApplication] delegate] window];

    UIImageView *touchButton = [[UIImageView alloc] initWithImage:
                                [UIImage imageNamed:@"TouchButton.png"]];
    // Assigned tag to remove from superview after dismissed
    touchButton.tag = 111;

    CGRect touchButtonFrame = CGRectMake(0, 0,
                                         60, 60);
    touchButtonFrame.origin.x = window.frame.size.width / 2.0;
    touchButtonFrame.origin.y = window.frame.size.height / 2.0;
    touchButton.frame = touchButtonFrame;

    [self.view.window.rootViewController.view addSubview:touchButton];

    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 1.0;
    opacityAnimation.repeatForever = YES;
    POPBasicAnimation *moveLeftAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    moveLeftAnimation.repeatForever = YES;
    moveLeftAnimation.duration = 1.0;
    moveLeftAnimation.toValue = @(touchButton.layer.position.x - 80);

    [moveLeftAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [touchButton.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
        touchButton.layer.repeatCount = 10;
    }];
    [touchButton.layer pop_addAnimation:moveLeftAnimation forKey:@"moveLeftAnimation"];
}

- (void)exited {
    [[self.view.window.rootViewController.view viewWithTag:222] removeFromSuperview];
    [[self.view.window.rootViewController.view viewWithTag:111] removeFromSuperview];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [ODDPresentingAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    ODDHappynessEntry *entry = [[ODDHappynessEntryStore sharedStore] todayEntry];
    if (entry) {
        ODDNote *note = entry.note;
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            ODDNote *local = [note MR_inContext:localContext];
            local.noteString = ((ODDNoteModalViewController *)dismissed).text;
        }];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"tutorialComplete"]) {
        [self createTutorialHeader];
        [self createTouchButton];
    }
    return [ODDDismissingAnimator new];
}

@end
