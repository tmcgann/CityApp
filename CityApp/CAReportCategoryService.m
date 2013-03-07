//
//  CAReportCategoriesService.m
//  CityApp
//
//  Created by Taylor McGann on 3/7/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAReportCategoryService.h"

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
    RKEntityMapping *reportCategoryMapping = [CAObjectStore.shared mappingForEntityForName:@"CAReportCategory"];
    [reportCategoryMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"reportCategoryId",
     @"name" : @"name",
     @"icon" : @"icon",
     @"descriptor" : @"descriptor",
     @"rank" : @"rank",
     @"modified" : @"modified"
     }];
    [reportCategoryMapping setIdentificationAttributes:@[@"reportCategoryId"]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:reportCategoryMapping pathPattern:@"/report_categories.json" keyPath:@"report_categories" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [CAObjectStore.shared addResponseDescriptor:responseDescriptor];
    
    [CAObjectStore.shared syncWithFetchRequest:self.allReportCategories forPath:@"/report_categories.json"];
}

// You can execute fetch requests right on the context
// OR you can make a fetched results controller and give it a fetch request
- (void)loadStore {
    [[CAObjectStore shared].objectManager getObjectsAtPath:@"/report_categories.json" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    } failure: ^(RKObjectRequestOperation * operation, NSError * error) {
        NSLog(@"FAILURE %@", error);
    }];
}

// Sort descriptor built in
- (NSFetchRequest *)allReportCategories {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CAReportCategory"];
    NSSortDescriptor *rankDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[rankDescriptor, nameDescriptor];
    return fetchRequest;
}

@end
