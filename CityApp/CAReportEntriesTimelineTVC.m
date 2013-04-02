//
//  CAReportEntriesTVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/7/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

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
    
    // Load objects via Core Data/RestKit
    [[CAReportEntryService shared] loadStore];
    [self setupFetchedResultsController];
    
    // Load images for all the report entries
#warning FIXME: This doesn't work the first time the app loads. It is data dependent.
//    [self fetchPictures];
}

- (void)setupFetchedResultsController
{
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[[CAReportEntryService shared] allReportEntries] managedObjectContext:[CAObjectStore shared].context sectionNameKeyPath:nil cacheName:nil];
}

- (void)fetchPictures
{
#warning FIXME: This code may NOT be thread safe if TMImageSync is busy elsewhere and you change the remoteURL!!! Might be best NOT to use a shared instance
    TMImageSync *imageSync = [[TMImageSync alloc] init];
    imageSync.remoteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, IMAGE_CONTROLLER_PATH]];
    
    NSArray *reportEntries = self.fetchedResultsController.fetchedObjects;
    NSUInteger count = reportEntries.count;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply(count, queue, ^(size_t i) {
        CAReportEntry *reportEntry = [reportEntries objectAtIndex:i];
        CAReportPicture *reportPicture = [reportEntry.reportPictures lastObject];
        if (reportPicture && ![@"" isEqualToString:reportPicture.filename]) {
            [imageSync fetchImageWithoutSync:reportPicture.filename];
        }
    });

    // An alternate way of doing it
//    for (CAReportEntry *reportEntry in reportEntries) {
//        dispatch_async(queue, ^(){
//            CAReportPicture *reportPicture = [reportEntry.reportPictures lastObject];
//            if (reportPicture && ![@"" isEqualToString:reportPicture.filename]) {
//                [imageSync fetchImageWithoutSync:reportPicture.filename];
//            }
//        });
//    }
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
    CAReportCategory *reportCategory = [[CAReportCategoryService shared] reportCategoryById:reportEntry.reportCategoryId];
//    CAReportPicture *reportPicture = [reportEntry.reportPictures lastObject];
//    ((UIImageView *)[cell viewWithTag:CELL_PICTURE_TAG]).image = [UIImage imageWithContentsOfFile:reportPicture.filename];
    NSString *thumbnailBase64 = reportEntry.thumbnailData;
    NSData *thumbnailData = [NSData dataFromBase64String:thumbnailBase64];
    UIImage *reportPictureThumbnail = [UIImage imageWithData:thumbnailData];
    
    ((UIImageView *)[cell viewWithTag:CELL_PICTURE_TAG]).image = reportPictureThumbnail;
//    ((UILabel *)[cell viewWithTag:CELL_CATEGORY_TAG]).text = reportEntry.reportCategory.name;
    ((UILabel *)[cell viewWithTag:CELL_CATEGORY_TAG]).text = reportEntry.reportCategoryId;
    ((UILabel *)[cell viewWithTag:CELL_ADDRESS_TAG]).text = reportEntry.address;
    ((UILabel *)[cell viewWithTag:CELL_DESCRIPTOR_TAG]).text = reportEntry.descriptor;
    ((UILabel *)[cell viewWithTag:CELL_CREATED_TAG]).text = [NSString stringWithFormat:@"%@", reportEntry.created.description];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
