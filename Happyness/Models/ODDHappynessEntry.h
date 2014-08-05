//
//  ODDHappynessEntry.h
//  Happyness
//
//  Created by Matthew Chiang on 7/18/14.
//  Copyright (c) 2014 OddLook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ODDHappyness, ODDNote;

@interface ODDHappynessEntry : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) ODDHappyness *happyness;
@property (nonatomic, retain) ODDNote *note;

@end
