//
//  CANewReportReporterDetailTVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/27/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CANewReportReporterDetailTVC.h"
#import "CANewReportVC.h"
#import "CASettings.h"

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
    
    [self populateFieldsWithReporterInfo];
}

- (void)populateFieldsWithReporterInfo
{
    // Get reporter info from NSUserDefaults
    NSDictionary *reporterInfo = [[NSUserDefaults standardUserDefaults] objectForKey:REPORTER_INFO_DICT_KEY];
    if (reporterInfo) {
        self.firstNameField.text = [reporterInfo valueForKey:REPORTER_FIRST_NAME_KEY];
        self.lastNameField.text = [reporterInfo valueForKey:REPORTER_LAST_NAME_KEY];
        self.emailAddressField.text = [reporterInfo valueForKey:REPORTER_EMAIL_ADDRESS_KEY];
        self.twitterHandleField.text = [reporterInfo valueForKey:REPORTER_TWITTER_HANDLE_KEY];
        self.phoneNumberField.text = [reporterInfo valueForKey:REPORTER_PHONE_NUMBER_KEY];
    }
}

- (void)saveReporterInfo
{
    // Build a dictionary of the reporter info
    NSMutableDictionary *reporterInfo = [NSMutableDictionary dictionaryWithCapacity:5];
    [reporterInfo setValue:self.firstNameField.text forKey:REPORTER_FIRST_NAME_KEY];
    [reporterInfo setValue:self.lastNameField.text forKey:REPORTER_LAST_NAME_KEY];
    [reporterInfo setValue:self.emailAddressField.text forKey:REPORTER_EMAIL_ADDRESS_KEY];
    [reporterInfo setValue:self.twitterHandleField.text forKey:REPORTER_TWITTER_HANDLE_KEY];
    [reporterInfo setValue:self.phoneNumberField.text forKey:REPORTER_PHONE_NUMBER_KEY];
    
    // Save to NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:[reporterInfo copy] forKey:REPORTER_INFO_DICT_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateReportEntryData
{
    NSArray *viewControllers = [self.navigationController viewControllers];
    NSUInteger previousViewControllerIndex = viewControllers.count - 2;
    CANewReportVC *newReportVC = (CANewReportVC *)[viewControllers objectAtIndex:previousViewControllerIndex];
    newReportVC.reportReporterInfo = [[NSUserDefaults standardUserDefaults] objectForKey:REPORTER_INFO_DICT_KEY];
}

- (IBAction)savePressed:(UIBarButtonItem *)sender
{
    [self saveReporterInfo];
    [self updateReportEntryData];
    [self.navigationController popViewControllerAnimated:YES];
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
