//
//  CAContactCategory.h
//  CityApp
//
//  Created by Taylor McGann on 1/24/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface CAContactCategory : NSObject

@property (strong, nonatomic) NSString* contactCategoryId;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* icon;
@property (strong, nonatomic) NSString* description;
@property (strong, nonatomic) NSString* rank;
@property (strong, nonatomic) NSDate *modified;
@property (strong, nonatomic) NSArray *contactEntries;

@end
