//
//  ODDCardScrollView.h
//  Happyness
//
//  Created by Yujun Cho on 7/9/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODDCardScrollViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *cards;

@property (strong, nonatomic) Class cardClass;

- (CGSize)cardSizeForLayout;

@end
