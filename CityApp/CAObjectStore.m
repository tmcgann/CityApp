//
//  CAObjectStore.m
//  CityApp
//
//  Created by Taylor McGann on 2/16/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAObjectStore.h"

@interface CAObjectStore()

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end

@implementation CAObjectStore

@synthesize managedObjectModel = _managedObjectModel;

#pragma mark - Accessors
// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CityApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

#pragma mark - Init

+ (CAObjectStore *)shared
{
    static CAObjectStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CAObjectStore alloc] init];
        [sharedInstance initObjectManager];
    });
    return sharedInstance;
}

- (void)initObjectManager {
    
    NSLog(@"ENDPOINT = %@", NSLocalizedString(@"SERVER_URL", nil));
    
    // Core Data Example
    // Initialize RestKIT
    self.objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:NSLocalizedString(@"SERVER_URL", nil)]];
    self.objectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:self.managedObjectModel];
    self.objectManager.managedObjectStore = self.objectStore;
    
    // Other Initialization (move this to app delegate)
    [self.objectStore createPersistentStoreCoordinator];
    
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"CityApp.sqlite"];
    NSError *error;
    NSPersistentStore *persistentStore = [self.objectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    NSAssert(persistentStore, @"Failed to add persistent store with error: %@", error);
    
    [self.objectStore createManagedObjectContexts];
    
    self.objectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:self.context];
}

#pragma mark - Data

// some demeters law, don't access the store and stuff, just add them here.
// See BookService for usage
- (RKEntityMapping *)mappingForEntityForName:(NSString *)entityName {
    return [RKEntityMapping mappingForEntityForName:entityName inManagedObjectStore:self.objectStore];
}

- (void)addResponseDescriptor:(RKResponseDescriptor *)descriptor {
    [self.objectManager addResponseDescriptor:descriptor];
}

- (void)syncWithFetchRequest:(NSFetchRequest *)request forPath:(NSString *)path {
    [self.objectManager addFetchRequestBlock:^(NSURL* url) {
        RKPathMatcher *matcher = [RKPathMatcher pathMatcherWithPattern:@"/books"];
        NSFetchRequest *matchingRequest = nil;
        BOOL match = [matcher matchesPath:[url relativePath] tokenizeQueryStrings:NO parsedArguments:nil];
        if (match) {
            matchingRequest = request;
        }
        return matchingRequest;
    }];
}

- (NSManagedObjectContext *)context {
    // the mainQueueManagedObjectContext is a child of this one, but it doesn't persist. I'm not exactly sure what it is for.
    // either way, we need to use this one if we want things to save
    return self.objectStore.persistentStoreManagedObjectContext;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.context;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
