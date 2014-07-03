//
//  ODDGraphViewController.h
//  Happyness
//
//  Created by Yujun Cho on 6/21/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODDPolynomialFit.h"
@class ODDGraphFooterView;
@class ODDGraphSiderView;

@interface ODDGraphViewController : UIViewController

typedef enum:uint8_t {
    ODDGraphAmountAll = 0x1 << 0,
    ODDGraphAmountShortTerm = 0x1 << 1,
    ODDGraphAmountMedium = 0x1 << 2
} ODDGraphAmount;

@property (nonatomic, strong) IBOutlet UILabel *graphTitle;
@property (nonatomic, strong) IBOutlet UIButton *graphAll;
@property (nonatomic, strong) IBOutlet UIButton *graphShortTerm;
@property (nonatomic, strong) IBOutlet UIButton *graphMedium;
@property (nonatomic, strong) UIView *topFrame;
@property (strong, nonatomic) NSMutableArray *entries;
@property NSUInteger shortTermCount;
@property NSUInteger mediumCount;
@property NSUInteger currentAmountOfData;
@property (nonatomic, strong) ODDGraphFooterView *footer;
@property (nonatomic, strong) ODDGraphSiderView *sider;

- (void)reloadDataStore;
- (IBAction)graphShortTerm:(id)sender;
- (IBAction)graphMedium:(id)sender;
- (IBAction)graphAll:(id)sender;

@end