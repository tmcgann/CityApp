//
//  CAReportPictureService.h
//  CityApp
//
//  Created by Taylor McGann on 3/23/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "CAObjectStore.h"
#import "CAReportEntry.h"

@interface CAReportPictureService : NSObject

+ (CAReportPictureService*)shared;
- (void)loadStore;
- (NSFetchRequest*)allReportPictures;

@end
