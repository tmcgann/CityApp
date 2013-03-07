//
//  CAReportEntryService.m
//  CityApp
//
//  Created by Taylor McGann on 3/7/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAReportEntryService.h"

#define ENTITY_NAME @"CAReportEntry"
#define JSON_PATH @"/report_entries.json"
#define JSON_KEY_PATH @"report_entries"

@implementation CAReportEntryService

+ (CAReportEntryService *)shared
{
    static CAReportEntryService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CAReportEntryService alloc] init];
        [instance addMappings];
    });
    return instance;
}

- (void)addMappings {
    RKEntityMapping *reportEntryMapping = [CAObjectStore.shared mappingForEntityForName:ENTITY_NAME];
    [reportEntryMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"reportEntryId",
     @"address" : @"address",
     @"contact_email" : @"contactEmail",
     @"contact_name" : @"contactName",
     @"contact_phone" : @"contactPhone",
     @"created" : @"created",
     @"descriptor" : @"descriptor",
     @"exposed" : @"exposed",
     @"latitude" : @"latitude",
     @"longitude" : @"longitude",
     @"phone_udid" : @"phoneUdid",
     @"modified" : @"modified"
     }];
    [reportEntryMapping setIdentificationAttributes:@[@"reportEntryId"]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:reportEntryMapping pathPattern:JSON_PATH keyPath:JSON_KEY_PATH statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [CAObjectStore.shared addResponseDescriptor:responseDescriptor];
    
    [CAObjectStore.shared syncWithFetchRequest:self.allReportEntries forPath:JSON_PATH];
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
- (NSFetchRequest *)allReportEntries {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
    NSSortDescriptor *rankDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[rankDescriptor, nameDescriptor];
    return fetchRequest;
}


@end
