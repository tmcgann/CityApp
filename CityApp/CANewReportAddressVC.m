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
@property (nonatomic) BOOL regionDidChangeForAddressGecode;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Initial pin drop
    [self.mapView addAnnotation:self.annotation];
//    [self.mapView selectAnnotation:self.annotation animated:YES];
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
    self.regionDidChangeForAddressGecode = NO;
    self.cancelButton.enabled = NO;
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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 400, 400);
    
    // Show the region
    [self.mapView setRegion:region animated:animated];
    
    // Setup the annotation
    self.annotation = [[MKPointAnnotation alloc] init];
    self.annotation.coordinate = coordinate;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self reverseGeocodeLocation:location forAnnotation:self.annotation];
}

- (void)reverseGeocodeLocation:(CLLocation *)location forAnnotation:(MKPointAnnotation *)annotation
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error) {
         if ([placemarks count] > 0)
         {
             self.pinPlacemark = [placemarks objectAtIndex:0];
             NSString *address = [self determineAddress:self.pinPlacemark.addressDictionary];
             annotation.title = address;
             self.addressTextField.text = address;
             DLog(@"Address Dictionary: %@", self.pinPlacemark.addressDictionary);
         }
     }];
}

- (void)gecodeAddressString:(NSString *)address
{
    // Capitalize addres so string comparison works as expected
    NSString *capitalizedAddress = [address capitalizedString];
    
    // Inject city, state info if missing to make geocode more accurate
    if ([capitalizedAddress rangeOfString:CITY].location == NSNotFound) {
        capitalizedAddress = [NSString stringWithFormat:@"%@ %@", capitalizedAddress, CITY];
    }
    if (([capitalizedAddress rangeOfString:STATE].location == NSNotFound) && ([capitalizedAddress rangeOfString:STATE_ABBREVIATION_CAPITALIZED].location == NSNotFound)) {
        capitalizedAddress = [NSString stringWithFormat:@"%@ %@", capitalizedAddress, STATE];
    }
    
    [self.geocoder geocodeAddressString:capitalizedAddress completionHandler:^(NSArray* placemarks, NSError* error) {
        if (placemarks.count > 0) {
            // First placemark is usually the most accurate or closest to the user's current location
            // FIXME: A lot of this code is redundnat with setRegionWithCoordinate:; should try and refactor for more code reuse
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            [self.mapView removeAnnotation:self.annotation];
            self.annotation.coordinate = placemark.location.coordinate;
            self.annotation.title = [self determineAddress:placemark.addressDictionary];
            [self.mapView setCenterCoordinate:placemark.location.coordinate animated:YES];
            self.regionDidChangeForAddressGecode = YES;
//            [self.mapView addAnnotation:self.annotation];
//            [self.mapView selectAnnotation:self.annotation animated:YES];
            
            DLog(@"Latitude: %f", placemark.location.coordinate.latitude);
            DLog(@"Longitude: %f", placemark.location.coordinate.longitude);
            DLog(@"Address: %@", placemark.addressDictionary);
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

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    // Should only be ONE annotation EVER in this map view
    MKPinAnnotationView *view = [views lastObject];
    [mapView selectAnnotation:view.annotation animated:YES];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    self.annotation = (MKPointAnnotation *)annotationView.annotation;
    CLLocationCoordinate2D newCoordinate = self.annotation.coordinate;
    self.pinLocation = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [self reverseGeocodeLocation:self.pinLocation forAnnotation:self.annotation];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.regionDidChangeForAddressGecode) {
        [mapView addAnnotation:self.annotation];
        self.regionDidChangeForAddressGecode = NO;
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
    self.cancelButton.enabled = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
    self.cancelButton.enabled = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Hide textfield
    [textField resignFirstResponder];
    
    // Remap the pin
    if (textField.text.length > 0 && ![textField.text isEqualToString:self.annotation.title]) {
        [self gecodeAddressString:textField.text];
    }
    
    return NO; // We do not want UITextField to insert line-breaks.
}

- (void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = 216; // tweak as needed
    const float movementDuration = 0.25f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

// Tried to add a cancel button via self.toolbar setItems, but it woul call resignFirstResponder on the textfield since it was being reset in the toolbar
// Trying to add a UIBarButtonItem via addSubview: doesn't work either
// To make this a little more sexy, I could try and hide the button in the toolbar and animate it's appearance and the resizing of the UITextField
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender
{
    self.addressTextField.text = self.annotation.title;
    [self.addressTextField resignFirstResponder];
    DLog(@"toolbar.subviews: %@", self.toolbar.subviews);
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
