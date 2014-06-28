//
//  ODDGraphViewController.h
//  Happyness
//
//  Created by Yujun Cho on 6/21/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODDGraphViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *graphTitle;
@property (nonatomic, strong) IBOutlet UIButton *graphAll;
@property (nonatomic, strong) IBOutlet UIButton *graphShortTerm;
@property (nonatomic, strong) IBOutlet UIButton *graphMedium;
@property (nonatomic, strong) UIView *topFrame;

- (IBAction)graphShortTerm:(id)sender;
- (IBAction)graphMedium:(id)sender;
- (IBAction)graphAll:(id)sender;

@end