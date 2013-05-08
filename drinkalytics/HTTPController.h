//
//  HTTPController.h
//  drinkalytics
//
//  Created by Rachel Bobbins on 5/5/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPController : NSObject <NSURLConnectionDelegate>
//- (void)postDrinkWithType:(NSString *)name andDetails:(NSString *)detail;
//- (void)getMyDrinks;
- (void)getEveryonesDrinks;
- (BOOL)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
@property NSMutableData *responseData;
//NSMutableData *_responseData;
@end
