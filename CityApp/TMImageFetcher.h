//
//  TMImageFetcher.h
//  CityApp
//
//  Created by Taylor McGann on 2/23/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TMImageFetcherDelegate <NSObject>
@required
- (void)saveImage:(NSData *)imageData withName:(NSString *)imageName;
@end

@interface TMImageFetcher : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong) id<TMImageFetcherDelegate> delegate;
@property (nonatomic, strong) NSURL *remoteURL;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@property (nonatomic) BOOL debug;

- (id)initWithRemoteURL:(NSURL *)remoteURL;
- (void)downloadImage:(NSString *)imageName;
- (void)cancelDownload;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
