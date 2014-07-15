//
//  ODDSelectionCardScrollViewController.h
//  Happyness
//
//  Created by John Lee on 7/14/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDCardScrollViewController.h"

@protocol ODDSelectionCardScrollViewControllerDelegate

- (void)submit;

@end

@interface ODDSelectionCardScrollViewController : ODDCardScrollViewController

@property (nonatomic, weak) id<ODDSelectionCardScrollViewControllerDelegate> delegate;

@end
