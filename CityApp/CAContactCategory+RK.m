//
//  CAContactCategory+RK.m
//  CityApp
//
//  Created by Taylor McGann on 2/10/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAContactCategory+RK.h"

@implementation CAContactCategory (RK)

static RKEntityMapping *mapping;

+ (RKEntityMapping *)mapping:(RKManagedObjectStore *)managedObjectStore {
    // Setup the object mapping for API requests.
    if (!mapping) {
        mapping = [RKEntityMapping mappingForEntityForName:@"CAContactCategory" inManagedObjectStore:managedObjectStore];
        [mapping addAttributeMappingsFromDictionary:@{
         @"id" : @"contactCategoryId",
         @"name" : @"name",
         @"icon" : @"icon",
         @"description" : @"descriptor",
         @"rank" : @"rank",
         @"modified" : @"modified"
         }];
        mapping.identificationAttributes = @[ @"contactCategoryId" ];
    }
    
    return mapping;
}

@end
