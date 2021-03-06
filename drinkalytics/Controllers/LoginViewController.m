//
//  LoginViewController.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "LoginViewController.h"
#import "HTTPController.h"
#import "LeaderboardViewController.h"
#import "RootViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController 
@synthesize urlConnection = _urlConnection;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {

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

- (void) viewWillAppear:(BOOL)animated {
    self.savedUsers = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:@"savedUsers"];
    self.enumerateOverUsers = [self.savedUsers keyEnumerator];
    
    [self.tableView reloadData];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            if ( [self.savedUsers.allKeys count] > 0 ) {
                return [self.savedUsers.allKeys count];
            } else {
                return 1;
            }
        case 1:
            return 3;
        case 2:
            return 1;
        default: //should only be 1 section
            return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Saved Accounts";
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];

    if (indexPath.section == 0) {
        if ([self.savedUsers count] > 0) {
            cell.textLabel.text = [self.enumerateOverUsers nextObject];
        } else {
            cell.textLabel.text = @"None saved";
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }
    else if (indexPath.section == 1) {
        if ([indexPath row] == 0 || [indexPath row] == 1) {
            UITextField *textField;
            
            if ([indexPath row] == 0) { //email
                cell.textLabel.text = @"Username";
                textField = [[UITextField alloc] initWithFrame:(CGRectMake(cell.bounds.origin.x + 110, cell.bounds.origin.y + 10, cell.bounds.size.width - 110, cell.bounds.size.height - 10))];
                textField.keyboardType = UIKeyboardTypeEmailAddress;
                textField.returnKeyType = UIReturnKeyNext;
                [self setNameField:textField];
            }
            else { //password
                cell.textLabel.text = @"Password";
                textField = [[UITextField alloc] initWithFrame:(CGRectMake(cell.bounds.origin.x + 110, cell.bounds.origin.y + 10, cell.bounds.size.width - 110.0, cell.bounds.size.height - 10))];
                textField.keyboardType = UIKeyboardTypeDefault;
                textField.returnKeyType = UIReturnKeyDone;
//                textField.returnKeyType
                textField.secureTextEntry = YES;
                [self setPasswordField:textField];
                
            }
            textField.adjustsFontSizeToFitWidth = YES;
            textField.textColor = [UIColor blackColor];
            textField.backgroundColor = [UIColor clearColor];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            
            textField.clearButtonMode = UITextFieldViewModeNever;
            textField.delegate = self;
            textField.enablesReturnKeyAutomatically=YES;
            [textField setEnabled: YES];
            [cell addSubview:textField];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //don't highlight cell
        } else if ([indexPath row] == 2) {
            cell.textLabel.text = @"Save Credentials?";
            UISwitch *saveCredentials = [[UISwitch alloc] init];
            [self setCacheCredentialsSwitch:saveCredentials];
            [cell setAccessoryView:saveCredentials];
        }

    } else if (indexPath.section == 2) {
        cell.textLabel.text = @"Log In";
        cell.tag = 2;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { //prepoulate username with email/password
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.nameField.text = cell.textLabel.text;
        self.passwordField.text = [self.savedUsers valueForKey:cell.textLabel.text];
        self.cacheCredentialsSwitch.on = YES;
        [cell setSelected:NO];
    } else if (indexPath.section == 2) {
        [self loginViaOlinApps];
    } 
}

- (void)loginViaOlinApps
{
    [self.view endEditing:YES];
    
    NSString *username = [self.nameField text];
    NSString *password = [self.passwordField text];
    BOOL shouldSaveCredentials = [self.cacheCredentialsSwitch isOn];
    self.passwordField.text = @"";
    
    UIActivityIndicatorView *spinner = [self createSpinner];
    
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    [spinner startAnimating];
    
    HTTPController *http = [[HTTPController alloc] init];
    
    if ([http loginWithUsername:username andPassword:password andSaveCredentials:shouldSaveCredentials]) {
        dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
        
        dispatch_async(downloadQueue, ^{
            BOOL userIsSenior = [http userIsSenior];
            if (!userIsSenior && !([username isEqualToString:@"mchang"])) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"userIsSenior"];                
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                LeaderboardViewController *lvc = [[LeaderboardViewController alloc] init];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinner stopAnimating];
                    [spinner removeFromSuperview];
                    
                    lvc.navigationItem.hidesBackButton = YES;
                    [self.navigationController pushViewController:lvc animated:YES];
                    
                    
                });

            } else {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userIsSenior"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinner stopAnimating];
                    [spinner removeFromSuperview];
                    RootViewController *rvc = [[RootViewController alloc] init];
                    [self.navigationController pushViewController:rvc animated:YES];
                });
            }

        });
    } else {
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:NO];
        UIAlertView *validationMessage = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                    message:@"Use your regular Olin credentials, eg: jsmith, <password>" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [validationMessage performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    }


}


- (UIActivityIndicatorView *) createSpinner
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGFloat centerx = self.tableView.contentSize.width / 2;
    CGFloat centery = self.tableView.bounds.size.height / 2 + self.tableView.contentOffset.y;
    [spinner setCenter:CGPointMake(centerx, centery)];
    
    [spinner setHidden:NO];
    [spinner setBackgroundColor:[UIColor blackColor]];
    [spinner setBounds:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [spinner setOpaque:NO];
    [spinner setAlpha:0.8];
    
    return spinner;
}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    NSLog(@"here");
//    [textField resignFirstResponder];
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
