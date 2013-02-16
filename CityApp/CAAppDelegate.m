//

//  CPAppDelegate.m
//  CityApp
//
//  Created by Taylor McGann on 1/14/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAAppDelegate.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "CAModels.h"

@implementation CAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // RestKit debug output
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);

    // setup object manager
    NSURL *baseURL = [NSURL URLWithString:NSLocalizedString(@"SERVER_URL", nil)];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
//    [[RKObjectManager sharedManager] setAcceptHeaderWithMIMEType:RKMIMETypeJSON];
//    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];    // Serialize to JSON
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CityApp" ofType:@"momd"]];
    // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    NSError *error;
    [managedObjectStore addSQLitePersistentStoreAtPath:[RKApplicationDataDirectory() stringByAppendingPathComponent:@"CityApp.sqlite"] fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
//    [objectManager.managedObjectStore createManagedObjectContexts];
    
    RKEntityMapping *contactCategoryMapping = [CAContactCategory mapping:managedObjectStore];
    RKEntityMapping *contactEntryMapping = [CAContactEntry mapping:managedObjectStore];
    
//    [contactCategoryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contact_entries" toKeyPath:@"contactEntries" withMapping:contactEntryMapping]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:contactCategoryMapping pathPattern:nil keyPath:@"contact_categories" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [objectManager addResponseDescriptorsFromArray:@[responseDescriptor]];
        
    __block NSOrderedSet *results = [[NSOrderedSet alloc] init];
    
    [objectManager getObjectsAtPath:@"/contact_categories.json" parameters:nil success:^(RKObjectRequestOperation * operation, RKMappingResult *mappingResult) {
        RKLogInfo(@"Load collection of Contact Categories: %@", mappingResult.array);
        results = [NSOrderedSet orderedSetWithArray:mappingResult.array];
    } failure: ^(RKObjectRequestOperation * operation, NSError * error) {
        NSLog(@"FAILURE %@", error);
    }];
    
//    NSURL *URL = [NSURL URLWithString:@"http://taumu.com/contact_categories.json"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    RKManagedObjectRequestOperation *managedObjectRequestOperation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
//    [managedObjectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        RKLogInfo(@"Load collection of Contact Categories: %@", mappingResult.array);
//        results = [NSOrderedSet orderedSetWithArray:mappingResult.array];
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        RKLogError(@"Operation failed with error: %@", error);
//    }];
//    
//    [managedObjectRequestOperation start];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
