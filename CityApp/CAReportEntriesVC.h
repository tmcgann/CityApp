//
//  CAReportEntriesSegmentedVC.h
//  CityApp
//
//  Created by Taylor McGann on 3/17/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CACoreDataTVC.h"
#import "CANewReportVC.h"

@class CAReportEntriesTimelineTVC, CAReportEntriesMapVC, CAReportEntriesCollectionVC;

@interface CAReportEntriesVC : UIViewController <CAReportEntriesRefreshDelegate>

@property (nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic) CAReportEntriesTimelineTVC *timelineTVC;
@property (nonatomic) CAReportEntriesMapVC *mapVC;
@property (nonatomic) CAReportEntriesCollectionVC *collectionVC;
@property (nonatomic) NSArray *viewControllers;

@end
