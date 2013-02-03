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
//    // RestKit debug output
//    //RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
//    //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
//    
//    // setup base url
//    NSURL *baseURL = [NSURL URLWithString:NSLocalizedString(@"SERVER_URL", nil)];
//    
//    // object manager
//    RKObjectManager* objectManager = [RKObjectManager managerWithBaseURL:baseURL];
//    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CityApp" ofType:@"momd"]];
//    // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
//    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
//    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
//    objectManager.managedObjectStore = managedObjectStore;
//    
//    // Object mappings
//    RKObjectMapping *contactEntryMapping = [RKObjectMapping mappingForClass:[CAContactEntry class]];
//    [contactEntryMapping addAttributeMappingsFromDictionary:@{
//         @"id" : @"contactEntryId",
//         @"name" : @"name",
//         @"phone_number" : @"phoneNumber",
//         @"email" : @"email",
//         @"address_one" : @"addressOne",
//         @"address_two" : @"addressTwo",
//         @"city" : @"city",
//         @"state" : @"state",
//         @"zip" : @"zip",
//         @"type" : @"type",
//         @"icon" : @"icon",
//         @"description" : @"description",
//         @"fax" : @"fax",
//         @"hours" : @"hours",
//         @"url" : @"url",
//         @"contact_category_id" : @"contactCategoryId",
//         @"modified" : @"modified"
//     }];
//    
//    RKObjectMapping *contactCategoryMapping = [RKObjectMapping mappingForClass:[CAContactCategory class]];
//    [contactCategoryMapping addAttributeMappingsFromDictionary:@{
//         @"id" : @"contactCategoryId",
//         @"name" : @"name",
//         @"icon" : @"icon",
//         @"description" : @"description",
//         @"rank" : @"rank",
//         @"modified" : @"modified"
//     }];
//    
//    [contactCategoryMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"contact_entries" toKeyPath:@"contactEntries" withMapping:contactEntryMapping]];
//    
//    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:contactCategoryMapping pathPattern:nil keyPath:@"contact_categories" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//    
//    NSURL *URL = [NSURL URLWithString:@"http://taumu.com/contact_categories.json"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    RKObjectRequestOperation *objectRequestOperation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[ responseDescriptor ]];
//    [objectRequestOperation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        RKLogInfo(@"Load collection of Contact Categories: %@", mappingResult.array);
//    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//        RKLogError(@"Operation failed with error: %@", error);
//    }];
//    
//    [objectRequestOperation start];
    
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
