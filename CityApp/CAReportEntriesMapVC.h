//
//  CAReportEntriesMapVC.h
//  CityApp
//
//  Created by Taylor McGann on 3/18/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CAReportEntriesMapVC : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
