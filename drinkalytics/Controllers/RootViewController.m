//
//  RootViewController.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "RootViewController.h"
#import "LeaderboardViewController.h"
#import "TakeADrinkViewController.h"
//#import "LoginViewController.h"
#import "HTTPController.h"
#import "Drink.h"

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize drinksArray;

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
    [self.navigationItem setTitle:@"Drinkalytics"];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                            style:UIBarButtonSystemItemCancel
                                                                           target:self
                                                                           action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Drink"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(takeDrink)];

}
- (void)viewWillAppear:(BOOL)animated
{
    HTTPController *http = [[HTTPController alloc] init];
    self.myPerson = [http getMyPerson];
    
    [self setDrinksArray];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
        case 1:
            return [self.drinksArray count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell; 

    
    NSString *label;
    NSString *details;
    
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0) {
            label = @"Total Servings";
            details = [NSString stringWithFormat:@"%i", self.myPerson.numberOfServings];
        } else if (indexPath.row == 1) {
            label = @"Individual Drinks";
            details = [NSString stringWithFormat:@"%i", [self.drinksArray count]];
        }
        else if (indexPath.row == 2) {
            label = @"Last Drink";
            if ([self.drinksArray count] == 0) {
                details = @"Never :(";
            } else {
                details = [(Drink *)[self.drinksArray objectAtIndex:0] elapsedTime];
            }
        } else {
            label = @"Rank in class";
            details = [NSString stringWithFormat:@"%i", self.myPerson.rank];
            [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        }
        
    }  else if (indexPath.section == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        Drink *drink = [self.drinksArray objectAtIndex:indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
            NSMutableString * fooLabel = [[NSMutableString alloc] init];
            [fooLabel appendString:[NSString stringWithFormat:@"%@ (x%i)", drink.type, drink.servings]];
            if (drink.details && [drink.details length] > 0) {
                [fooLabel appendString:[NSString stringWithFormat:@": %@", drink.details]];
            }
        label = [NSString stringWithString:fooLabel];
            
       
        details = [drink elapsedTime];
    }
    
    cell.textLabel.text = label;
    cell.detailTextLabel.text = details;
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Summary";
        case 1:
            return @"Drink Log\n(click a drink to do it again)";
        default:
            return @"";
    }
}

#pragma mark - Table view delegate


- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    LeaderboardViewController *lvc = [[LeaderboardViewController alloc] init];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) { //click on a drink to drink it again.
        Drink *drink = [self.drinksArray objectAtIndex:indexPath.row];
        NSString *type = [drink type];
        NSInteger rowind = [[Drink types] indexOfObject:type];
        
        TakeADrinkViewController *dvc = [[TakeADrinkViewController alloc] init];
        [dvc.typePickerView.pickerView selectRow:rowind inComponent:0 animated:NO];
        dvc.detailsField.text = drink.details;
        dvc.detailsField.placeholder = nil;
        dvc.numberOfServings.selectedSegmentIndex = drink.servings - 1;
        [self.navigationController pushViewController:dvc animated:YES];
        

    }
}

- (void) takeDrink
{
    TakeADrinkViewController *drinkController = [[TakeADrinkViewController alloc] init];
    [self.navigationController pushViewController:drinkController animated:YES];
}

- (void)setDrinksArray {
    HTTPController *http = [[HTTPController alloc] init];
    self.drinksArray = [[http getMyDrinks:[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]] mutableCopy];

}

- (void)logout
{
    NSLog(@"logging out: all keys: %@", [NSUserDefaults standardUserDefaults]);
    //clear everything EXCEPT for list of saved user credentials
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"sessionid"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"savedCookies"];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
