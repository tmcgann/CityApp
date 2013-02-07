//
//  CAContactEntryVC.h
//  CityApp
//
//  Created by Taylor McGann on 2/3/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAContactEntry.h"

@interface CAContactEntryVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CAContactEntry *contactEntry;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;

@end
