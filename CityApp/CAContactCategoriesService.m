//
//  CAContactCategoriesService.m
//  CityApp
//
//  Created by Taylor McGann on 2/16/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAContactCategoriesService.h"
#import <RestKit/RestKit.h>
#import "CAObjectStore.h"

@implementation CAContactCategoriesService

+ (CAContactCategoriesService *)shared
{
    static CAContactCategoriesService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CAContactCategoriesService alloc] init];
        [instance addMappings];
    });
    return instance;
}

- (void)addMappings {
    RKEntityMapping *contactCategoryMapping = [CAObjectStore.shared mappingForEntityForName:@"CAContactCategory"];
    [contactCategoryMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"contactCategoryId",
     @"name" : @"name",
     @"icon" : @"icon",
     @"descriptor" : @"descriptor",
     @"rank" : @"rank",
     @"modified" : @"modified"
     }];
    [contactCategoryMapping setIdentificationAttributes:@[@"contactCategoryId"]];
    
    RKEntityMapping *contactEntryMapping = [CAObjectStore.shared mappingForEntityForName:@"CAContactEntry"];
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
     @"descriptor" : @"descriptor",
     @"fax" : @"fax",
     @"hours" : @"hours",
     @"url" : @"url",
     @"contact_category_id" : @"contactCategoryId",
     @"modified" : @"modified"
     }];
    contactEntryMapping.identificationAttributes = @[ @"contactEntryId" ];
    
    [contactCategoryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contact_entries" toKeyPath:@"contactEntries" withMapping:contactEntryMapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:contactCategoryMapping pathPattern:@"/contact_categories.json" keyPath:@"contact_categories" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [CAObjectStore.shared addResponseDescriptor:responseDescriptor];
    
    [CAObjectStore.shared syncWithFetchRequest:self.allContactCategories forPath:@"/contact_categories.json"];
}

// You can execute fetch requests right on the context
// OR you can make a fetched results controller and give it a fetch request
- (void)loadStore {
    [[CAObjectStore shared].objectManager getObjectsAtPath:@"/contact_categories.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    } failure: ^(RKObjectRequestOperation * operation, NSError * error) {
        NSLog(@"FAILURE %@", error);
    }];
}

// Sort descriptor built in
- (NSFetchRequest *)allContactCategories {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CAContactCategory"];
    NSSortDescriptor *rankDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[rankDescriptor, nameDescriptor];
    return fetchRequest;
}

//- (NSPredicate *)searchForText:(NSString*)text {
//    return [NSPredicate predicateWithFormat:@"title BEGINSWITH[c] %@", [text lowercaseString]];
//}

//-(NSPredicate*)filterByType:(BookFilter)filter {
//    if (filter == BookFilterHasAudio) return [NSPredicate predicateWithFormat:@"audioFiles > 0"];
//    else if (filter == BookFilterHasText) return [NSPredicate predicateWithFormat:@"textFiles > 0"];
//    else return nil;
//}

@end
