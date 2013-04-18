//
//  RootViewController.h
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController
@property (nonatomic, retain) NSMutableArray *drinksArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end
