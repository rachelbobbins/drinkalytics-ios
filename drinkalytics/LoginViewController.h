//
//  LoginViewController.h
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UITableViewController <NSURLConnectionDelegate>
@property UITextField *nameField;
@property UITextField *passwordField;

@end
