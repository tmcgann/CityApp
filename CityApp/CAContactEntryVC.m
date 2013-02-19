//
//  CAContactEntryVC.m
//  CityApp
//
//  Created by Taylor McGann on 2/3/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAContactEntryVC.h"
#import "NSString+URLEncode.h"

#define kTV_CELL_TITLE @"title"
#define kTV_CELL_DETAIL @"detail"

@interface CAContactEntryVC ()

@property (strong, nonatomic) NSMutableArray *tableSections;

@end

@implementation CAContactEntryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set navbar title
    [self.navigationItem setTitle:@"Details"];
    
    // Set contact name icon and label
    NSArray *iconComponents = [self.contactEntry.icon componentsSeparatedByString:@"."];
    if (iconComponents.count == 2) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:iconComponents[0] ofType:iconComponents[1]]];
        self.contactEntryIcon.image = image;
    }
    self.contactNameLabel.text = self.contactEntry.name;
    
    // initialize mutable array
    self.tableSections = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![self.contactEntry.phoneNumber isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"Phone", kTV_CELL_DETAIL:self.contactEntry.phoneNumber}];
    }
    if (![self.contactEntry.fax isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"Fax", kTV_CELL_DETAIL:self.contactEntry.fax}];
    }
    if (![self.contactEntry.email isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"Email", kTV_CELL_DETAIL:self.contactEntry.email}];
    }
    if (![self.contactEntry.addressOne isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"Address", kTV_CELL_DETAIL:self.contactEntry.addressOne}];
    }
    if (![self.contactEntry.url isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"URL", kTV_CELL_DETAIL:self.contactEntry.url}];
    }
    if (![self.contactEntry.hours isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"Hours", kTV_CELL_DETAIL:self.contactEntry.hours}];
    }
    if (![self.contactEntry.description isEqualToString:@""]) {
        [self.tableSections addObject:@{kTV_CELL_TITLE:@"Description", kTV_CELL_DETAIL:self.contactEntry.descriptor}];
    }
    
    return self.tableSections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
    static NSString *CellIdentifier = @"ContactDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *contactDetailMap = [self.tableSections objectAtIndex:(NSUInteger)indexPath.row];
    cell.textLabel.text = [contactDetailMap objectForKey:kTV_CELL_TITLE];
    cell.detailTextLabel.text = [contactDetailMap objectForKey:kTV_CELL_DETAIL];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning BUG:Dysfunctional if rows/data is missing
    switch (indexPath.row) {
        case CAContactEntryVCActionPhone:
        {
            NSString *cleanedString = [[self.contactEntry.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
            NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", escapedPhoneNumber]];
            [[UIApplication sharedApplication] openURL:telURL];
            break;
        }
        case CAContactEntryVCActionFax:
        {
            NSString *cleanedString = [[self.contactEntry.fax componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
            NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", escapedPhoneNumber]];
            [[UIApplication sharedApplication] openURL:telURL];
            break;
        }
        case CAContactEntryVCActionEmail:
        {
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
                controller.mailComposeDelegate = self;
                [controller setToRecipients:@[self.contactEntry.email]];
                [controller setSubject:@"Greetings"];
                [controller setMessageBody:[NSString stringWithFormat:@"%@:", self.contactEntry.name] isHTML:NO];
                if (controller)
                    [self presentViewController:controller animated:YES completion:nil];
            } else {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsupported Device"
//                                                                message:@"Sorry, your device does not support the mail composer."
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"OK"
//                                                      otherButtonTitles:nil];
//                [alert show];
            
                // Check to see if device supports network connectivity first
                #warning Incomplete method implementation--check for network reachability.
                NSString *url = [NSString stringWithFormat:@"mailto:%@?subject=Greetings&body=%@:", self.contactEntry.email, [self.contactEntry.name URLEncode]];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
            }
            break;
        }
        case CAContactEntryVCActionAddress:
        {
            DLog(@"CAContactEntryVCActionAddress");
            DLog(@"Will load maps and drop pin...some day.");
            break;
        }
        case CAContactEntryVCActionURL:
        {
//            StoreWebsiteViewController *vc = [[StoreWebsiteViewController alloc] initWithNibName:@"StoreWebsiteViewController" bundle:nil website:[NSURL URLWithString:self.store.website]];
//            [self.tabBarController.tabBar setHidden:YES];
//            [self.navigationController setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:vc animated:YES];
            DLog(@"CAContactEntryVCActionURL");
            DLog(@"Will load web view withe site...some day.");
            break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail" message:@"On it's way!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    #warning Incomplete method implementation--error handling needed.
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
