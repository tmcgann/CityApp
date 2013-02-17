//
//  CAContactEntryVC.m
//  CityApp
//
//  Created by Taylor McGann on 2/3/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAContactEntryVC.h"

#define kTV_CELL_TITLE @"title"
#define kTV_CELL_DETAIL @"detail"

@interface CAContactEntryVC ()

@property (strong, nonatomic) NSMutableArray *tableSections;

@end

@implementation CAContactEntryVC

@synthesize contactEntry = _contactEntry;
@synthesize contactNameLabel = _contactNameLabel;
@synthesize tableSections = _tableSections;

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
    
    // Set navbar title
    [self.navigationItem setTitle:@"Details"];
    
    // Set contact name label in view
    self.contactNameLabel.text = self.contactEntry.name;
    
    // initialize mutable array
    self.tableSections = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self.contactEntry.phoneNumber isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"Phone", kTV_CELL_DETAIL:self.contactEntry.phoneNumber}];
    }
    if (![self.contactEntry.fax isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"Fax", kTV_CELL_DETAIL:self.contactEntry.fax}];
    }
    if (![self.contactEntry.email isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"Email", kTV_CELL_DETAIL:self.contactEntry.email}];
    }
    if (![self.contactEntry.addressOne isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"Address", kTV_CELL_DETAIL:self.contactEntry.addressOne}];
    }
    if (![self.contactEntry.url isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"URL", kTV_CELL_DETAIL:self.contactEntry.url}];
    }
    if (![self.contactEntry.hours isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"Hours", kTV_CELL_DETAIL:self.contactEntry.hours}];
    }
    if (![self.contactEntry.description isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"Description", kTV_CELL_DETAIL:self.contactEntry.descriptor}];
    }
    
    return self.tableSections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    static NSString *CellIdentifier = @"ContactDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *contactDetailMap = [self.tableSections objectAtIndex:(NSUInteger)indexPath.row];
    cell.textLabel.text = [contactDetailMap objectForKey:kTV_CELL_TITLE];
    cell.detailTextLabel.text = [contactDetailMap objectForKey:kTV_CELL_DETAIL];
    
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
