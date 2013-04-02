//
//  CAObjectStore.h
//  CityApp
//
//  Created by Taylor McGann on 2/16/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface CAObjectStore : NSObject

@property (strong, nonatomic) RKObjectManager *objectManager;
@property (strong, nonatomic) RKManagedObjectStore *objectStore;
@property (readonly, nonatomic) NSManagedObjectContext *context;

+ (CAObjectStore *)shared;
- (void)saveContext;

- (RKEntityMapping *)mappingForEntityForName:(NSString *)entityName;
- (id)insertNewObjectForEntityName:(NSString *)entityName;
- (void)addRequestDescriptor:(RKRequestDescriptor *)descriptor;
- (void)addResponseDescriptor:(RKResponseDescriptor *)descriptor;

// Simple way to sync objects whose urls have no parameters
// Will delete anything not matched
//- (void)syncWithFetchRequest:(NSFetchRequest *)request forPath:(NSString *)path;

@end


