//
//  TMImageSync.m
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

#import "TMImageSync.h"

@interface TMImageSync()
@property (nonatomic, readwrite) NSURL *imagePlistURL;
@property (nonatomic, readwrite) BOOL newImageTimestampsExist;
@end

@implementation TMImageSync
@synthesize imagePlistName = _imagePlistName;
@synthesize imageTimestamps = _imageTimestamps;

#pragma mark - Class Methods

+ (TMImageSync *)sharedSync {
    static TMImageSync *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TMImageSync alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Instance Methods

- (id)init
{
    self = [super init];
    if (self) {
        // TODO: Eventually we want to move all thread dispatching inside of the ImageSync
        //queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //group = dispatch_group_create();
        self.newImageTimestampsExist = NO;
    }
    return self;
}

- (void)syncImage:(NSString *)imagePath withTimestamp:(NSDate *)mostRecentTimestamp {
    // Check to see if image exists at path
    if ([self imageExistsAtPath:imagePath]) {
        // Check to see if current image is up-to-date
        // If image is up-to-date, do nothing
        if (![self imageExists:imagePath withTimestamp:mostRecentTimestamp]) {
            // Download newest image
            [self fetchImage:imagePath];
            
            // Add timestamp to dictionary and set flag
            [self.imageTimestamps setValue:mostRecentTimestamp forKey:imagePath];
            self.newImageTimestampsExist = YES;
            
            NSLog(@"Downloaded image %@", imagePath);
        }
    } else {
        // Download image
        [self fetchImage:imagePath];
        
        // Add timestamp to dictionary and set flag
        [self.imageTimestamps setValue:mostRecentTimestamp forKey:imagePath];
        self.newImageTimestampsExist = YES;
        
        NSLog(@"Downloaded image %@", imagePath);
    }
}

- (BOOL)imageExistsAtPath:(NSString *)imagePath {
    // Construct path
    NSURL *potentialURL = [self.imagesDir URLByAppendingPathComponent:imagePath];
    
    // Validate path
    NSFileManager *sharedFM = [NSFileManager defaultManager];
    BOOL result = [sharedFM fileExistsAtPath:potentialURL.path];
    
    return result;
}

- (BOOL)imageExists:(NSString *)imagePath withTimestamp:(NSDate *)mostRecentTimestamp {
    // Compare most recent timestamp with image timestamp record (plist)
    NSDate *recordedTimestamp = [self.imageTimestamps valueForKey:imagePath];
    
    BOOL result = YES;
    if (![recordedTimestamp isEqualToDate:mostRecentTimestamp]) {
        result = NO;
    }
    
    return result;
}

- (void)writeImageTimestamps {
    // Check to see if newImagesExist before calling this method
    // It's not done here to give the developer more control
    [self.imageTimestamps writeToURL:self.imagePlistURL atomically:YES];
}

- (void)fetchImage:(NSString *)imagePath {
    // Setup image fetcher with self as delegate
    TMImageFetcher *fetcher = [[TMImageFetcher alloc] initWithRemoteURL:self.remoteURL];
    //fetcher.debug = YES;
    fetcher.delegate = self;
    [fetcher downloadImage:imagePath];
}

- (void)saveImage:(NSData *)imageData withName:(NSString *)imageName {
    NSURL *finalURL = [NSURL URLWithString:imageName relativeToURL:self.imagesDir];
    NSString *finalPath = finalURL.path;
    [imageData writeToFile:finalPath atomically:YES];
}

#pragma mark - Common Directory Methods

- (NSURL *)cachesDirectory {
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    NSArray* urls = [sharedFM URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    NSURL *cachesDir = nil;
    
    if ([urls count] >= 1) {
        // Use the lastObject - There's probably only one
        cachesDir = [urls lastObject];
    }
    
    // Add app id to caches path--standard protocol
    if (cachesDir) {
        NSString *appBundleID = [[NSBundle mainBundle] bundleIdentifier];
        cachesDir = [cachesDir URLByAppendingPathComponent:appBundleID];
        
        #warning TODO: Appropriate error checking
        NSError *error;
        if (![sharedFM createDirectoryAtURL:cachesDir withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Error while creating directory '%@'", cachesDir.path);
            NSLog(@"ERROR: %@", error);
        }
    }
    
    return cachesDir;
}

- (NSURL *)applicationSupportDirectory {
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    NSArray* urls = [sharedFM URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    NSURL *appSupportDir = nil;
    
    if ([urls count] >= 1) {
        // Use the lastObject - There's probably only one
        appSupportDir = [urls lastObject];
    }
    
    // Add app bundle identifier to application support path--standard protocol
    if (appSupportDir) {
        NSString *appBundleID = [[NSBundle mainBundle] bundleIdentifier];
        NSArray *appBundleIdComponents = [appBundleID componentsSeparatedByString:@"."];
        appSupportDir = [appSupportDir URLByAppendingPathComponent:[appBundleIdComponents lastObject]];
        
        #warning TODO: Appropriate error checking
        NSError *error;
        if (![sharedFM createDirectoryAtURL:appSupportDir withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Error while creating directory '%@'", appSupportDir.path);
            NSLog(@"ERROR: %@", error);
        }
    }
    
    return appSupportDir;
}

#pragma mark - Accessors

- (void)setImagePlistName:(NSString *)imagePlistName {
    _imagePlistName = imagePlistName;
    
    // Set the image plist URL based on the image plist name
    if (!self.imagePlistURL) {
        self.imagePlistURL = [[self applicationSupportDirectory] URLByAppendingPathComponent:imagePlistName];
    }
}

- (NSMutableDictionary *)imageTimestamps {
    // Check for plist name; this is essential to have first
    if (!self.imagePlistName) {
        if (self.debug) NSLog(@"ERROR: Plist name not found. Did you set the image plist name?");
        return nil;
    }
    
    if (!_imageTimestamps) {
        NSFileManager *sharedFM = [NSFileManager defaultManager];
        
        // Use the existing image plist to populate the dictionary
        if ([sharedFM fileExistsAtPath:self.imagePlistURL.path]) {
            _imageTimestamps = [NSMutableDictionary dictionaryWithContentsOfURL:self.imagePlistURL];
        } else {
            _imageTimestamps = [NSMutableDictionary dictionary];
        }
    }
    
    return _imageTimestamps;
}

- (void)setImageTimestamps:(NSMutableDictionary *)imageTimestamps {
    // Does not save timestamps to plist file; only a typical setter
    _imageTimestamps = imageTimestamps;
}

- (NSURL *)imagesDir {
    if (!_imagesDir) {
        _imagesDir = [self cachesDirectory];
    }
    
    return _imagesDir;
}

@end
