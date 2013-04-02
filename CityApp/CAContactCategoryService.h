//
//  CAContactCategoriesService.h
//  CityApp
//
//  Created by Taylor McGann on 2/16/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "CAObjectStore.h"
#import "CAContactCategory.h"

@interface CAContactCategoryService : NSObject

+ (CAContactCategoryService*)shared;
- (void)loadStore;
- (NSFetchRequest*)allContactCategories;
//- (NSPredicate*)searchForText:(NSString*)text;
//- (NSPredicate*)filterByType:(BookFilter)filter;

@end
