//
//  CAReportEntry.h
//  CityApp
//
//  Created by Taylor McGann on 3/22/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CAReportCategory, CAReportPicture;

@interface CAReportEntry : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * contactEmail;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * contactPhone;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * descriptor;
@property (nonatomic, retain) NSNumber * exposed;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * phoneUdid;
@property (nonatomic, retain) NSString * reportEntryId;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) CAReportCategory *reportCategory;
@property (nonatomic, retain) NSOrderedSet *reportPictures;
@end

@interface CAReportEntry (CoreDataGeneratedAccessors)

- (void)insertObject:(CAReportPicture *)value inReportPicturesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromReportPicturesAtIndex:(NSUInteger)idx;
- (void)insertReportPictures:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeReportPicturesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInReportPicturesAtIndex:(NSUInteger)idx withObject:(CAReportPicture *)value;
- (void)replaceReportPicturesAtIndexes:(NSIndexSet *)indexes withReportPictures:(NSArray *)values;
- (void)addReportPicturesObject:(CAReportPicture *)value;
- (void)removeReportPicturesObject:(CAReportPicture *)value;
- (void)addReportPictures:(NSOrderedSet *)values;
- (void)removeReportPictures:(NSOrderedSet *)values;
@end
