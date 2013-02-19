//
//  CAContactEntry+RK.m
//  CityApp
//
//  Created by Taylor McGann on 2/10/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAContactEntry+RK.h"

@implementation CAContactEntry (RK)

static RKEntityMapping *mapping;

+ (RKEntityMapping *)mapping:(RKManagedObjectStore *)managedObjectStore {
    // Setup the object mapping for API requests.
    if (!mapping) {
        mapping = [RKEntityMapping mappingForEntityForName:@"CAContactEntry" inManagedObjectStore:managedObjectStore];
        [mapping addAttributeMappingsFromDictionary:@{
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
         @"description" : @"descriptor",
         @"fax" : @"fax",
         @"hours" : @"hours",
         @"url" : @"url",
         @"contact_category_id" : @"contactCategoryId",
         @"modified" : @"modified"
         }];
        mapping.identificationAttributes = @[ @"contactEntryId" ];
    }
    
    return mapping;
}

@end
