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
#import "CAContactCategoriesService.h"
#import "CAObjectStore.h"

#define NUMBER_OF_SECTIONS 1;

@interface CAContactCategoriesTVC ()

@end

@implementation CAContactCategoriesTVC

@synthesize contactCategoriesDatabase = _contactCategoriesDatabase;
@synthesize contactCategories = _contactCategories;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[CAContactCategoriesService shared] loadStore];
    [self setupFetchedResultsController];
    
//    [self pullContactCategories];
    
    // Set the back button title
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:nil action:nil];
//    [self.navigationItem setBackBarButtonItem:backButton];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    if (!self.contactCategoriesDatabase) {
//        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//        url = [url URLByAppendingPathComponent:@"Default CA Database"];
//        self.contactCategoriesDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
//    }
//}

- (void)setContactCategoriesDatabase:(UIManagedDocument *)contactCategoriesDatabase
{
    if (_contactCategoriesDatabase != contactCategoriesDatabase) {
        _contactCategoriesDatabase = contactCategoriesDatabase;
        [self useDocument];
    }
}

- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.contactCategoriesDatabase.fileURL path]]) {
        [self.contactCategoriesDatabase saveToURL:self.contactCategoriesDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
            [self fetchContactDataIntoDocument:self.contactCategoriesDatabase];
        }];
    } else if (self.contactCategoriesDatabase.documentState == UIDocumentStateClosed) {
        [self.contactCategoriesDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.contactCategoriesDatabase.documentState == UIDocumentStateNormal) {
        [self setupFetchedResultsController];
    }
}

- (void)setupFetchedResultsController
{
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[[CAContactCategoriesService shared] allContactCategories] managedObjectContext:[CAObjectStore shared].context sectionNameKeyPath:nil cacheName:nil];
}

- (void)fetchContactDataIntoDocument:(UIManagedDocument *)document
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Directory Fetcher", NULL);
    dispatch_async(fetchQ, ^{
        
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToContactEntries"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CAContactEntriesVC *contactEntriesVC = segue.destinationViewController;
//        CAContactCategory *cc = [self.contactCategories objectAtIndex:(NSUInteger)indexPath.row];
        CAContactCategory *cc = [self.fetchedResultsController objectAtIndexPath:indexPath];
        contactEntriesVC.contactEntries = cc.contactEntries;
        contactEntriesVC.contactCategory = cc.name;
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    CAContactCategory *cc = [self.contactCategories objectAtIndex:(NSUInteger)indexPath.row];
    CAContactCategory *cc = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = cc.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *cellIdentifier = [tableView cellForRowAtIndexPath:indexPath].reuseIdentifier;
//    
//    if ([cellIdentifier isEqualToString:@"CategoryCell"]) {
//        [self performSegueWithIdentifier:@"pushToContactEntries" sender:self];
//    }
//    
//    // Must do this last so that prepareForSegue:sender: can access indexPath
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
