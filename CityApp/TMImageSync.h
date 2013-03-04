//
//  TMImageSync.h
//  CityApp
//
//  Created by Taylor McGann on 2/24/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import <Foundation/Foundation.h>
#import "TMImageFetcher.h"

@interface TMImageSync : NSObject <TMImageFetcherDelegate>

@property (nonatomic, strong) NSURL *remoteURL;
@property (nonatomic, strong) NSString *imagePlistName;
@property (nonatomic, readonly) NSURL *imagePlistURL;
@property (nonatomic, strong) NSMutableDictionary *imageTimestamps;
@property (nonatomic, strong) NSURL *imagesDir;
@property (nonatomic, readonly) BOOL newImageTimestampsExist;
@property (nonatomic) BOOL debug;

+ (TMImageSync *)sharedSync;
- (void)syncImage:(NSString *)imagePath withTimestamp:(NSDate *)mostRecentTimestamp;
- (BOOL)imageExistsAtPath:(NSString *)imagePath;
- (BOOL)imageExists:(NSString *)imagePath withTimestamp:(NSDate *)mostRecentTimestamp;
- (void)writeImageTimestamps;
- (NSURL *)cachesDirectory;
- (NSURL *)applicationSupportDirectory;

@end
