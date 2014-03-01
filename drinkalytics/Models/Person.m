//
//  Person.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 5/8/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "Person.h"

@implementation Person
- (NSString *) name
{
    NSString *result = [self.userId stringByReplacingOccurrencesOfString:@"." withString:@" "];
    result = [result capitalizedString];
    return result;
}
@end
