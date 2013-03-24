//
//  CAReportEntryService.m
//  CityApp
//
//  Created by Taylor McGann on 3/7/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAReportEntryService.h"

#define PRIMARY_ENTITY_NAME @"CAReportEntry"
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

- (void)addMappings
{
    RKEntityMapping *reportEntryMapping = [CAObjectStore.shared mappingForEntityForName:PRIMARY_ENTITY_NAME];
    [reportEntryMapping addAttributeMappingsFromDictionary:@{
     @"address" : @"address",
     @"contact_email" : @"contactEmail",
     @"contact_name" : @"contactName",
     @"contact_phone" : @"contactPhone",
     @"created" : @"created",
     @"deleted" : @"deleted",
     @"descriptor" : @"descriptor",
     @"exposed" : @"exposed",
     @"id" : @"reportEntryId",
     @"latitude" : @"latitude",
     @"longitude" : @"longitude",
     @"modified" : @"modified",
     @"phone_udid" : @"phoneUdid",
     @"thumbnail_data" : @"thumbnailData"
     }];
    [reportEntryMapping setIdentificationAttributes:@[@"reportEntryId"]];
    
//    RKEntityMapping *reportPictureMapping = [CAObjectStore.shared mappingForEntityForName:@"CAReportPicture"];
//    [reportPictureMapping addAttributeMappingsFromDictionary:@{
//     @"created" : @"created",
//     @"filename" : @"filename",
//     @"id" : @"reportPictureId"
//     }];
//    [reportPictureMapping setIdentificationAttributes:@[@"reportPictureId"]];
    
//    [reportEntryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"report_pictures" toKeyPath:@"reportPictures" withMapping:reportPictureMapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:reportEntryMapping pathPattern:JSON_PATH keyPath:JSON_KEY_PATH statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [CAObjectStore.shared addResponseDescriptor:responseDescriptor];
    
    //    [CAObjectStore.shared syncWithFetchRequest:self.allReportEntries forPath:JSON_PATH];
}

// You can execute fetch requests right on the context
// OR you can make a fetched results controller and give it a fetch request
- (void)loadStore
{
    [[CAObjectStore shared].objectManager getObjectsAtPath:JSON_PATH parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    } failure: ^(RKObjectRequestOperation * operation, NSError * error) {
        NSLog(@"FAILURE %@", error);
    }];
}

// Sort descriptor built in
- (NSFetchRequest *)allReportEntries
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:PRIMARY_ENTITY_NAME];
    NSSortDescriptor *createdDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO];
    fetchRequest.sortDescriptors = @[createdDescriptor];
    return fetchRequest;
}


@end
