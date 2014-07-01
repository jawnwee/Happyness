//
//  ODDTodayViewController.h
//  Happyness
//
//  Created by John Lee on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
@class ODDTodayNoteView;

@interface ODDTodayViewController : UIViewController <HPGrowingTextViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (strong, nonatomic) ODDTodayNoteView *noteView;

@end
