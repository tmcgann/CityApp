//
//  CAReportEntryDetailVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/23/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAReportEntryDetailVC.h"
#import "CAReportEntry.h"
#import "CAReportPicture.h"
#import "CASettings.h"

@interface CAReportEntryDetailVC ()

@end

@implementation CAReportEntryDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:GLOBAL_BACKGROUND_IMAGE]];
    
    [self populateViewWithData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateViewWithData
{
    self.pictureImageView.image = [UIImage imageWithContentsOfFile:self.reportPicture.filename];
    // Add 3 new lines to the end of the description
    // to make sure it aligns with the top of the label
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@\n\n\n", self.reportEntry.descriptor];
    self.addressLabel.text = self.reportEntry.address;
    self.reporterLabel.text = self.reportEntry.contactName;
    self.createdLabel.text = [self.reportEntry.created description];
//    self.caseIdLabel.text = self.reportEntry.caseId;
}

@end
