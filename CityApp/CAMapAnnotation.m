//
//  CAMapAnnotation.m
//  CityApp
//
//  Created by Taylor McGann on 4/1/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAMapAnnotation.h"

@interface CAMapAnnotation ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end

@implementation CAMapAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        self.coordinate = coord;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    
}

@end
