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
#import "UIImage+Orientation.h"

@interface CANewReportVC ()

@end

@implementation CANewReportVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Deselect table view cell after return from segue
    NSIndexPath *indexPath = [self.reportInfoTableView indexPathForSelectedRow];
    if (indexPath) {
        [self.reportInfoTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Pressed Methods

- (IBAction)cancelPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitPressed:(UIBarButtonItem *)sender
{
#warning TODO: This doesn't do anything yet. Make it actually do something.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)takePhotoPressed:(UIButton *)sender
{
    [self startCameraControllerFromViewController:self usingDelegate:self];
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

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO: See if there is a more efficient way to do this since there are 4 unique cells
    
    // Configure the cell
    static NSString *Cell0 = @"ReportDescriptionCell";
    static NSString *Cell1 = @"ReportAddressCell";
    static NSString *Cell2 = @"ReportReporterCell";
    static NSString *Cell3 = @"ReportPublicCell";
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:Cell0 forIndexPath:indexPath];
            break;
            
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:Cell1 forIndexPath:indexPath];
            break;
            
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:Cell2 forIndexPath:indexPath];
            break;
            
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:Cell3 forIndexPath:indexPath];
            break;

            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Do nothing
}

@end
