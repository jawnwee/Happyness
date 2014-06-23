//
//  ODDNoteObject.h
//  Happyness
//
//  Created by Matthew Chiang on 6/16/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODDNote : NSObject

@property (strong, nonatomic) NSString *noteString;

- (instancetype)initWithNote:(NSString *)note;

@end
