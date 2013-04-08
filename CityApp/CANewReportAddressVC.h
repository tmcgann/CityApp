//
//  CANewReportAddressVC.h
//  CityApp
//
//  Created by Taylor McGann on 3/30/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CANewReportAddressVC : UIViewController <UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSDictionary *addressDictionary;
@property (strong, nonatomic) UITextField *addressTextField;

- (IBAction)savePressed:(UIBarButtonItem *)sender;

@end
