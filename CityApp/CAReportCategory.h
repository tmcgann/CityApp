//
//  CAReportCategory.h
//  CityApp
//
//  Created by Taylor McGann on 3/7/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CAReportEntry;

@interface CAReportCategory : NSManagedObject

@property (nonatomic, retain) NSString * reportCategoryId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * descriptor;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSSet *reportEntries;
@end

@interface CAReportCategory (CoreDataGeneratedAccessors)

- (void)addReportEntriesObject:(CAReportEntry *)value;
- (void)removeReportEntriesObject:(CAReportEntry *)value;
- (void)addReportEntries:(NSSet *)values;
- (void)removeReportEntries:(NSSet *)values;

@end
