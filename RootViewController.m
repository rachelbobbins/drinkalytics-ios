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
        // Custom initialization
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
            return 3;
        case 1:
            return [self.drinksArray count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];

    
    NSString *label;
    NSString *details;
    
    if (indexPath.section == 0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0) {
            label = @"Total Drinks";
            details = [NSString stringWithFormat:@"%i", [self.drinksArray count]];
        } else if (indexPath.row == 1) {
            label = @"Last Drink";
            if ([self.drinksArray count] == 0) {
                details = @"Never :(";
            } else {
                details = [(Drink *)[self.drinksArray objectAtIndex:0] elapsedTime];
            }
        } else {
            HTTPController *http = [[HTTPController alloc] init];
            label = @"Rank in class";
            details = [NSString stringWithFormat:@"%i", [http getMyRank]];
            [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        }
        
    }  else if (indexPath.section == 1) {
        Drink *drink = [self.drinksArray objectAtIndex:indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        
        if (drink.details && drink.type) {
            label = [NSString stringWithFormat:@"%@: %@", drink.type, drink.details];
        } else {
            label = drink.type;
        }
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
            return @"Drink Log";
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
        //TODO: prepopulate with whatever this drink *actually* is, after Tim adds "detail" property to model
        Drink *drink = [self.drinksArray objectAtIndex:indexPath.row];
        NSString *type = [drink type];
        NSString *details = [drink details];
        NSInteger servings = [drink servings];
        
        NSInteger rowind = [[Drink types] indexOfObject:type];
        
        TakeADrinkViewController *dvc = [[TakeADrinkViewController alloc] init];
        [dvc.typePickerView.pickerView selectRow:rowind inComponent:0 animated:NO];
        dvc.detailsField.text = details;
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
    //clear sessionid, userid, userissenior
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
