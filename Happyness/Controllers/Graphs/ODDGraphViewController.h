//
//  ODDGraphViewController.h
//  Happyness
//
//  Created by Yujun Cho on 6/21/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODDGraphFooterView.h"
#import "ODDColoredAxisView.h"
#import "ODDColoredLinesView.h"
#import "ODDHappynessEntryStore.h"
#import "ODDHappynessEntry.h"
#import "ODDHappyness.h"
#import "ODDDoubleArrayHolder.h"

@protocol ODDGraphViewControllerDelegate

- (void)graphViewChanged:(NSInteger)count;

@end

@interface ODDGraphViewController : UIViewController

/*** "Public methods and variables ***/

@property (nonatomic, strong) ODDGraphFooterView *footer;
@property (nonatomic, strong) ODDColoredAxisView *sider;
@property (nonatomic, strong) ODDColoredLinesView *backgroundLines;
@property (nonatomic, strong) UIView *graph;
@property (nonatomic, weak) id<ODDGraphViewControllerDelegate> delegate;


- (void)setFrameSize:(CGSize)size;
- (void)setFramePosition:(CGPoint)point;
- (void)reloadDataStore;

/*** "Protected" methods and variables ***/
// These should only be used within the class and its subclasses.
// The proper way to make these protected is to create a seperate header.

typedef enum:uint8_t {
    ODDGraphAmountAll = 0x1 << 0,
    ODDGraphAmountShortTerm = 0x1 << 1,
    ODDGraphAmountMedium = 0x1 << 2
} ODDGraphAmount;

@property (nonatomic, copy) NSString *graphTitle;
@property (nonatomic, strong) IBOutlet UILabel *notEnoughDataLabel;
@property (nonatomic, strong) IBOutlet UIButton *graphAll;
@property (nonatomic, strong) IBOutlet UIButton *graphShortTerm;
@property (nonatomic, strong) IBOutlet UIButton *graphMedium;
@property (nonatomic, strong) UIView *topFrame;
@property (strong, nonatomic) NSMutableArray *entries;
@property NSUInteger shortTermCount;
@property NSUInteger mediumCount;
@property NSUInteger currentAmountOfData;
@property (nonatomic,strong) ODDDoubleArrayHolder *allData;
@property (nonatomic,strong) ODDDoubleArrayHolder *mediumeData;
@property (nonatomic,strong) ODDDoubleArrayHolder *shortData;
@property (nonatomic, strong) NSDictionary* colors;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (IBAction)graphShortTerm:(id)sender;
- (IBAction)graphMedium:(id)sender;
- (IBAction)graphAll:(id)sender;

@end