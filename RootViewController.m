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
            label = @"Rank in class";
            details = [NSString stringWithFormat:@"%i", 3];
            [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        }
        
    }  else if (indexPath.section == 1) {
        Drink *drink = [self.drinksArray objectAtIndex:indexPath.row];
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
    HTTPController *http = [[HTTPController alloc] init];
    NSDictionary *rankings = [[NSDictionary alloc] initWithDictionary:[http getRankings]] ;
    
    LeaderboardViewController *lvc = [[LeaderboardViewController alloc] init];
    [lvc setRankings:rankings];
    [self.navigationController pushViewController:lvc animated:YES];
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
@end
