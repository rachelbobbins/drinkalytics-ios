//
//  Drink.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "Drink.h"

@implementation Drink

+ (NSArray *) types {
    NSArray *result = [[NSArray alloc] initWithObjects:@"-", @"Beer", @"Wine", @"Shot!", @"Mixed Drink", @"Other", nil];
    return result;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
