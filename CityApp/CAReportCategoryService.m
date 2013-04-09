//
//  CAReportCategoriesService.m
//  CityApp
//
//  Created by Taylor McGann on 3/7/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAReportCategoryService.h"

#define PRIMARY_ENTITY_NAME @"CAReportCategory"
#define JSON_PATH @"/report_categories.json"
#define JSON_KEY_PATH @"report_categories"

@implementation CAReportCategoryService

+ (CAReportCategoryService *)shared
{
    static CAReportCategoryService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CAReportCategoryService alloc] init];
        [instance addMappings];
    });
    return instance;
}

- (void)addMappings {
    NSDictionary *reportCategoryDict = @{
        @"created" : @"created",
        @"deleted" : @"deleted",
        @"descriptor" : @"descriptor",
        @"id" : @"reportCategoryId",
        @"modified" : @"modified",
        @"name" : @"name",
        @"rank" : @"rank"
    };
    
    RKEntityMapping *reportCategoryMapping = [CAObjectStore.shared mappingForEntityForName:PRIMARY_ENTITY_NAME];
    [reportCategoryMapping addAttributeMappingsFromDictionary:reportCategoryDict];
    [reportCategoryMapping setIdentificationAttributes:@[@"reportCategoryId"]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:reportCategoryMapping pathPattern:JSON_PATH keyPath:JSON_KEY_PATH statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [CAObjectStore.shared addResponseDescriptor:responseDescriptor];
    
//    [CAObjectStore.shared syncWithFetchRequest:self.allReportCategories forPath:JSON_PATH];
}

// You can execute fetch requests right on the context
// OR you can make a fetched results controller and give it a fetch request
- (void)loadStore {
    [[CAObjectStore shared].objectManager getObjectsAtPath:JSON_PATH parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    } failure: ^(RKObjectRequestOperation * operation, NSError * error) {
        NSLog(@"FAILURE %@", error);
    }];
}

// Sort descriptor built in
- (NSFetchRequest *)allReportCategories {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:PRIMARY_ENTITY_NAME];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[nameDescriptor];
    return fetchRequest;
}

- (NSFetchRequest *)reportCategoryById:(NSString *)reportCategoryId
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:PRIMARY_ENTITY_NAME];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"reportCategoryId = %@", reportCategoryId];
    return fetchRequest;
}

@end
