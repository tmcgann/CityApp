//
//  CAReportPictureService.m
//  CityApp
//
//  Created by Taylor McGann on 3/23/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAReportPictureService.h"

#define PRIMARY_ENTITY_NAME @"CAReportPicture"
#define JSON_PATH @"/report_pictures.json"
#define JSON_KEY_PATH @"report_pictures"

@implementation CAReportPictureService

+ (CAReportPictureService *)shared
{
    static CAReportPictureService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CAReportPictureService alloc] init];
        [instance addMappings];
    });
    return instance;
}

- (void)addMappings
{
    RKEntityMapping *reportPictureMapping = [CAObjectStore.shared mappingForEntityForName:@"CAReportPicture"];
    [reportPictureMapping addAttributeMappingsFromDictionary:@{
     @"created" : @"created",
     @"filename" : @"filename",
     @"id" : @"reportPictureId"
     }];
    [reportPictureMapping setIdentificationAttributes:@[@"reportPictureId"]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:reportPictureMapping pathPattern:JSON_PATH keyPath:JSON_KEY_PATH statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [CAObjectStore.shared addResponseDescriptor:responseDescriptor];
    
    //    [CAObjectStore.shared syncWithFetchRequest:self.allReportPictures forPath:JSON_PATH];
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
- (NSFetchRequest *)allReportPictures
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:PRIMARY_ENTITY_NAME];
    NSSortDescriptor *createdDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO];
    fetchRequest.sortDescriptors = @[createdDescriptor];
    return fetchRequest;
}

- (NSFetchRequest *)reportPicturesForReportEntry:(CAReportEntry *)reportEntry
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:PRIMARY_ENTITY_NAME];
    NSSortDescriptor *createdDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO];
    fetchRequest.sortDescriptors = @[createdDescriptor];
    fetchRequest.predicate = [self filterByReportEntry:reportEntry];
    return fetchRequest;
}

- (NSPredicate *)filterByReportEntry:(CAReportEntry *)reportEntry
{
    return [NSPredicate predicateWithFormat:@"reportEntry == $reportEntry", reportEntry];
}

@end

