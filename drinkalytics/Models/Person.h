//
//  Person.h
//  drinkalytics
//
//  Created by Rachel Bobbins on 5/8/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property NSString *userId;
@property NSInteger rank;
@property NSInteger numberOfServings;

- (NSString *)name;
@end
