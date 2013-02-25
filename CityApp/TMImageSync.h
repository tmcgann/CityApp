//
//  TMImageSync.h
//  CityApp
//
//  Created by Taylor McGann on 2/24/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMImageFetcher.h"

@interface TMImageSync : NSObject <TMImageFetcherDelegate>

@property (nonatomic, strong) NSURL *remoteURL;
@property (nonatomic, strong) NSString *plistName;
@property (nonatomic, strong) NSDictionary *imageTimestamps;
@property (nonatomic, strong) NSURL *imagesDir;
@property (nonatomic, strong) NSURL *plistDir;

+ (TMImageSync *)sharedSync;
+ (NSDictionary *)imageTimestampsFromPlist:(NSString *)plistName;
+ (void)writeImageTimestampsToPlist:(NSString *)plistName;
- (void)syncImage:(NSString *)imagePath withTimestamp:(NSDate *)mostRecentTimestamp;
- (BOOL)imageExistsAtPath:(NSString *)imagePath;
- (BOOL)imageExists:(NSString *)imagePath withTimestamp:(NSDate *)mostRecentTimestamp;
- (NSDictionary *)imageTimestamps;
- (NSURL *)cachesDirectory;
- (NSURL *)applicationSupportDirectory;

@end
