//
//  TakeADrinkViewController.h
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrinkPickerView.h"

@interface TakeADrinkViewController : UITableViewController 
@property UITextField *detailsField;
@property DrinkPickerView *typePickerView;
@property NSManagedObjectContext *managedObjectContext;
@end
