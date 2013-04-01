//
//  CANewReportAddressVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/30/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CANewReportAddressVC.h"

#define ANNOTATION_VIEW_IDENTIFIER @"defaultPinAnnotationView"

@interface CANewReportAddressVC ()

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) MKPinAnnotationView *pinAnnotationView;

@end

@implementation CANewReportAddressVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMapView];
//    [self setupLocationManager];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showUserLocation];
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

- (void)showUserLocation
{
    // Get user location and region
    CLLocationCoordinate2D currentCoordinate = [self.mapView.userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentCoordinate, 300, 300);
    
    // Show the region
    [self.mapView setRegion:region animated:YES];
    
    // Drop the draggable pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = currentCoordinate;
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentCoordinate.latitude longitude:currentCoordinate.longitude];
    annotation.title = [self convertCoordinatesToAddress:currentLocation];
    [self.mapView addAnnotation:annotation];
}

- (void)setupLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 20;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (NSString *)convertCoordinatesToAddress:(CLLocation *)location
{
    NSString __block *address = nil;
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0) {
            //annotation.placemark = [placemarks objectAtIndex:0];
            
            // Add a More Info button to the annotation's view.
            //MKPinAnnotationView*  view = (MKPinAnnotationView*)[map viewForAnnotation:annotation];
            //if (view && (view.rightCalloutAccessoryView == nil))
            //{
            //    view.canShowCallout = YES;
            //    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //}
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            address = [placemark.addressDictionary valueForKey:@"Name"];
            NSLog(@"Address Dictionary: %@", placemark.addressDictionary);
        }
    }];
    return address;
}

- (void)convertAddressToCoordinates:(NSString *)address
{
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error) {
         for (CLPlacemark* placemark in placemarks) {
             // Process the placemark.
         }
    }];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Only default annotations left, so handle it with a pin annotation view
    self.pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATION_VIEW_IDENTIFIER];
    
    if (!self.pinAnnotationView) {
        self.pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ANNOTATION_VIEW_IDENTIFIER];
        self.pinAnnotationView.pinColor = MKPinAnnotationColorRed;
        self.pinAnnotationView.draggable = YES;
        self.pinAnnotationView.animatesDrop = YES;
        self.pinAnnotationView.canShowCallout = YES;
        DLog(@"Loaded a new MKPinAnnotationView. Is this expected?");
    } else {
        self.pinAnnotationView.annotation = annotation;
    }
    
    return self.pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    
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

//- (MKPinAnnotationView *)annotationView
//{
//    if (!_annotationView) {
//        _annotationView = [[MKPinAnnotationView alloc] init];
//        _annotationView.animatesDrop = YES;
//        _annotationView.pinColor = MKPinAnnotationColorRed;
//    }
//    return _annotationView;
//}

@end
