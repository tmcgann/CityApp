//
//  CAReportEntryDetailVC.h
//  CityApp
//
//  Created by Taylor McGann on 3/23/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAReportEntry, CAReportPicture;

@interface CAReportEntryDetailVC : UIViewController

@property (strong, nonatomic) CAReportEntry *reportEntry;
@property (strong, nonatomic) CAReportPicture *reportPicture;
@property (strong, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *reporterLabel;
@property (strong, nonatomic) IBOutlet UILabel *createdLabel;
@property (strong, nonatomic) IBOutlet UILabel *caseIdLabel;

@end
