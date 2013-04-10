//
//  CPNewReportVC.m
//  CityApp
//
//  Created by Taylor McGann on 1/20/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CANewReportVC.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "CAReportEntriesVC.h"
#import "CANewReportReportCategoryTVC.h"
#import "CANewReportDescriptionVC.h"
#import "CANewReportAddressVC.h"
#import "CANewReportReporterDetailTVC.h"
#import "CAReportEntryService.h"
#import "CAReportCategory.h"
#import "CAReportPicture.h"
#import "UIImage+Orientation.h"
#import "UIImage+Scale.h"
#import "CASettings.h"

@interface CANewReportVC ()

@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation CANewReportVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the back button title (for next screen)
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    // Set the photo button image content mode so photos display appropriately
    [self.takePhotoButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.takePhotoButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.takePhotoButton.layer.shadowRadius = 5.0;
    
    [self setupNewReportInfo];
    [self setupLocationManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self deselectSelectedRow];
    
    // Refresh table view to update data in the event of any changes
    [self.reportInfoTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

- (void)deselectSelectedRow
{
    // Deselect table view cell upon returning to view
    NSIndexPath *indexPath = [self.reportInfoTableView indexPathForSelectedRow];
    if (indexPath) {
        [self.reportInfoTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToReportCategory"]) {
        CANewReportReportCategoryTVC *reportCategoryTVC = segue.destinationViewController;
        reportCategoryTVC.selectedReportCategory = self.reportCategory;
    } else if ([segue.identifier isEqualToString:@"segueToReportDescription"]) {
        CANewReportDescriptionVC *descriptionVC = segue.destinationViewController;
        descriptionVC.reportDescription = self.reportDescription;
    } else if ([segue.identifier isEqualToString:@"segueToReportAddress"]) {
        CANewReportAddressVC *addressVC = segue.destinationViewController;
        addressVC.pinLocation = self.reportLocation;
    }
    // Don't have to pass any data to reporter detail b/c data is stored in NSUserDefaults
}

- (void)setupNewReportInfo
{
    // Load any existing reporter info from user defaults
    NSDictionary *reporterInfo = [[NSUserDefaults standardUserDefaults] valueForKey:REPORTER_INFO_DICT_KEY];
    self.reportReporterInfo = reporterInfo;
    
    // Report addres not user defined by default
    self.reportAddressUserDefined = NO;
    
    // New reports are public by default until modified
    self.reportPublic = YES;
}

- (void)setupLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 20;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)updateCurrentAddress:(CLLocation *)location
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             self.reportPlacemark = placemark;
             self.reportAddress = [placemark.addressDictionary valueForKey:ADDRESS_DICTIONARY_KEY_FOR_ADDRESS];
             [self.reportInfoTableView reloadData];
         }
     }];
}

#pragma mark - Label text methods

- (void)setupCategoryLabel:(UILabel *)label
{
    if (self.reportCategory) {
        label.text = self.reportCategory.name;
        label.textColor = [UIColor darkTextColor];
    } else {
        label.text = @"Report Category";
        label.textColor = [UIColor lightGrayColor];
    }
}

- (void)setupDescriptionLabel:(UILabel *)label
{
    if (self.reportDescription) {
        label.text = self.reportDescription;
        label.textColor = [UIColor darkTextColor];
    } else {
        label.text = @"Description";
        label.textColor = [UIColor lightGrayColor];
    }
}

- (void)setupAddressLabel:(UILabel *)label
{
    if (self.reportAddressUserDefined) {
        label.text = self.reportAddress;
        label.textColor = [UIColor darkTextColor];
    } else if (self.reportAddress) {
        label.text = self.reportAddress;
        label.textColor = [UIColor lightGrayColor];
    } else {
        label.text = @"Address";
        label.textColor = [UIColor lightGrayColor];
    }
}

- (void)setupReporterLabel:(UILabel *)label
{
    if (self.reportReporterInfo) {
        label.text = [self buildReporterName];
        label.textColor = [UIColor darkTextColor];
    } else {
        label.text = REPORTER_INFO_DEFAULT_NAME;
        label.textColor = [UIColor lightGrayColor];
    }
}

