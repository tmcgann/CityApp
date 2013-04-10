//
//  CAReportEntriesMapVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/18/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAReportEntriesMapVC.h"
#import "CAReportEntryDetailVC.h"
#import "CASettings.h"
#import "CAReportEntryService.h"
#import "CAReportCategoryService.h"
#import "CAReportCategory.h"
#import "CAMapAnnotation.h"
#import "NSData+Base64.h"

#define ANNOTATION_VIEW_IDENTIFIER_OPEN_REPORT @"openReport"
#define ANNOTATION_VIEW_IDENTIFIER_CLOSED_REPORT @"closedReport"

@interface CAReportEntriesMapVC ()

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSArray *reportEntries;

@end

@implementation CAReportEntriesMapVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupMapView];
    [self mapReportEntries];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRegion];
}

- (void)mapReportEntries
{
    NSError *error;
    self.reportEntries = [[CAObjectStore shared].context executeFetchRequest:[[CAReportEntryService shared] allReportEntries] error:&error];
    for (CAReportEntry *reportEntry in self.reportEntries) {
        CAMapAnnotation *annotation = [[CAMapAnnotation alloc] init];
        NSError *fetchRequestError;
        NSArray *fetchedResults = [[CAObjectStore shared].context executeFetchRequest:[[CAReportCategoryService shared] reportCategoryById:reportEntry.reportCategoryId] error:&fetchRequestError];
        annotation.title = ((CAReportCategory*)[fetchedResults lastObject]).name;
        annotation.thumbnailData = [NSData dataFromBase64String:reportEntry.thumbnailData];
        annotation.coordinate = CLLocationCoordinate2DMake([reportEntry.latitude doubleValue], [reportEntry.longitude doubleValue]);
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[reportEntry.latitude doubleValue] longitude:[reportEntry.longitude doubleValue]];
        [self reverseGeocodeLocation:location forAnnotation:annotation];
        [self.mapView addAnnotation:annotation];
    }
}

- (void)setupMapView
{
    self.mapView.showsUserLocation = YES;
    self.mapView.userLocation.title = nil;
}

- (void)setRegion
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(CITY_LATITUDE, CITY_LONGITUDE);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 4500, 4500);
    [self.mapView setRegion:region animated:NO];
}

- (void)reverseGeocodeLocation:(CLLocation *)location forAnnotation:(CAMapAnnotation *)annotation
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             annotation.placemark = placemark;
             
             annotation.subtitle = [placemark.addressDictionary valueForKey:ADDRESS_DICTIONARY_KEY_FOR_ADDRESS];
             
             // Add a More Info button to the annotation's view.
             MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[self.mapView viewForAnnotation:annotation];
             if (annotationView) {
                 
                 if (annotationView.rightCalloutAccessoryView == nil) {
                     annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                 }
                 
                 if (annotationView.leftCalloutAccessoryView == nil) {
//                     UIImage *thumbnail = [UIImage imageWithData:annotation.thumbnailData scale:0.5];
//                     UIImageView *thumbnailView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, thumbnail.size.width, thumbnail.size.height)];
//                     annotationView.leftCalloutAccessoryView = thumbnailView;
                     annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:annotation.thumbnailData scale:0.5]];
                 }
             }
         }
         if (error) {
             DLog(@"ERROR: %@", error);
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
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:ANNOTATION_VIEW_IDENTIFIER_OPEN_REPORT];
    
    if (!pinAnnotationView) {
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:ANNOTATION_VIEW_IDENTIFIER_OPEN_REPORT];
        pinAnnotationView.pinColor = MKPinAnnotationColorRed;
        pinAnnotationView.draggable = NO;
        pinAnnotationView.animatesDrop = YES;
        pinAnnotationView.canShowCallout = YES;
        //DLog(@"Loaded a new MKPinAnnotationView. Is this expected?");
    } else {
        pinAnnotationView.annotation = annotation;
    }
    
    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    CAMapAnnotation *annotation = (CAMapAnnotation *)annotationView.annotation;
    CLLocationCoordinate2D newCoordinate = annotation.coordinate;
    CLLocation *pinLocation = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [self reverseGeocodeLocation:pinLocation forAnnotation:annotation];
}

#pragma mark - Accessors

- (CLGeocoder *)geocoder
{
    if (!_geocoder)
        _geocoder = [[CLGeocoder alloc] init];
    return _geocoder;
}

@end
