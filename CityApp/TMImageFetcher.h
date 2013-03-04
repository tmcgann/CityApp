//
//  TMImageFetcher.h
//  CityApp
//
//  Created by Taylor McGann on 2/23/13.
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