- (NSString *)buildReporterName
{
    NSString *name;
    
    if ([self.reportReporterInfo valueForKey:REPORTER_FIRST_NAME_KEY] && [self.reportReporterInfo valueForKey:REPORTER_LAST_NAME_KEY] && ![[self.reportReporterInfo valueForKey:REPORTER_FIRST_NAME_KEY] isEqualToString:@""] && ![[self.reportReporterInfo valueForKey:REPORTER_LAST_NAME_KEY] isEqualToString:@""]) {
        name = [NSString stringWithFormat:@"%@ %@", [self.reportReporterInfo valueForKey:REPORTER_FIRST_NAME_KEY], [self.reportReporterInfo valueForKey:REPORTER_LAST_NAME_KEY]];
    } else if ([self.reportReporterInfo valueForKey:REPORTER_FIRST_NAME_KEY] && ![[self.reportReporterInfo valueForKey:REPORTER_FIRST_NAME_KEY] isEqualToString:@""]) {
        name = [self.reportReporterInfo valueForKey:REPORTER_FIRST_NAME_KEY];
    } else if ([self.reportReporterInfo valueForKey:REPORTER_LAST_NAME_KEY] && ![[self.reportReporterInfo valueForKey:REPORTER_LAST_NAME_KEY] isEqualToString:@""]) {
        name = [self.reportReporterInfo valueForKey:REPORTER_LAST_NAME_KEY];
    } else {
        name = REPORTER_INFO_DEFAULT_NAME;
    }
    
    return name;
}

#pragma mark - Submit New Report Entry

- (BOOL)validData
{
    return (self.reportCategory && self.reportDescription && self.reportAddress && self.reportPublic);
}

- (void)submitNewReportEntry
{
    CAObjectStore *objectStore = [CAObjectStore shared];
    
    // Create report entry
    CAReportEntry *reportEntry = (CAReportEntry *)[objectStore insertNewObjectForEntityName:@"CAReportEntry"];
    reportEntry.reportCategory = self.reportCategory;
    reportEntry.reportCategoryId = self.reportCategory.reportCategoryId;
    reportEntry.descriptor = self.reportDescription;
    reportEntry.address = self.reportAddress;
    reportEntry.latitude = [NSString stringWithFormat:@"%+.8f", self.reportLocation.coordinate.latitude];
    reportEntry.longitude = [NSString stringWithFormat:@"%+.8f", self.reportLocation.coordinate.longitude];
    reportEntry.contactName = [self buildReporterName];
    reportEntry.contactEmail = [self.reportReporterInfo valueForKey:REPORTER_EMAIL_ADDRESS_KEY];
    reportEntry.contactPhone = [self.reportReporterInfo valueForKey:REPORTER_PHONE_NUMBER_KEY];
    reportEntry.exposed = [NSNumber numberWithBool:self.reportPublic];
    
    // Create report picture
//    CAReportPicture *reportPicture = (CAReportPicture *)[objectStore insertNewObjectForEntityName:@"CAReportPicture"];
//    reportPicture.filename =
    
    // Associate with report picture with report entry
//    NSMutableOrderedSet *reportPictures = [NSMutableOrderedSet orderedSetWithOrderedSet:reportEntry.reportPictures];
//    [reportPictures addObject:reportPicture];
//    reportEntry.reportPictures = [reportPictures copy];
    
//    [objectStore saveContext];
    DLog(@"New Report Entry: %@", reportEntry.description);

    if (self.photoExists) {
        UIImage *image = self.takePhotoButton.imageView.image;
        [[CAReportEntryService shared] createEntry:reportEntry withPicture:image];
    } else {
        [[CAReportEntryService shared] createEntry:reportEntry];
    }
}

#pragma mark - IBAction Methods

- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitPressed:(UIBarButtonItem *)sender
{
    if ([self validData]) {
        [self submitNewReportEntry];
        [self dismissViewControllerAnimated:YES completion:^(void){
            [self.delegate didDismissNewReportEntryModal];
        }];
    } else {
        NSString *title = @"Missing Required Info";
        NSString *message = @"All fields are required to submit a report.";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)takePhotoPressed:(UIButton *)sender
{
    [self launchImagePickerFromViewController:self usingDelegate:self];
}

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    self.reportPublic = sender.on;
}

