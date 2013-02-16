//
//  CAContactEntry.h
//  CityApp
//
//  Created by Taylor McGann on 2/10/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CAContactCategory;

@interface CAContactEntry : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * addressOne;
@property (nonatomic, retain) NSString * addressTwo;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * hours;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSString * descriptor;
@property (nonatomic, retain) NSString * contactEntryId;
@property (nonatomic, retain) NSString * contactCategoryId;
@property (nonatomic, retain) CAContactCategory *contactCategory;

@end
