//
//  CAHomeVC.h
//  CityApp
//
//  Created by Taylor McGann on 2/16/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAReportEntriesVC.h"

@interface CAHomeVC : UIViewController

@property (nonatomic) CAReportEntriesVC *reportEntriesSegmentsVC;

- (IBAction)touchUpInsideReportsButton:(UIButton *)sender;

@end