#pragma mark - Launch Camera

- (void)launchImagePickerFromViewController:(UIViewController*)controller
                                  usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil))
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    else
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        // Only capture still images; add kUTTypeMovie to the array for video
        self.imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
        
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        self.imagePicker.allowsEditing = NO;
    }
    
    self.imagePicker.delegate = delegate;
    
    [controller presentViewController:self.imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage;
    NSDictionary *mediaMetadata;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // If camera is image source
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            mediaMetadata = (NSDictionary *) [info objectForKey:UIImagePickerControllerMediaMetadata];
            
            // Save original image to the Camera Roll
            //UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil , nil);
            ALAssetsLibrary *library = [ALAssetsLibrary new];
            [library writeImageToSavedPhotosAlbum:originalImage.CGImage metadata:mediaMetadata completionBlock:nil];
        }
        
        // Rotate image if portrait
        if (!editedImage) {
            editedImage = originalImage;
            [editedImage fixOrientation];
        }
        
        // Scale image size
        editedImage = [self resizeImage:editedImage];
        
        self.photoExists = YES;
        [self.takePhotoButton setImage:editedImage forState:UIControlStateNormal];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image Manipulation

- (UIImage *)cropImage:(UIImage *)originalImage toRect:(CGRect)newSize
{
    // Create a new image in quartz with our new bounds and original image
    CGImageRef tmp = CGImageCreateWithImageInRect([originalImage CGImage], newSize);
    
    // Pump our cropped image back into a UIImage object
    UIImage *croppedImage = [UIImage imageWithCGImage:tmp];
    
    return croppedImage;
}

- (UIImage *)resizeImage:(UIImage *)originalImage
{
    CGSize newSize;
    if (originalImage.size.width > originalImage.size.height) {
        newSize = CGSizeMake(LANDSCAPE_IMAGE_SCALED_WIDTH, LANDSCAPE_IMAGE_SCALED_HEIGHT);
    } else {
        newSize = CGSizeMake(PORTRAIT_IMAGE_SCALED_WIDTH, PORTRAIT_IMAGE_SCALED_HEIGHT);
    }
    return [originalImage scaleToSize:newSize];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: See if there is a more efficient way to do this since there are 5 unique cells
    
    // Configure the cell
    static NSString *Cell0 = @"ReportCategoryCell";
    static NSString *Cell1 = @"ReportDescriptionCell";
    static NSString *Cell2 = @"ReportAddressCell";
    static NSString *Cell3 = @"ReportReporterCell";
    static NSString *Cell4 = @"ReportPublicCell";
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:Cell0 forIndexPath:indexPath];
            UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
            [self setupCategoryLabel:cellLabel];
        }
        break;
            
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:Cell1 forIndexPath:indexPath];
            UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
            [self setupDescriptionLabel:cellLabel];
        }
        break;
            
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:Cell2 forIndexPath:indexPath];
            UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
            [self setupAddressLabel:cellLabel];
        }
        break;
            
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:Cell3 forIndexPath:indexPath];
            UILabel *cellLabel = (UILabel *)[cell viewWithTag:1];
            [self setupReporterLabel:cellLabel];
        }
        break;

        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:Cell4 forIndexPath:indexPath];
            UISwitch *cellSwitch = (UISwitch *)[cell viewWithTag:1];
            [cellSwitch setOn:self.reportPublic animated:YES];
        }
        break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Do nothing
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power?
    // If the event is recent AND accurate, turn off updates to save power?
    self.reportLocation = [locations lastObject];
    NSDate* eventDate = self.reportLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        [self updateCurrentAddress:self.reportLocation];
//        DLog(@"latitude %+.6f, longitude %+.6f\n", self.reportLocation.coordinate.latitude, self.reportLocation.coordinate.longitude);
//        DLog(@"horizontalAccuracy: %+.6f", self.reportLocation.horizontalAccuracy);
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
