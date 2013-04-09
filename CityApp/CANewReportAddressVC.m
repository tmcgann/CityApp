//
//  CANewReportAddressVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/30/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CANewReportAddressVC.h"
#import "CANewReportVC.h"

#define ANNOTATION_VIEW_IDENTIFIER @"defaultPinAnnotationView"

@interface CANewReportAddressVC ()

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) MKPinAnnotationView *pinAnnotationView;

@end

@implementation CANewReportAddressVC

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setupAddressToolbar];
    [self setupMapView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setRegionToUserLocation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)setupAddressToolbar
{
//    self.addressTextField.text =
    
    UIBarButtonItem *textFieldWrapper = [[UIBarButtonItem alloc] initWithCustomView:self.addressTextField];
//    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    [self setToolbarItems:@[textFieldWrapper] animated:NO];
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlack];
    [self.navigationController setToolbarHidden:NO animated:NO];
}

- (void)setupMapView
{
    self.mapView.showsUserLocation = YES;
    self.mapView.userLocation.title = nil;
}

- (void)setRegionToUserLocation
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
    [self reverseGeocodeLocation:currentLocation forAnnotation:annotation];
    [self.mapView addAnnotation:annotation];
}

- (void)dropPin:(MKUserLocation *)userLocation
{
    // Drop the draggable pin
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = userLocation.coordinate;
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
    [self reverseGeocodeLocation:currentLocation forAnnotation:annotation];
    [self.mapView addAnnotation:annotation];
}

- (void)reverseGeocodeLocation:(CLLocation *)location forAnnotation:(MKPointAnnotation *)annotation
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
//             annotation.placemark = [placemarks objectAtIndex:0];
             
             // Add a More Info button to the annotation's view.
//             MKPinAnnotationView*  view = (MKPinAnnotationView*)[map viewForAnnotation:annotation];
//             if (view && (view.rightCalloutAccessoryView == nil))
//             {
//                 view.canShowCallout = YES;
//                 view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//             }
             
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             annotation.title = [placemark.addressDictionary valueForKey:@"Name"];
             NSLog(@"Address Dictionary: %@", placemark.addressDictionary);
         }
     }];
}

- (void)convertAddressToCoordinates:(NSString *)address
{
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks, NSError* error) {
         for (CLPlacemark* placemark in placemarks) {
             // Process the placemark.
         }
    }];
}

- (BOOL)validData
{
#warning TODO: Validate data by making sure the address is in the desired city: set a city variable in the CASettings, create a custom CAMapAnnotation w/ a property to hold the placemark from 'reverseGeocodeLocation:forAnnotation:'; Use '[placemark.addressDictionary valueForKey:@"City"]' for the city name
    return YES;
}

- (void)updateReportEntryData
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    NSUInteger previousViewControllerIndex = viewControllers.count - 2;
    CANewReportVC *newReportVC = (CANewReportVC *)[viewControllers objectAtIndex:previousViewControllerIndex];
    newReportVC.reportAddress = self.pinAnnotationView.annotation.title;
}

#pragma mark - IBActions

- (IBAction)savePressed:(UIBarButtonItem *)sender
{
    if ([self validData]) {
        [self updateReportEntryData];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    MKPointAnnotation *annotation = (MKPointAnnotation *)annotationView.annotation;
    CLLocationCoordinate2D newCoordinate = ((MKPointAnnotation *)annotationView.annotation).coordinate;
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [self reverseGeocodeLocation:newLocation forAnnotation:annotation];
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
