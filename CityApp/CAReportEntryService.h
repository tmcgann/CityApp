//
//  CAReportEntryService.h
//  CityApp
//
//  Created by Taylor McGann on 3/7/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "CAObjectStore.h"
#import "CAReportEntry.h"

@interface CAReportEntryService : NSObject

+ (CAReportEntryService*)shared;
- (void)loadStore;
- (NSFetchRequest*)allReportEntries;
- (void)createEntry:(CAReportEntry *)reportEntry;
- (void)createEntry:(CAReportEntry *)reportEntry withPicture:(UIImage *)picture;

@end
