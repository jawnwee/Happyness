//
//  ODDHappynessEntry.h
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ODDHappynessObject.h"
#import "ODDNoteObject.h"

@interface ODDHappynessEntry : NSObject

@property(nonatomic) ODDHappynessObject *happynessObject;
@property(nonatomic) ODDNoteObject *note;
@property(nonatomic) NSString *dateAndTimeString;

- (instancetype)initWithHappynessObjectAndNoteAndDateTime:(ODDHappynessObject *)happynessObject 
                                                     note:(ODDNoteObject *)note 
                                                 dateTime:(NSString *)dateTime;


@end
