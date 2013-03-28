//
//  CAReportCategoriesService.h
//  CityApp
//
//  Created by Taylor McGann on 3/7/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "CAObjectStore.h"
#import "CAReportCategory.h"

@interface CAReportCategoryService : NSObject

+ (CAReportCategoryService *)shared;
- (void)loadStore;
- (NSFetchRequest *)allReportCategories;
- (NSFetchRequest *)reportCategoryById:(NSString *)reportCategoryId;

@end
