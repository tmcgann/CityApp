//
//  CAReportEntryService.m
//  CityApp
//
//  Created by Taylor McGann on 3/7/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAReportEntryService.h"
#import "CAReportEntry.h"

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
    NSDictionary *reportEntryDict = @{
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
        @"report_category_id" : @"reportCategoryId",
        @"thumbnail_data" : @"thumbnailData"
    };
    
    // RESPONSE MAPPING
    RKEntityMapping *reportEntryResponseMapping = [CAObjectStore.shared mappingForEntityForName:PRIMARY_ENTITY_NAME];
    [reportEntryResponseMapping addAttributeMappingsFromDictionary:reportEntryDict];
    [reportEntryResponseMapping setIdentificationAttributes:@[@"reportEntryId"]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:reportEntryResponseMapping pathPattern:JSON_PATH keyPath:JSON_KEY_PATH statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [[CAObjectStore shared] addResponseDescriptor:responseDescriptor];
    
    // REQUEST MAPPING
    RKEntityMapping *reportEntryRequestMapping = (RKEntityMapping *)[RKObjectMapping requestMapping];
    [reportEntryRequestMapping addAttributeMappingsFromDictionary:reportEntryDict];
    
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:reportEntryRequestMapping objectClass:[CAReportEntry class] rootKeyPath:@"report_entry"];
    
    [[CAObjectStore shared] addRequestDescriptor:requestDescriptor];
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

- (void)createEntry:(CAReportEntry *)reportEntry
{
    [[CAObjectStore shared].objectManager postObject:reportEntry path:@"/report_entries/add" parameters:nil success:nil failure:nil];
}

- (void)createEntry:(CAReportEntry *)reportEntry withPicture:(UIImage *)picture
{
//    [[CAObjectStore shared].objectManager postObject:reportEntry path:@"/report_entries/add" parameters:nil success:nil failure:nil];
    // Serialize the class attributes then attach a file
    NSMutableURLRequest *request = [[CAObjectStore shared].objectManager multipartFormRequestWithObject:reportEntry method:RKRequestMethodPOST path:@"/report_entries/add" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(picture, 0.8)
                                    name:@"reportEntry[picture]"
                                fileName:@"photo.jpeg"
                                mimeType:@"image/jpeg"];
    }];
    
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] objectRequestOperationWithRequest:request success:nil failure:nil];
    [[CAObjectStore shared].objectManager enqueueObjectRequestOperation:operation]; // NOTE: Must be enqueued rather than started
}


@end
