//
//  HTTPController.h
//  drinkalytics
//
//  Created by Rachel Bobbins on 5/5/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
@interface HTTPController : NSObject 
- (void)postDrinkWithType:(NSString *)name andDetails:(NSString *)detail andServings:(NSInteger)servings;
- (NSDictionary *)getRankings;
- (NSArray *)getMyDrinks:(NSString *)userId;
- (Person *)getMyPerson;
- (BOOL)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
- (BOOL)userIsSenior;
@end
