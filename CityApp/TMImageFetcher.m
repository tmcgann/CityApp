//
//  TMImageFetcher.m
//  CityApp
//
//  Created by Taylor McGann on 2/23/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "TMImageFetcher.h"

@implementation TMImageFetcher

#pragma mark - Instance Methods

- (id)initWithRemoteURL:(NSURL *)remoteURL
{
    self = [super init];
    if (self) {
        self.remoteURL = remoteURL;
    }
    return self;
}

- (void)downloadImage:(NSString *)imageName
{
    self.activeDownload = [NSMutableData data];
    self.imageName = imageName;
    
    NSURL *url = [[NSURL alloc] initWithString:imageName relativeToURL:self.remoteURL];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30.0];
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    self.imageConnection = connection;
    NSError *error;
    NSData *imageData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        [self.delegate saveImage:imageData withName:imageName];
    }
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}

#pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (self.debug) {
        NSLog(@"[%@ %@] connection: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), connection);
        NSLog(@"[%@ %@] didReceiveResponse: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), response);
    }
    
    // Do something?!
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (self.debug) {
        NSLog(@"[%@ %@] connection: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), connection);
        NSLog(@"[%@ %@] didReceiveData: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), data);
    }
    
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.debug) {
        NSLog(@"[%@ %@] connection: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), connection);
        NSLog(@"[%@ %@] didFailWithError: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error);
    }
    
    // Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.debug) NSLog(@"[%@ %@] connectionDidFinishLoading: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), connection);
    
    // call our delegate and pass it the image data
    [self.delegate saveImage:self.activeDownload withName:self.imageName];
//    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    // Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

@end
