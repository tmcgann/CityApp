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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Background image
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:GLOBAL_BACKGROUND_IMAGE]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:GLOBAL_NAVBAR_IMAGE] forBarMetrics:UIBarMetricsDefault];
    
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
