//
//  CAReportCategory.h
//  CityApp
//
//  Created by Taylor McGann on 3/22/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CAReportEntry;

@interface CAReportCategory : NSManagedObject

@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSString * descriptor;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSString * reportCategoryId;
@property (nonatomic, retain) NSOrderedSet *reportEntries;
@end

@interface CAReportCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(CAReportEntry *)value inReportEntriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromReportEntriesAtIndex:(NSUInteger)idx;
- (void)insertReportEntries:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeReportEntriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInReportEntriesAtIndex:(NSUInteger)idx withObject:(CAReportEntry *)value;
- (void)replaceReportEntriesAtIndexes:(NSIndexSet *)indexes withReportEntries:(NSArray *)values;
- (void)addReportEntriesObject:(CAReportEntry *)value;
- (void)removeReportEntriesObject:(CAReportEntry *)value;
- (void)addReportEntries:(NSOrderedSet *)values;
- (void)removeReportEntries:(NSOrderedSet *)values;
@end
