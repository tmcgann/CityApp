//
//  CPDirectoryTVC.m
//  CityApp
//
//  Created by Taylor McGann on 1/20/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CADirectoryTVC.h"
#import <RestKit/RestKit.h>
#import "CAContactCategory.h"
#import "CAContactEntry.h"

#define NUMBER_OF_SECTIONS 1;

@interface CADirectoryTVC ()
@property NSArray *contactCategories;
@end

@implementation CADirectoryTVC

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

- (void)sortContactCategories
{
    
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
    static NSString *CellIdentifier = @"DirectoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CAContactCategory *cc = [self.contactCategories objectAtIndex:(NSUInteger)indexPath.row];
    cell.textLabel.text = cc.name;
    
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
