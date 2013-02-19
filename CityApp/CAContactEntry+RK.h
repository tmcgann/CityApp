//
//  CAContactEntry+RK.h
//  CityApp
//
//  Created by Taylor McGann on 2/10/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAContactEntry.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface CAContactEntry (RK)

+ (RKEntityMapping *)mapping:(RKManagedObjectStore *)managedObjectStore;

@end
