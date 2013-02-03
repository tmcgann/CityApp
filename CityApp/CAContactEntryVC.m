//
//  CAContactEntryVC.m
//  CityApp
//
//  Created by Taylor McGann on 2/3/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAContactEntryVC.h"

@interface CAContactEntryVC ()

@end

@implementation CAContactEntryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Details"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger i = 0;
    
    if (![self.contactEntry.name isEqualToString:@""]) {
        i++;
    }
    if (![self.contactEntry.phoneNumber isEqualToString:@""]) {
        i++;
    }
    if (![self.contactEntry.fax isEqualToString:@""]) {
        i++;
    }
    if (![self.contactEntry.email isEqualToString:@""]) {
        i++;
    }
    if (![self.contactEntry.addressOne isEqualToString:@""]) {
        i++;
    }
    if (![self.contactEntry.url isEqualToString:@""]) {
        i++;
    }
    if (![self.contactEntry.hours isEqualToString:@""]) {
        i++;
    }
    if (![self.contactEntry.description isEqualToString:@""]) {
        i++;
    }
    
    return i;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    NSString *CellIdentifier;
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        CellIdentifier = @"Name";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.detailTextLabel.text = self.contactEntry.phoneNumber;
    } else {
        CellIdentifier = @"PhoneNumber";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.detailTextLabel.text = self.contactEntry.phoneNumber;
    }
    
    return cell;
}

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
