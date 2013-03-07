//
//  CAReportEntry.h
//  CityApp
//
//  Created by Taylor McGann on 3/7/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CAReportCategory;

@interface CAReportEntry : NSManagedObject

@property (nonatomic, retain) NSString * reportEntryId;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * descriptor;
@property (nonatomic, retain) NSString * phoneUdid;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * contactPhone;
@property (nonatomic, retain) NSString * contactEmail;
@property (nonatomic, retain) NSNumber * exposed;
@property (nonatomic, retain) CAReportCategory *reportCategory;

@end
