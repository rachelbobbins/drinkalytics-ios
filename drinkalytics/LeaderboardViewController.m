//
//  LeaderboardViewController.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "Person.h"
#import "HTTPController.h"

@interface LeaderboardViewController ()

@end

@implementation LeaderboardViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    NSLog(@"called");
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        NSLog(@"user is senior: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userIsSenior"]);
        HTTPController *http = [[HTTPController alloc] init];
        NSDictionary *rankings = [[NSDictionary alloc] initWithDictionary:[http getRankings]] ;
        
        [self setRankings:rankings];
        [self setSeniorMode:[[NSUserDefaults standardUserDefaults] valueForKey:@"userIsSenior"]];


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    if (self.seniorMode) {
        [self.navigationItem setTitle:@"Leaderboard"];
    } else {
        [self.navigationItem setTitle:@"This could be you next year!"];
    }
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
            return [self.rankings count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell;
    if (indexPath.section == 0) {
        NSInteger totalDrinks = 0;
        for (Person *person in [self.rankings allValues]) {
            totalDrinks = totalDrinks + person.numberOfServings;
        }
        NSInteger remainingDrinks = 2013 - totalDrinks;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.text = [NSString stringWithFormat:@"%i down. %i to go.", totalDrinks, remainingDrinks];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat progressWidth = cell.bounds.size.width - 20;
        CGFloat progressHeight = cell.bounds.size.height;
        CGFloat originX = cell.bounds.origin.x + 10;
        CGFloat originY = cell.bounds.origin.y;
        
        UIView *progressBar = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, progressWidth, progressHeight)];
        
        [cell addSubview:progressBar];
        
        CGFloat doneWidth = (progressWidth - 30) / 2013 * totalDrinks ;
        UIView *done = [[UIView alloc] initWithFrame:CGRectMake(0, 0, doneWidth, progressHeight)];
        [done setBackgroundColor:[UIColor greenColor]];
        
        CGFloat remainingWidth = progressWidth - doneWidth;
        UIView *remaining = [[UIView alloc] initWithFrame:CGRectMake(doneWidth, 0, remainingWidth, progressHeight)];
        [remaining setBackgroundColor:[UIColor lightGrayColor]];
        [progressBar addSubview:done];
        [progressBar addSubview:remaining];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundView:progressBar];
    } else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSString *rank = [NSString stringWithFormat:@"%i", (indexPath.row + 1)];
        Person *person = (Person *)[self.rankings objectForKey:rank];

        cell.textLabel.text = [NSString stringWithFormat:@"%i. %@", (indexPath.row + 1), person.name];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", person.numberOfServings];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
