//
//  CAContactCategory.m
//  CityApp
//
//  Created by Taylor McGann on 1/24/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAContactCategory.h"

@implementation CAContactCategory

@synthesize contactCategoryId = _contactCategoryId;
@synthesize name = _name;
@synthesize icon = _icon;
@synthesize description = _description;
@synthesize rank = _rank;
@synthesize modified = _modified;
@synthesize contactEntries = _contactEntries;

- (NSString *)description
{
    return self.contactCategoryId;
}

@end
