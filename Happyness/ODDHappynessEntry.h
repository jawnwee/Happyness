//
//  ODDHappynessEntry.h
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ODDHappyness, ODDNote;

@interface ODDHappynessEntry : NSObject

@property (strong, nonatomic) ODDHappyness *happynessObject;
@property (strong, nonatomic) ODDNote *note;
@property (strong, nonatomic) NSString *dateAndTimeString;

- (instancetype)initWithHappyness:(ODDHappyness *)happyness
                             note:(ODDNote *)note
                         dateTime:(NSString *)dateTime;

@end
