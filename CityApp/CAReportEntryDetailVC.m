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
#import "TMImageSync.h"

@interface CAReportEntryDetailVC ()

@property (strong, nonatomic) TMImageSync *imageSync;

@end

@implementation CAReportEntryDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:GLOBAL_BACKGROUND_IMAGE]];
    
    [self populateViewWithData];
}

- (void)populateViewWithData
{
    self.pictureImageView.image = [self fetchReportPicture:self.reportEntry.pictureFilename];
    // Add 3 new lines to the end of the description
    // to make sure it aligns with the top of the label
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@\n\n\n", self.reportEntry.descriptor];
    self.addressLabel.text = self.reportEntry.address;
    self.reporterLabel.text = self.reportEntry.contactName;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:GLOBAL_DATE_FORMAT];
    self.createdLabel.text = [formatter stringFromDate:self.reportEntry.created];
//    self.caseIdLabel.text = self.reportEntry.caseId;
    
    // Resize the description label to fit all the text
//    [self resizeLabel:self.descriptionLabel];
//    self.descriptionLabel.numberOfLines = 0;
//    [self.descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];
//    [self.descriptionLabel sizeToFit];
}

- (UIImage *)fetchReportPicture:(NSString *)pictureFilename
{
    if (!pictureFilename || [pictureFilename isEqualToString:@""]) {
        return nil;
    } else {
        [self.imageSync fetchImageWithoutSync:pictureFilename];
        NSURL *pictureURL = [self.imageSync.imagesDir URLByAppendingPathComponent:pictureFilename];
        return [UIImage imageWithContentsOfFile:pictureURL.path];
    }
}

//- (void)resizeLabel:(UILabel *)label
//{
//    CGRect titleLabelBounds = label.bounds;
//    titleLabelBounds.size.height = CGFLOAT_MAX;
//    // Change limitedToNumberOfLines to your preferred limit (0 for no limit)
//    CGRect minimumTextRect = [label textRectForBounds:titleLabelBounds limitedToNumberOfLines:2];
//    
//    CGFloat titleLabelHeightDelta = minimumTextRect.size.height - label.frame.size.height;
//    CGRect titleFrame = label.frame;
//    titleFrame.size.height += titleLabelHeightDelta;
//    label.frame = titleFrame;
//}

#pragma mark - Accessors

- (TMImageSync *)imageSync
{
    if (!_imageSync) {
        _imageSync = [[TMImageSync alloc] init];
        _imageSync.remoteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, IMAGE_CONTROLLER_PATH]];
    }
    return _imageSync;
}

@end
