//
//  CANewReportAddressVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/30/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CANewReportAddressVC.h"
#import "CANewReportVC.h"
#import "CASettings.h"

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRegion];
//    [self setRegionToUserLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.mapView addAnnotation:self.annotation];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)setupMapView
{
    self.mapView.showsUserLocation = YES;
    self.mapView.userLocation.title = nil;
}

- (void)setRegion
{
    if (self.pinLocation) {
        [self setRegionWithCoordinate:self.pinLocation.coordinate animated:NO];
    } else {
        [self setRegionWithCoordinate:self.mapView.userLocation.coordinate animated:NO];
    }
}

- (void)setRegionWithCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 300, 300);
    
    // Show the region
    [self.mapView setRegion:region animated:animated];
    
    // Drop the pin
    self.annotation = [[MKPointAnnotation alloc] init];
    self.annotation.coordinate = coordinate;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self reverseGeocodeLocation:location forAnnotation:self.annotation];
//    [self.mapView addAnnotation:annotation];
}

- (void)reverseGeocodeLocation:(CLLocation *)location forAnnotation:(MKPointAnnotation *)annotation
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             self.pinPlacemark = [placemarks objectAtIndex:0];
             annotation.title = [self determineAddress:self.pinPlacemark.addressDictionary];
             NSLog(@"Address Dictionary: %@", self.pinPlacemark.addressDictionary);
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

- (NSString *)determineAddress:(NSDictionary *)addressDictionary
{
    if ([addressDictionary valueForKey:PRIMARY_ADDRESS_DICTIONARY_KEY_FOR_ADDRESS]) {
        return [addressDictionary valueForKey:PRIMARY_ADDRESS_DICTIONARY_KEY_FOR_ADDRESS];
    } else if ([addressDictionary valueForKey:SECONDARY_ADDRESS_DICTIONARY_KEY_FOR_ADDRESS]) {
        return [addressDictionary valueForKey:SECONDARY_ADDRESS_DICTIONARY_KEY_FOR_ADDRESS];
    } else {
        return INDETERMINABLE_ADDRESS_STRING;
    }
}

- (BOOL)validData
{
    return [[self.pinPlacemark.addressDictionary valueForKey:@"City"] isEqualToString:CITY];
}

- (void)updateReportEntryData
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    NSUInteger previousViewControllerIndex = viewControllers.count - 2;
    CANewReportVC *newReportVC = (CANewReportVC *)[viewControllers objectAtIndex:previousViewControllerIndex];
    newReportVC.reportAddress = [self determineAddress:self.pinPlacemark.addressDictionary];
    newReportVC.reportPlacemark = self.pinPlacemark;
    newReportVC.reportLocation = self.pinLocation;
    newReportVC.reportAddressUserDefined = YES;
}

#pragma mark - IBActions

- (IBAction)savePressed:(UIBarButtonItem *)sender
{
    if ([self validData]) {
        [self updateReportEntryData];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Address" message:@"Address is located outside city border." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
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
    self.annotation = (MKPointAnnotation *)annotationView.annotation;
    CLLocationCoordinate2D newCoordinate = self.annotation.coordinate;
    self.pinLocation = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [self reverseGeocodeLocation:self.pinLocation forAnnotation:self.annotation];
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
