//
//  CAContactCategory+RK.h
//  CityApp
//
//  Created by Taylor McGann on 2/10/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAContactCategory.h"
#import <RestKit/RestKit.h>

@interface CAContactCategory (RK)

+ (RKEntityMapping *)mapping:(RKManagedObjectStore *)managedObjectStore;

@end
