//
//  RootViewController.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "RootViewController.h"
#import "LeaderboardViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
            return 3;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    NSString *label;
    NSString *details;
    CGFloat adjustedWidth = cell.bounds.size.width - 20.0;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            label = @"Total Drinks";
            details = @"47";
        } else if (indexPath.row == 1) {
            label = @"Last Drink";
            details = @"23 minutes ago";
        } else {
            label = @"Rank in class";
            details = @"4 of 56";
            adjustedWidth = adjustedWidth - 30.0;
            [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        }
    }   else {
            label = @"No drinks yet";
    }
    cell.textLabel.text = label;
    UILabel *detailView = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.origin.x, cell.bounds.origin.y, adjustedWidth, cell.bounds.size.height)];
    detailView.text = details;
    detailView.textAlignment = NSTextAlignmentRight;
    detailView.backgroundColor = [UIColor clearColor];
    [cell addSubview:detailView];
    
    // Configure the cell...
    
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationController pushViewController:[[LeaderboardViewController alloc] init] animated:YES];
}

@end
