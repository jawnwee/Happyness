//
//  ODDCalendarCardScrollCollectionViewController.h
//  Happyness
//
//  Created by John Lee on 7/9/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCardScrollViewController.h"

@protocol ODDCalendarCardScrollViewControllerDelegate

- (void)changedEntry;

@end

@interface ODDCalendarCardScrollViewController : ODDCardScrollViewController

@property (strong, nonatomic) NSString *currentDate;

-(void)scrollToDate:(NSDate *)date animated:(BOOL)animated;

- (void)resortAndReload;

@property (nonatomic, weak) id<ODDCalendarCardScrollViewControllerDelegate> delegate;


@end
