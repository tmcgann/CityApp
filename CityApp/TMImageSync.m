//
//  TMImageSync.m
//  CityApp
//
//  Created by Taylor McGann on 2/24/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "TMImageSync.h"

@interface TMImageSync() {
//    dispatch_queue_t queue;
//    dispatch_group_t group;
}
@end

@implementation TMImageSync

@synthesize imageTimestamps = _imageTimestamps;

#pragma mark - Accessors

- (NSMutableDictionary *)imageTimestamps {
    // Check for plist name
    if (!self.plistName) {
        NSLog(@"ERROR: Plist name not found. Did you setPlistName?");
        return nil;
    }
    
    if (!_imageTimestamps) {
        NSURL *imagePlistPath = [self.plistDir URLByAppendingPathComponent:self.plistName];
        NSFileManager *sharedFM = [NSFileManager defaultManager];
        
        if ([sharedFM fileExistsAtPath:imagePlistPath.path]) {
            _imageTimestamps = [_imageTimestamps initWithContentsOfURL:imagePlistPath];
        } else {
            _imageTimestamps = [NSMutableDictionary dictionary];
        }
    }
    
    return _imageTimestamps;
}

- (void)setImageTimestamps:(NSMutableDictionary *)imageTimestamps {
    // Does not save timestamps to plist file
    _imageTimestamps = imageTimestamps;
}

- (NSURL *)imagesDir {
    if (!_imagesDir) {
        _imagesDir = [self cachesDirectory];
    }
    
    return _imagesDir;
}

- (NSURL *)plistDir {
    if (!_plistDir) {
        _plistDir = [self applicationSupportDirectory];
    }
    
    return _plistDir;
}

#pragma mark - Class Methods

+ (TMImageSync *)sharedSync {
    static TMImageSync *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TMImageSync alloc] init];
    });
    return sharedInstance;
}

//+ (NSDictionary *)imageTimestampsFromPlist:(NSString *)plistName {
//    // Get the application support directory path
//    NSFileManager* sharedFM = [NSFileManager defaultManager];
//    NSArray* urls = [sharedFM URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
//    NSURL *appSupportDir = nil;
//    
//    if ([urls count] >= 1) {
//        // Use the lastObject - There's probably only one
//        appSupportDir = [urls lastObject];
//    }
//    
//    // Get the plist of image timestamps and convert it to a dictionary
//    NSDictionary *imageTimestamps = nil;
//    if (appSupportDir) {
//        NSURL *imagePlistPath = [appSupportDir URLByAppendingPathComponent:plistName];
//        NSFileManager *sharedFM = [NSFileManager defaultManager];
//        
//        if ([sharedFM fileExistsAtPath:imagePlistPath.path]) {
//            imageTimestamps = [imageTimestamps initWithContentsOfURL:imagePlistPath];
//        }
//    }
//    
//    return imageTimestamps;
//}
//
//+ (void)writeImageTimestampsToPlist:(NSString *)plistName {
//    
//}

#pragma mark - Instance Methods

- (id)init
{
    self = [super init];
    if (self) {
//        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        group = dispatch_group_create();
    }
    return self;
}

- (void)syncImage:(NSString *)imagePath withTimestamp:(NSDate *)mostRecentTimestamp {
    // Check to see if path exists (might not need to do this)
    // Check to see if image exists at path
    if ([self imageExistsAtPath:imagePath]) {
        // Check to see if current image is up-to-date
        // If image is up-to-date, do nothing
        if (![self imageExists:imagePath withTimestamp:mostRecentTimestamp]) {
            // Download newest image
            [self fetchImage:imagePath];
            
            // Add timestamp to dictionary
            [self.imageTimestamps setValue:mostRecentTimestamp forKey:imagePath];
        }
    } else {
        // Download image
        [self fetchImage:imagePath];
        
        // Add timestamp to dictionary
        [self.imageTimestamps setValue:mostRecentTimestamp forKey:imagePath];
    }
}

- (BOOL)imageExistsAtPath:(NSString *)imagePath {
    // Construct path
    NSURL *potentialPath = [self.imagesDir URLByAppendingPathComponent:imagePath];
    
    // Validate path
    NSFileManager *sharedFM = [NSFileManager defaultManager];
    BOOL result = [sharedFM fileExistsAtPath:potentialPath.path];
    
    return result;
}

- (BOOL)imageExists:(NSString *)imagePath withTimestamp:(NSDate *)mostRecentTimestamp {
    // Compare most recent timestamp with image timestamp record (plist)
    NSDate *recordedTimestamp = [self.imageTimestamps valueForKey:imagePath];
    
    BOOL result = NO;
    if ([recordedTimestamp isEqualToDate:mostRecentTimestamp]) {
        result = YES;
    }
    
    return result;
}

- (void)writeImageTimestamps {
    NSURL *url = [NSURL URLWithString:self.plistName relativeToURL:self.plistDir];
    [self.imageTimestamps writeToURL:url atomically:YES];
}

- (void)fetchImage:(NSString *)imagePath {
    // Setup image fetcher with self as delegate
    TMImageFetcher *fetcher = [[TMImageFetcher alloc] initWithRemoteURL:self.remoteURL];
    fetcher.debug = YES;
    fetcher.delegate = self;
    [fetcher downloadImage:imagePath];
}

- (void)saveImage:(NSData *)imageData withName:(NSString *)imageName {
    NSString *finalPath = [NSString stringWithFormat:@"%@%@", self.imagesDir.path, imageName];
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
    
    return appSupportDir;
}

@end
