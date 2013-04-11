//
//  CAMapAnnotation.h
//  CityApp
//
//  Created by Taylor McGann on 4/1/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CAReportEntry.h"

@interface CAMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
//@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) CAReportEntry *reportEntry;
@property (strong, nonatomic) NSData *thumbnailData;

// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;

// Called as a result of dragging an annotation view.
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
