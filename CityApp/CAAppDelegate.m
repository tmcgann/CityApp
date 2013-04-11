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
#import "CAServices.h"
#import "CASettings.h"

@implementation CAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // RestKit debug output
//    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    // Load object stores
    [[CAContactCategoryService shared] loadStore];
    [[CAReportCategoryService shared] loadStore];
    [[CAReportEntryService shared] loadStore];
    
    // Set navbar UI (iOS 5.0+)
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:GLOBAL_NAVBAR_IMAGE] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    }
    
    // Set toolbar UI (iOS 5.0+)
    if ([[UIToolbar class] respondsToSelector:@selector(appearance)]) {
        [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:GLOBAL_NAVBAR_IMAGE] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [[UIToolbar appearance] setBarStyle:UIBarStyleBlack];
    }
    
    // Set toolbar UI (iOS 5.0+)
    if ([[UIBarButtonItem class] respondsToSelector:@selector(appearance)]) {
        [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:84.0f/255.0f green:67.0f/255.0f blue:66.0f/255.0f alpha:100.0f/100.0f]];
    }
    
    // Set segmented control UI (iOS 5.0+)
    if ([[UISegmentedControl class] respondsToSelector:@selector(appearance)]) {
        [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:84.0f/255.0f green:67.0f/255.0f blue:66.0f/255.0f alpha:100.0f/100.0f]];
    }
    
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
