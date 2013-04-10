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
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) MKPointAnnotation *annotation;
@property (strong, nonatomic) CLLocation *pinLocation;
@property (strong, nonatomic) CLPlacemark *pinPlacemark;

- (IBAction)savePressed:(UIBarButtonItem *)sender;

@end
