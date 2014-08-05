//
//  ODDTutorialHeaderView.h
//  Happyness
//
//  Created by John Lee on 8/3/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ODDTutorialHeaderViewDelegate

- (void)exited;

@end

@interface ODDTutorialHeaderView : UIView

- (instancetype)initWithText:(NSString *)text;
@property (nonatomic, weak) id<ODDTutorialHeaderViewDelegate> delegate;


@end
