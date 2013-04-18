//
//  LeaderboardViewController.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "LeaderboardViewController.h"

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController

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
    [self.navigationItem setTitle:@"Leaderboard"];
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
            return 1;
        case 1:
            return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"1013 down. 1000 to go.";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat progressWidth = cell.bounds.size.width - 20;
        CGFloat progressHeight = cell.bounds.size.height;
        CGFloat originX = cell.bounds.origin.x + 10;
        CGFloat originY = cell.bounds.origin.y;
        
        UIView *progressBar = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, progressWidth, progressHeight)];
        
        [cell addSubview:progressBar];
        NSLog(@"%f", originX);
        
        CGFloat doneWidth = (progressWidth - 30) / 2013 * 1013 ;
        UIView *done = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doneWidth, progressHeight)];
        [done setBackgroundColor:[UIColor greenColor]];
        
        CGFloat remainingWidth = progressWidth - doneWidth;
        UIView *remaining = [[UIView alloc] initWithFrame:CGRectMake(doneWidth, 0, remainingWidth, progressHeight)];
        [remaining setBackgroundColor:[UIColor lightGrayColor]];
        [progressBar addSubview:done];
        [progressBar addSubview:remaining];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundView:progressBar];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
