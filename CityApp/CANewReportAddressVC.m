//
//  CANewReportAddressVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/30/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CANewReportAddressVC.h"

@interface CANewReportAddressVC ()

@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation CANewReportAddressVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMapView];
//    [self setupLocationManager];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.locationManager stopUpdatingLocation];
}

- (void)setupMapView
{
    self.mapView.showsUserLocation = YES;
}

- (void)setupLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 20;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

//- (void)geocodeLocation:(CLLocation*)location forAnnotation:(MapLocation*)annotation
//{
//    [self.geocoder reverseGeocodeLocation:location completionHandler:
//     ^(NSArray* placemarks, NSError* error){
//         if ([placemarks count] > 0)
//         {
//             annotation.placemark = [placemarks objectAtIndex:0];
//             
//             // Add a More Info button to the annotation's view.
//             MKPinAnnotationView*  view = (MKPinAnnotationView*)[map viewForAnnotation:annotation];
//             if (view && (view.rightCalloutAccessoryView == nil))
//             {
//                 view.canShowCallout = YES;
//                 view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//             }
//         }
//     }];
//}

- (void)convertAddressToCoordinates:(NSString *)address
{
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error) {
         for (CLPlacemark* aPlacemark in placemarks)
         {
             // Process the placemark.
         }
    }];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    return nil;
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power?
    // If the event is recent AND accurate, turn off updates to save power?
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        NSLog(@"latitude %+.6f, longitude %+.6f\n", location.coordinate.latitude, location.coordinate.longitude);
        NSLog(@"horizontalAccuracy: %+.6f", location.horizontalAccuracy);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"ERROR: Location Manager failed to determine location.");
}

#pragma mark - Accessors

- (CLGeocoder *)geocoder
{
    if (!_geocoder)
        _geocoder = [[CLGeocoder alloc] init];
    return _geocoder;
}

@end
