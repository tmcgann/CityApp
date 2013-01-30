//
//  CAContactEntry.h
//  CityApp
//
//  Created by Taylor McGann on 1/25/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAContactEntry : NSObject

@property (strong, nonatomic) NSString *contactEntryId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *addressOne;
@property (strong, nonatomic) NSString *addressTwo;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *icon;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *fax;
@property (strong, nonatomic) NSString *hours;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *contactCategoryId;
@property (strong, nonatomic) NSDate *modified;


@end
