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
#import "CANewReportReportCategoryTVC.h"
//#import "CANewReportDescriptionTVC.h"
//#import "CANewReportAddressTVC.h"
#import "CANewReportReporterDetailTVC.h"
#import "CAReportEntryService.h"
#import "CAReportCategory.h"
#import "CAReportPicture.h"
#import "UIImage+Orientation.h"
#import "CASettings.h"

//#define NEW_REPORT_INFO_CATEGORY_KEY @"reportCategory"
//#define NEW_REPORT_INFO_DESCRIPTION_KEY @"description"
//#define NEW_REPORT_INFO_ADDRESS_KEY @"address"
//#define NEW_REPORT_INFO_REPORTER_KEY @"reporter"
//#define NEW_REPORT_INFO_PUBLIC_KEY @"public"

@interface CANewReportVC ()

@end

@implementation CANewReportVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNewReportInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self deselectSelectedRow];
    
    // Refresh table view to update data in the event of any changes
    [self.reportInfoTableView reloadData];
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
        // Update with current description
    } else if ([segue.identifier isEqualToString:@"segueToReportAddress"]) {
        // Update with current address
    }
    // Don't have to pass any data to reporter detail b/c data is stored in NSUserDefaults
}

- (void)setupNewReportInfo
{
//    self.newReportInfo = [NSMutableDictionary dictionaryWithCapacity:5];
    
    // Load any existing reporter info from user defaults
    NSDictionary *reporterInfo = [[NSUserDefaults standardUserDefaults] valueForKey:REPORTER_INFO_DICT_KEY];
    self.reportReporterInfo = reporterInfo;
//    [self.newReportInfo setValue:reporterInfo forKey:NEW_REPORT_INFO_REPORTER_KEY];
    
    // Automatically calculate the users current address
    NSString *currentAddress = [self determineCurrentAddress];
    self.reportAddress = currentAddress;
//    [self.newReportInfo setValue:currentAddress forKey:NEW_REPORT_INFO_ADDRESS_KEY];
    
    // New reports are public by default until modified
    self.reportPublic = YES;
//    [self.newReportInfo setValue:YES forKey:NEW_REPORT_INFO_PUBLIC_KEY];
}

- (NSString *)determineCurrentAddress
{
    return nil;
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
    if (self.reportAddress) {
        label.text = self.reportAddress;
        label.textColor = [UIColor darkTextColor];
    } else {
        label.text = @"Address";
        label.textColor = [UIColor lightGrayColor];
    }
}

- (void)setupReporterLabel:(UILabel *)label
{
    if (self.reportReporterInfo) {
        label.text = [self reporterLabelText];
        label.textColor = [UIColor darkTextColor];
    } else {
        label.text = REPORTER_INFO_DEFAULT_NAME;
        label.textColor = [UIColor lightGrayColor];
    }
}

- (NSString *)reporterLabelText
{
    NSString *name;
    
    if (![[self.reportReporterInfo valueForKey:REPORTER_FIRST_NAME_KEY] isEqualToString:@""] && ![[self.reportReporterInfo valueForKey:REPORTER_LAST_NAME_KEY] isEqualToString:@""]) {
        name = [NSString stringWithFormat:@"%@ %@", [self.reportReporterInfo valueForKey:REPORTER_FIRST_NAME_KEY], [self.reportReporterInfo valueForKey:REPORTER_LAST_NAME_KEY]];
    } else if (![[self.reportReporterInfo valueForKey:REPORTER_FIRST_NAME_KEY] isEqualToString:@""]) {
        name = [self.reportReporterInfo valueForKey:REPORTER_FIRST_NAME_KEY];
    } else if (![[self.reportReporterInfo valueForKey:REPORTER_LAST_NAME_KEY] isEqualToString:@""]) {
        name = [self.reportReporterInfo valueForKey:REPORTER_LAST_NAME_KEY];
    } else {
        name = REPORTER_INFO_DEFAULT_NAME;
    }
    
    return name;
}

#pragma mark - IBAction Methods

- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitPressed:(UIBarButtonItem *)sender
{
//    if ([self validData]) {
        [self submitNewReportEntry];
        [self dismissViewControllerAnimated:YES completion:nil];
//    }
}

- (IBAction)takePhotoPressed:(UIButton *)sender
{
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (IBAction)switchValueChanged:(UISwitch *)sender
{
    self.reportPublic = sender.on;
}

#pragma mark - Submit New Report Entry

- (BOOL)validData
{
//    BOOL validReportCategory = NO;
//    BOOL validDescription = NO;
//    BOOL validAddress = NO;
//    
//    if (self.newReportCategory) {
//        validReportCategory = YES;
//    }
//    if (self.newReportDescription) {
//        validDescription = YES;
//    }
//    if (self.newReportAddress) {
//        validAddress = YES;
//    }
//    
//    return (validReportCategory && validDescription && validAddress);

    return (self.reportCategory && self.reportDescription && self.reportAddress);
}

- (void)submitNewReportEntry
{
    CAObjectStore *objectStore = [CAObjectStore shared];
//    CAReportEntry *reportEntry = (CAReportEntry *)[objectStore insertNewObjectForEntityName:@"CAReportEntry"];
//    reportEntry.reportCategory =
//    CAReportPicture *reportPicture = (CAReportPicture *)[objectStore insertNewObjectForEntityName:@"CAReportPicture"];
//    reportPicture.filename =
//    [objectStore saveContext];
//    DLog(@"New Report Entry: %@", self.newReportEntry.description);
    
//    [[CAReportEntryService shared] createEntry:self.newReportEntry withPicture:self.takePhotoButton.imageView.image];
}

#pragma mark - Launch Camera

- (BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                  usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate
{
    BOOL cameraAvailable = YES;
    self.imagePicker = [[UIImagePickerController alloc] init];
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil))
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        cameraAvailable = NO;
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
    
    return cameraAvailable;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage;
    NSDictionary *mediaMetadata;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo)
    {
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
        
        // If no edited image exists, use a cropped version of the original image
//        if (!editedImage)
//        {
//            CGFloat width = originalImage.size.width;
//            CGFloat height = originalImage.size.height;
//            
//            // Crop photo album images as long as they are standard iPhone images with standard 4:3 or 3:4 ratio
//            if (width > height)
//            {
//                // 'x' is half the distance of the difference between the width and the height
//                CGFloat x = (width - height) / 2;
//                
//                // Make a new bounding rectangle including our crop
//                CGRect newSize = CGRectMake(x, 0, height, height);
//                
//                editedImage = [self cropImage:originalImage toRect:newSize];
//            }
//            else if (height > width)
//            {
//                // 'y' is half the distance of the difference between the height and the width
//                CGFloat y = (height - width) / 2;
//                
//                // Make a new bounding rectangle including our crop
//                CGRect newSize = CGRectMake(0, y, width, width);
//                
//                editedImage = [self cropImage:originalImage toRect:newSize];
//            }
//            else
//            {
//                editedImage = originalImage;
//            }
//        }
        
        [self.takePhotoButton setBackgroundImage:editedImage forState:UIControlStateNormal];
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

@end
