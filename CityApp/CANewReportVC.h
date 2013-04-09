//
//  CPNewReportVC.h
//  CityApp
//
//  Created by Taylor McGann on 1/20/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol CAReportEntriesRefreshDelegate <NSObject>
@required
- (void)didDismissNewReportEntryModal;
@end

@class CAReportCategory, CAReportEntriesVC;

@interface CANewReportVC : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) CAReportEntriesVC *delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UITableView *reportInfoTableView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (nonatomic) BOOL photoExists;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CAReportCategory *reportCategory;
@property (strong, nonatomic) NSString *reportDescription;
@property (strong, nonatomic) NSString *reportAddress;
@property (strong, nonatomic) NSDictionary *reportReporterInfo;
@property (nonatomic) BOOL *reportPublic;

@end
