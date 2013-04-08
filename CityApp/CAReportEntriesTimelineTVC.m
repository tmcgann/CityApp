//
//  CAReportEntriesTVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/7/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CAReportEntriesTimelineTVC.h"
#import "CAReportEntryDetailVC.h"
#import "CAReportEntryService.h"
#import "CAReportCategoryService.h"
#import "CAReportEntry.h"
#import "CAReportPicture.h"
#import "CAReportCategory.h"
#import "TMImageSync.h"
#import "CASettings.h"
#import "NSData+Base64.h"

#define CELL_PICTURE_TAG 0
#define CELL_CATEGORY_TAG 1
#define CELL_ADDRESS_TAG 2
#define CELL_DESCRIPTOR_TAG 3
#define CELL_CREATED_TAG 4

@interface CAReportEntriesTimelineTVC ()

@end

@implementation CAReportEntriesTimelineTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background image
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:GLOBAL_BACKGROUND_IMAGE]];
    
    // Load objects via Core Data/RestKit
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[[CAReportEntryService shared] allReportEntries] managedObjectContext:[CAObjectStore shared].context sectionNameKeyPath:nil cacheName:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushToReportEntryDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CAReportEntryDetailVC *reportEntryDetailVC = segue.destinationViewController;
        reportEntryDetailVC.reportEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];
//        reportEntryDetailVC.reportPicture = nil;
//        reportEntryDetailVC.reportCategory = nil;
    }
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    static NSString *CellIdentifier = @"ReportEntryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get all the necessary objects and data to for the various images and labels
    CAReportEntry *reportEntry = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NSString *thumbnailBase64 = reportEntry.thumbnailData;
    NSData *thumbnailData = [NSData dataFromBase64String:thumbnailBase64];
    UIImage *reportPictureThumbnail = [UIImage imageWithData:thumbnailData];
    UIImageView *thumbailImageView = (UIImageView *)[cell viewWithTag:CELL_PICTURE_TAG];
    thumbailImageView.image = reportPictureThumbnail;
    thumbailImageView.layer.cornerRadius = REPORT_ENTRY_THUMBNAIL_CORNER_RADIUS;
    thumbailImageView.clipsToBounds = YES;
    
    CAReportCategory *reportCategory = [self fetchReportCategoryById:reportEntry.reportCategoryId];
    ((UILabel *)[cell viewWithTag:CELL_CATEGORY_TAG]).text = reportCategory.name;
    
    ((UILabel *)[cell viewWithTag:CELL_ADDRESS_TAG]).text = reportEntry.address;
    
    ((UILabel *)[cell viewWithTag:CELL_DESCRIPTOR_TAG]).text = reportEntry.descriptor;
    
    ((UILabel *)[cell viewWithTag:CELL_CREATED_TAG]).text = [NSString stringWithFormat:@"%@", reportEntry.created.description];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Core Data

- (CAReportCategory *)fetchReportCategoryById:(NSString *)reportCategoryId
{
    NSFetchRequest *fetchRequest = [[CAReportCategoryService shared] reportCategoryById:reportCategoryId];
    NSError *error;
    NSArray *fetchedResults = [[CAObjectStore shared].context executeFetchRequest:fetchRequest error:&error];
    CAReportCategory *reportCategory = [fetchedResults lastObject];
    return reportCategory;
}


@end
