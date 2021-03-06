//
//  CPDirectoryTVC.m
//  CityApp
//
//  Created by Taylor McGann on 1/20/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAContactCategoriesTVC.h"
#import <RestKit/RestKit.h>
#import "CAContactCategory.h"
#import "CAContactEntry.h"
#import "CAContactEntriesVC.h"
#import "CAContactCategoryService.h"
#import "CAObjectStore.h"
#import "TMImageSync.h"
#import "CASettings.h"

@interface CAContactCategoriesTVC ()

@end

@implementation CAContactCategoriesTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background image
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:GLOBAL_BACKGROUND_IMAGE]];
    
    // Load objects via Core Data/RestKit
    [[CAContactCategoryService shared] loadStore];
    [self setupFetchedResultsController];
    
    // Load images for all the contact categories (not the contact entries)
#warning FIXME: This doesn't work the first time the app loads. It is data dependent.
    [self syncIcons];
}

- (void)setupFetchedResultsController
{
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[[CAContactCategoryService shared] allContactCategories] managedObjectContext:[CAObjectStore shared].context sectionNameKeyPath:nil cacheName:nil];
}

#define IMAGE_PLIST_FILENAME @"ContactCategoryIconTimestamp.plist"

- (void)syncIcons {
    TMImageSync *sharedSync = [TMImageSync sharedSync];
    sharedSync.remoteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, IMAGE_CONTROLLER_PATH]];
    sharedSync.imagePlistName = IMAGE_PLIST_FILENAME;
    
    // Set up asynchronous dispatch group
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (CAContactCategory *cc in self.fetchedResultsController.fetchedObjects) {
        //NSLog(@"cc.icon: %@", cc.icon);
        if (![cc.icon isEqualToString:@""]) {
            // Add a task to the group
            dispatch_group_async(group, queue, ^{
               [sharedSync syncImage:cc.icon withTimestamp:cc.modified]; // As of now, just checking to see if parent was modified
            });
        }
    }
    
    // Cannot make any more forward progress until threads finish
    // wait on the group to block the current thread.
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    // Update image timestamp record (plist)
    if (sharedSync.newImageTimestampsExist) {
        [sharedSync writeImageTimestamps];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToContactEntries"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CAContactEntriesVC *contactEntriesVC = segue.destinationViewController;
        contactEntriesVC.contactCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    static NSString *CellIdentifier = @"ContactCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    CAContactCategory *cc = [self.contactCategories objectAtIndex:(NSUInteger)indexPath.row];
    CAContactCategory *cc = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = cc.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
