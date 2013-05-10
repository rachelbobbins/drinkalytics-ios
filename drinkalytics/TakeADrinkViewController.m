//
//  TakeADrinkViewController.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "TakeADrinkViewController.h"
#import "Drink.h"
#import "DrinkAppDelegate.h"
#import "DrinkPickerView.h"
#import "HTTPController.h"

@interface TakeADrinkViewController ()

@end

@implementation TakeADrinkViewController
//@synthesize managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        DrinkPickerView *typePickerView = [[DrinkPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self setTypePickerView:typePickerView];
   }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Have a drink";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self
                                                                                action:@selector(saveDrink)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)viewDidLayoutSubviews{
    NSString *displayedType = [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textLabel]text];
    if (![self.typePickerView.selectedDrinkType isEqualToString:displayedType]) {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)saveDrink
{
    [self.detailsField resignFirstResponder];
    NSString *displayedType = [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textLabel]text];
    if (![self.typePickerView.selectedDrinkType isEqualToString:displayedType]) {
        [self.tableView reloadData];
    }
    
    NSString *type = [[[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] textLabel]text];
    NSString *details = self.detailsField.text;

    HTTPController *httpController = [[HTTPController alloc] init];
    [httpController postDrinkWithType:type andDetails:details];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];        
        
    }
    
    if (indexPath.section == 0) {
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        NSString *drinkType = self.typePickerView.selectedDrinkType;
        cell.textLabel.text = drinkType;

    } else if (indexPath.section == 1) {
        self.detailsField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, cell.bounds.size.width, cell.bounds.size.height)];
        self.detailsField.placeholder = @"eg: vodka soda";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.detailsField];
        
        
    }

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Type";
        case 1:
            return @"Details";
        default:
            return @"";
    }
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self showPickerView];
}

- (void)showPickerView
{
    [self.detailsField resignFirstResponder];
    [self.view addSubview:self.typePickerView];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self showPickerView];
    }
}

@end
