//
//  LoginViewController.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController 
@synthesize urlConnection = _urlConnection;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.title = @"Drinkalytics";
//    self.navigationItem.backBarButtonItem.i

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
        default: //should only be 1 section
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];

    
    if (indexPath.section == 0) {
        UITextField *textField;

        if ([indexPath row] == 0) { //email
            textField = [[UITextField alloc] initWithFrame:(CGRectMake(cell.bounds.origin.x + 110, cell.bounds.origin.y + 10, cell.bounds.size.width - 110, cell.bounds.size.height - 10))];
            textField.keyboardType = UIKeyboardTypeEmailAddress;
            textField.returnKeyType = UIReturnKeyNext;
            textField.tag = 0;
            [self setNameField:textField];
        }
        else { //password
            textField = [[UITextField alloc] initWithFrame:(CGRectMake(cell.bounds.origin.x + 110, cell.bounds.origin.y + 10, cell.bounds.size.width - 110.0, cell.bounds.size.height - 10))];
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.returnKeyType = UIReturnKeyDone;
            textField.secureTextEntry = YES;
            textField.tag = 1;
            [self setPasswordField:textField];
            
        }
        textField.adjustsFontSizeToFitWidth = YES;
        textField.textColor = [UIColor blackColor];
        textField.backgroundColor = [UIColor clearColor];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        textField.clearButtonMode = UITextFieldViewModeNever;
        [textField setEnabled: YES];
        [cell addSubview:textField];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //don't highlight cell
    }
    if ([indexPath section] == 0) { // Email & Password Section
        if ([indexPath row] == 0) { // Email
            cell.textLabel.text = @"Username";
        }
        else {
            cell.textLabel.text = @"Password";
        }
    } else {
        cell.textLabel.text = @"Log In";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self loginViaOlinApps];
    } 
}

- (void)loginViaOlinApps
{
    NSString *username = [self.nameField text];
    NSString *password = [self.passwordField text];
    NSURL *url = [[NSURL alloc] initWithString:@"https://olinapps.herokuapp.com/api/exchangelogin"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *postString = [[NSMutableString alloc]init];
    [postString appendFormat:@"username=%@&password=%@", username, password];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    [_urlConnection start];

    if ([response statusCode] == 200) {
        NSError *jsonReadError = nil;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonReadError];
        NSLog(@"%@", responseDict);
        NSString *sessionid = [responseDict objectForKey:@"sessionid"];
        NSString *userid = [responseDict objectForKey:@"id"];
        
        [[NSUserDefaults standardUserDefaults] setValue:sessionid forKey:@"sessionid"];
        [[NSUserDefaults standardUserDefaults] setValue:userid forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:NO];
        UIAlertView *validationMessage = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                                    message:@"Use your regular Olin credentials, eg: jsmith, <password>" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [validationMessage performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
        
    }

}

//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    [_responseData appendData:data];
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    //Oops! handle failure here
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    if (_statusCode >= 200 && _statusCode < 400) {
//        //Things look ok
//        NSString *responseString = [[[NSString alloc] initWithData:_responseData] autorelease];
//        //Send this to an xml lib and parse
//    }
//    
//    [_responseData release];
//    _responseData = nil;
//    [connection autorelease];
//}


@end
