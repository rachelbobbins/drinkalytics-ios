//
//  TakeADrinkViewController.h
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakeADrinkViewController : UITableViewController <UIPickerViewDelegate>
@property UITextField *detailsField;
@property UIPickerView *typePicker;
@property NSManagedObjectContext *managedObjectContext;
@end
