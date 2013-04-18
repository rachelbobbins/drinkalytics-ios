//
//  Drink.h
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Drink : NSManagedObject
+ (NSArray *)types;
- (NSString *)elapsedTime;

@property NSDate *timestamp;
@property NSString *type;
@property NSString *details;


@end
