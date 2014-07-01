//
//  ODDLandscapeAnalysisView.m
//  Happyness
//
//  Created by Yujun Cho on 6/18/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import "ODDLandscapeAnalysisView.h"
#import "ODDLineGraphViewController.h"
#import "ODDBarGraphViewController.h"
#import "JBChartView.h"

@interface ODDLandscapeAnalysisView ()

@end

@implementation ODDLandscapeAnalysisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(touchesBegan:withEvent:)
                       name:@"graphTouchesBegan"
                     object:nil];
        [center addObserver:self
                   selector:@selector(touchesCancelled:withEvent:)
                       name:@"graphTouchesCancelled"
                     object:nil];
        [center addObserver:self
                   selector:@selector(touchesEnded:withEvent:)
                       name:@"graphTouchesEnded"
                     object:nil];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.scrollEnabled = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.scrollEnabled = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.scrollEnabled = YES;
}


@end
