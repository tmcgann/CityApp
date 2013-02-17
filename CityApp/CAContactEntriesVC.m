//
//  CAContactEntriesVC.m
//  CityApp
//
//  Created by Taylor McGann on 2/2/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAContactEntriesVC.h"
#import "CAContactEntryVC.h"
#import "CAContactEntry.h"

#define NUMBER_OF_SECTIONS 1;

@interface CAContactEntriesVC ()

@end

@implementation CAContactEntriesVC

@synthesize topView = _topView;
@synthesize tableView = _tableView;
@synthesize contactEntries = _contactEntries;
@synthesize contactCategoryName = _contactCategoryName;

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
    
    // Set title in nav bar to Contact Category name
    [self.navigationItem setTitle:self.contactCategoryName];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Deselect table view cell after return from segue
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if(indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToContactEntry"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CAContactEntryVC *contactEntryVC = segue.destinationViewController;
        CAContactEntry *ce = [self.contactEntries objectAtIndex:(NSUInteger)indexPath.row];
        contactEntryVC.contactEntry = ce;
        
        // Set back button title
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:self.contactCategoryName style:UIBarButtonItemStyleBordered target: nil action: nil];
        [self.navigationItem setBackBarButtonItem: backButton];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactEntries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    static NSString *CellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CAContactEntry *ce = [self.contactEntries objectAtIndex:(NSUInteger)indexPath.row];
    cell.textLabel.text = ce.name;
    
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
