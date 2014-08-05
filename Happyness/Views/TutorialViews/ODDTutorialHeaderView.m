//
//  ODDTutorialHeaderView.m
//  Happyness
//
//  Created by John Lee on 8/3/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDTutorialHeaderView.h"
#import "ODDCustomColor.h"

@interface ODDTutorialHeaderView ()

@property (nonatomic, strong) NSString *text;

@end

@implementation ODDTutorialHeaderView

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        _text = text;
        [self setupHeader];
    }
    return self;
}

- (void)setupHeader {
    // Window used for sizing
    UIView *window = [[[UIApplication sharedApplication] delegate] window];

    // Header view
    CGRect headerFrame = CGRectMake(0, 0,
                                    window.frame.size.width,
                                    window.frame.size.height * 0.12);
    headerFrame.origin.y = window.frame.size.height - headerFrame.size.height;
    self.frame = headerFrame;
    self.backgroundColor = [ODDCustomColor textColor];
    self.alpha = 0.90;

    // Text
    CGRect textFrame = CGRectMake(10.0, 0, window.frame.size.width / 2.0, headerFrame.size.height);
    UILabel *textLabel = [[UILabel alloc] initWithFrame:textFrame];
    textLabel.text = self.text;
    textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.numberOfLines = 2.0;


    // Exit button
    CGRect exitFrame = CGRectMake(0.0, 0.0, window.frame.size.width / 4, headerFrame.size.height);
    exitFrame.origin.x = window.frame.size.width - exitFrame.size.width;
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [exitButton addTarget:self 
                   action:@selector(dismiss)
         forControlEvents:UIControlEventTouchUpInside];
    exitButton.tintColor = [UIColor whiteColor];
    exitButton.frame = exitFrame;
    exitButton.titleLabel.font =[UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    exitButton.titleLabel.textColor = [UIColor whiteColor];
    [exitButton setTitle:@"X" forState:UIControlStateNormal];

    [self addSubview:textLabel];
    [self addSubview:exitButton];
}

- (void)dismiss {
    [self.delegate exited];
    [self removeFromSuperview];
}


@end
