//
//  RootViewController.h
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface RootViewController : UITableViewController
@property (nonatomic, retain) NSMutableArray *drinksArray;
@property Person *myPerson;
@end
