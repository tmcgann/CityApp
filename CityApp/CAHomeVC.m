//
//  CAHomeVC.m
//  CityApp
//
//  Created by Taylor McGann on 2/16/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAHomeVC.h"
#import "TMImageSync.h"
#import "CASettings.h"

@interface CAHomeVC ()

@end

@implementation CAHomeVC

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
	// Do any additional setup after loading the view.
    
    // Set the back button title (for next screen)
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    // Setup the TMImageSync shared instance
    TMImageSync *sharedSync = [TMImageSync sharedSync];
    sharedSync.remoteURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", SERVER_URL, IMAGE_CONTROLLER_PATH]];
}

- (IBAction)touchUpInsideReportsButton:(UIButton *)sender
{
    [self presentReportsView];
}

- (void)presentReportsView
{
    self.reportEntriesSegmentsVC = [[CAReportEntriesVC alloc] init];
    [self presentViewController:self.reportEntriesSegmentsVC animated:YES completion:nil];
}

@end
