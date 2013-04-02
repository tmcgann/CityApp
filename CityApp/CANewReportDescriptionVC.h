//
//  CANewReportDescriptionVC.h
//  CityApp
//
//  Created by Taylor McGann on 3/29/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CANewReportDescriptionVC : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) NSString *reportDescription;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;

- (IBAction)savePressed:(UIBarButtonItem *)sender;

@end
