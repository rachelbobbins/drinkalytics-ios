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
    
    UIActivityIndicatorView *spinner = [self createSpinner];
    
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
    [spinner startAnimating];
    
    HTTPController *http = [[HTTPController alloc] init];
    
    if ([http loginWithUsername:username andPassword:password]) {
        dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
        
        dispatch_async(downloadQueue, ^{
            BOOL userIsSenior = [http userIsSenior];
            if (!userIsSenior) {
                NSDictionary *rankings = [[NSDictionary alloc] initWithDictionary:[http getRankings]] ;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [spinner stopAnimating];
                    [spinner removeFromSuperview];
                    LeaderboardViewController *lvc = [[LeaderboardViewController alloc] init];
                    [lvc setRankings:rankings];
                    [lvc setSeniorMode:NO];
                    
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"userIsSenior"];
                    lvc.navigationItem.hidesBackButton = YES;
                    [self.navigationController pushViewController:lvc animated:YES];
                    
                    
                });

            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userIsSenior"];
                    [self.navigationController popViewControllerAnimated:YES];
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

@end
