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
#import "TMImageSync.h"
#import "CASettings.h"

#define NUMBER_OF_SECTIONS 1;

@interface CAContactEntriesVC ()

@end

@implementation CAContactEntriesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:GLOBAL_BACKGROUND_IMAGE]];
    
    // Set title in nav bar to Contact Category name
    [self.navigationItem setTitle:self.contactCategory.name];
    
    // Load icon and description
    NSArray *iconComponents = [self.contactCategory.icon componentsSeparatedByString:@"."];
    if (iconComponents.count == 2) {
        NSURL *imageURL = [[TMImageSync sharedSync].imagesDir URLByAppendingPathComponent:self.contactCategory.icon];
        UIImage *image = [UIImage imageWithContentsOfFile:imageURL.path];
        self.contactCategoryIcon.image = image;
    }
    self.contactCategoryDescription.text = self.contactCategory.descriptor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Deselect table view cell after return from segue
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if(indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"pushToContactEntry"]) {
        CAContactEntryVC *contactEntryVC = segue.destinationViewController;
        CAContactEntry *ce = [self.contactCategory.contactEntries objectAtIndex:(NSUInteger)indexPath.row];
        contactEntryVC.contactEntry = ce;
        
        // Set back button title
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:self.contactCategory.name style:UIBarButtonItemStyleBordered target: nil action: nil];
        [self.navigationItem setBackBarButtonItem:backButton];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactCategory.contactEntries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    static NSString *CellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CAContactEntry *ce = [self.contactCategory.contactEntries objectAtIndex:(NSUInteger)indexPath.row];
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
