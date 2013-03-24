//
//  CAImageValueTransformer.m
//  CityApp
//
//  Created by Taylor McGann on 3/23/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAImageValueTransformer.h"
#import "NSData+Base64.h"

@implementation CAImageValueTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    if (value == nil)
        return nil;
    
    // I pass in raw data when generating the image, save that directly to the database
    if ([value isKindOfClass:[NSData class]])
        return value;
    
    return UIImageJPEGRepresentation((UIImage *)value, 1.0);
}

- (id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:(NSData *)value];
}

@end
