//
//  CANewReportReporterDetailTVC.h
//  CityApp
//
//  Created by Taylor McGann on 3/27/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CANewReportReporterDetailTVC : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@property (weak, nonatomic) IBOutlet UITextField *twitterHandleField;

@end
