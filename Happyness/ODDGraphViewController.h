//
//  ODDGraphViewController.h
//  Happyness
//
//  Created by Yujun Cho on 6/21/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODDGraphViewController : UIViewController

@property (nonatomic,weak) IBOutlet UILabel *graphTitle;

- (IBAction)graphOneWeek:(id)sender;
- (IBAction)graphOneMonth:(id)sender;
- (IBAction)graphOneYear:(id)sender;
- (IBAction)graphAll:(id)sender;

@end