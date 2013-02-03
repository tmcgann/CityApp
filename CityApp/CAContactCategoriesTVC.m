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

#define NUMBER_OF_SECTIONS 1;

@interface CAContactCategoriesTVC ()

@end

@implementation CAContactCategoriesTVC

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
    
    [self pullContactCategories];
    
    // Set the back button title
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:nil action:nil];
//    [self.navigationItem setBackBarButtonItem:backButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pullContactCategories
{
    // RestKit debug output
    //RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    // Object mappings
    RKObjectMapping *contactEntryMapping = [RKObjectMapping mappingForClass:[CAContactEntry class]];
    [contactEntryMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"contactEntryId",
     @"name" : @"name",
     @"phone_number" : @"phoneNumber",
     @"email" : @"email",
     @"address_one" : @"addressOne",
     @"address_two" : @"addressTwo",
     @"city" : @"city",
     @"state" : @"state",
     @"zip" : @"zip",
     @"type" : @"type",
     @"icon" : @"icon",
     @"description" : @"description",
     @"fax" : @"fax",
     @"hours" : @"hours",
     @"url" : @"url",
     @"contact_category_id" : @"contactCategoryId",
     @"modified" : @"modified"
     }];
    
    RKObjectMapping *contactCategoryMapping = [RKObjectMapping mappingForClass:[CAContactCategory class]];
    [contactCategoryMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"contactCategoryId",
     @"name" : @"name",
     @"icon" : @"icon",
     @"description" : @"description",
     @"rank" : @"rank",
     @"modified" : @"modified"
     }];
    
    [contactCategoryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contact_entries" toKeyPath:@"contactEntries" withMapping:contactEntryMapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:contactCategoryMapping pathPattern:nil keyPath:@"contact_categories" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    NSURL *URL = [NSURL URLWithString:@"http://taumu.com/contact_categories.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        RKLogInfo(@"Load collection of Contact Categories: %@", mappingResult.array);
        self.contactCategories = mappingResult.array;
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        RKLogError(@"Operation failed with error: %@", error);
    }];
    
    [objectRequestOperation start];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToContactEntries"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CAContactEntriesVC *contactEntriesVC = segue.destinationViewController;
        CAContactCategory *cc = [self.contactCategories objectAtIndex:(NSUInteger)indexPath.row];
        contactEntriesVC.contactEntries = cc.contactEntries;
        contactEntriesVC.contactCategory = cc.name;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contactCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    static NSString *CellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CAContactCategory *cc = [self.contactCategories objectAtIndex:(NSUInteger)indexPath.row];
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
