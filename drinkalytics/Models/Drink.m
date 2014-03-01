//
//  Drink.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "Drink.h"

@implementation Drink
@synthesize timestamp;
@synthesize details;
@synthesize type;

+ (NSArray *) types {
    NSArray *result = [[NSArray alloc] initWithObjects:@"Beer", @"Wine", @"Shot", @"Mixed Drink", @"Other", nil];
    return result;
}

- (NSString *)elapsedTime {
    NSTimeInterval secondsTime = [self.timestamp timeIntervalSinceNow];
    NSMutableArray *components = [[NSMutableArray alloc] init];

    NSInteger seconds = (NSInteger)secondsTime * -1;
    if (seconds < 60) {
        return @"< 1 minute ago";
    } else {
        NSInteger remainingSeconds = seconds;
        NSInteger days = (remainingSeconds / 86400); //seconds in day
        remainingSeconds -= (days * 86400);
        
        NSInteger hours = (remainingSeconds / 3600); //seconds in an hour
        remainingSeconds -= (hours * 3600);
        
        NSInteger minutes = (remainingSeconds / 60); //second in a minute

        
        if (days > 0) {
            [components addObject:[NSString stringWithFormat:@"%id", days]];
            [components addObject:[NSString stringWithFormat:@"%ih", hours]];
            [components addObject:[NSString stringWithFormat:@"%im ago", minutes]];
        } else if (hours > 1) {
            [components addObject:[NSString stringWithFormat:@"%ih", hours]];
            [components addObject:[NSString stringWithFormat:@"%im ago", minutes]];
        } else {
            
            [components addObject:[NSString stringWithFormat:@"%im ago", minutes]];
        }
        
        
    }
    NSString *elapsed = [components componentsJoinedByString:@" "];
    return elapsed;
}


@end
