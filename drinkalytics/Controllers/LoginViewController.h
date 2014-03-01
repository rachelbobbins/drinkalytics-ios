//
//  LoginViewController.h
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UITableViewController <NSURLConnectionDelegate, UITextFieldDelegate>
@property UITextField *nameField;
@property UITextField *passwordField;
@property UISwitch *cacheCredentialsSwitch;
@property NSURLConnection *urlConnection;
@property NSDictionary *savedUsers;
@property NSEnumerator *enumerateOverUsers;
@end
