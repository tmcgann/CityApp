//
//  CAReportPicture.h
//  CityApp
//
//  Created by Taylor McGann on 3/19/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CAReportEntry;

@interface CAReportPicture : NSManagedObject

@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * reportPictureId;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) CAReportEntry *reportEntry;

@end
