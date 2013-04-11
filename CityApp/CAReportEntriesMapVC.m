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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setRegion];
    [self mapReportEntries];
}

- (void)mapReportEntries
{
    NSError *error;
    self.reportEntries = [[CAObjectStore shared].context executeFetchRequest:[[CAReportEntryService shared] allReportEntries] error:&error];
    
    if (error) {
        DLog(@"ERROR: %@", error);
        return;
    }
    
    for (CAReportEntry *reportEntry in self.reportEntries) {
        CAMapAnnotation *annotation = [[CAMapAnnotation alloc] init];
        NSError *fetchRequestError;
        NSArray *fetchedResults = [[CAObjectStore shared].context executeFetchRequest:[[CAReportCategoryService shared] reportCategoryById:reportEntry.reportCategoryId] error:&fetchRequestError];
        annotation.title = ((CAReportCategory*)[fetchedResults lastObject]).name;
        annotation.subtitle = reportEntry.address;
        annotation.thumbnailData = [NSData dataFromBase64String:reportEntry.thumbnailData];
        annotation.coordinate = CLLocationCoordinate2DMake([reportEntry.latitude doubleValue], [reportEntry.longitude doubleValue]);
        annotation.reportEntry = reportEntry;
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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 4750, 4750);
    [self.mapView setRegion:region animated:NO];
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
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinAnnotationView.rightCalloutAccessoryView = button;
    }
    
    // Apply to all annotation views
    pinAnnotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:((CAMapAnnotation*)annotation).thumbnailData scale:2.2]];
    pinAnnotationView.annotation = annotation;

    return pinAnnotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CAReportEntryDetailVC *reportEntryDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportEntryDetail"];
    reportEntryDetailVC.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    reportEntryDetailVC.reportEntry = ((CAMapAnnotation*)view.annotation).reportEntry;
    [self presentViewController:reportEntryDetailVC animated:YES completion:nil];
}

#pragma mark - Accessors

- (CLGeocoder *)geocoder
{
    if (!_geocoder)
        _geocoder = [[CLGeocoder alloc] init];
    return _geocoder;
}

@end
