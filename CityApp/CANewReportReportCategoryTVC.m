//
//  CANewReportReportCategoryTVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/28/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CANewReportReportCategoryTVC.h"
#import "CANewReportVC.h"
#import "CAReportCategoryService.h"
#import "CAReportCategory.h"
#import "CASettings.h"

@interface CANewReportReportCategoryTVC ()

@property (weak, nonatomic) UITableViewCell *checkedCell;

@end

@implementation CANewReportReportCategoryTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:GLOBAL_BACKGROUND_IMAGE]];
	
    // Load objects via Core Data/RestKit
    [[CAReportCategoryService shared] loadStore];
    [self setupFetchedResultsController];
}

- (void)setupFetchedResultsController
{
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[[CAReportCategoryService shared] allReportCategories] managedObjectContext:[CAObjectStore shared].context sectionNameKeyPath:nil cacheName:nil];
}

- (void)updateCheckedCell:(UITableViewCell *)selectedCell
{
    self.checkedCell.accessoryType = UITableViewCellAccessoryNone;
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.checkedCell = selectedCell;
}

- (void)updateReportEntryData
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    NSUInteger previousViewControllerIndex = viewControllers.count - 2;
    CANewReportVC *newReportVC = (CANewReportVC *)[viewControllers objectAtIndex:previousViewControllerIndex];
    newReportVC.reportCategory = self.selectedReportCategory;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    static NSString *CellIdentifier = @"ReportCategoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CAReportCategory *reportCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = reportCategory.name;
    
    if ([reportCategory isEqual:self.selectedReportCategory]) {
        [self updateCheckedCell:cell];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedReportCategory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self updateReportEntryData];
    
    [self updateCheckedCell:[tableView cellForRowAtIndexPath:indexPath]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
