//
//  CAContactCategory.h
//  CityApp
//
//  Created by Taylor McGann on 2/16/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CAContactEntry;

@interface CAContactCategory : NSManagedObject

@property (nonatomic, retain) NSString * contactCategoryId;
@property (nonatomic, retain) NSString * descriptor;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSOrderedSet *contactEntries;
@end

@interface CAContactCategory (CoreDataGeneratedAccessors)

- (void)insertObject:(CAContactEntry *)value inContactEntriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromContactEntriesAtIndex:(NSUInteger)idx;
- (void)insertContactEntries:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeContactEntriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInContactEntriesAtIndex:(NSUInteger)idx withObject:(CAContactEntry *)value;
- (void)replaceContactEntriesAtIndexes:(NSIndexSet *)indexes withContactEntries:(NSArray *)values;
- (void)addContactEntriesObject:(CAContactEntry *)value;
- (void)removeContactEntriesObject:(CAContactEntry *)value;
- (void)addContactEntries:(NSOrderedSet *)values;
- (void)removeContactEntries:(NSOrderedSet *)values;
@end
