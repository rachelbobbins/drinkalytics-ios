//
//  Drink.h
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Drink : NSObject
+ (NSArray *)types;
- (NSString *)elapsedTime;

@property NSDate *timestamp;
@property NSString *type;
@property NSString *details;
@property NSInteger servings;

@end
