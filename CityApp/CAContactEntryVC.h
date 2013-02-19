//
//  CAContactEntryVC.h
//  CityApp
//
//  Created by Taylor McGann on 2/3/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CAContactEntry.h"

typedef enum {
	/** Makes a phone call */
	CAContactEntryVCActionPhone,
    /** Makes a phone call */
	CAContactEntryVCActionFax,
	/** Takes a user to the mail app */
	CAContactEntryVCActionEmail,
    /** Takes the user to the map tab and drops a pin on the map */
	CAContactEntryVCActionAddress,
	/** Takes the user to the website via UIWebView */
	CAContactEntryVCActionURL
} DirectoryStoreViewAction;

@interface CAContactEntryVC : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) CAContactEntry *contactEntry;
@property (strong, nonatomic) IBOutlet UIImageView *contactEntryIcon;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;

@end
