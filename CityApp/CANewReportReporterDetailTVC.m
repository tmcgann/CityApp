//
//  CANewReportReporterDetailTVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/27/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CANewReportReporterDetailTVC.h"

@interface CANewReportReporterDetailTVC ()

@end

@implementation CANewReportReporterDetailTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    NSInteger nextTag = textField.tag + 1;
//    // Try to find next responder
//    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
//    if (nextResponder) {
//        // Found next responder, so set it.
//        [nextResponder becomeFirstResponder];
//    } else {
//        // Not found, so remove keyboard.
//        [textField resignFirstResponder];
//    }
//    return NO; // We do not want UITextField to insert line-breaks.
    
    NSInteger nextTag = textField.tag + 1;
    
    // Try to find next responder
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    UITableView *table = (UITableView *)cell.superview;
    UITableViewCell *nextCell = (UITableViewCell *)[table viewWithTag:nextTag];
    NSArray *cellContextSubviews = [[[nextCell subviews] objectAtIndex:1] subviews];
    UITextField *field = (UITextField *)[cellContextSubviews lastObject];
    UIResponder *nextResponder = field;
    
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so hide keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

@end
