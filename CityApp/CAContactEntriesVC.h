//
//  CAContactEntriesVC.h
//  CityApp
//
//  Created by Taylor McGann on 2/2/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAContactCategory.h"

@interface CAContactEntriesVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *contactCategoryIcon;
@property (strong, nonatomic) IBOutlet UITextView *contactCategoryDescription;
@property (strong, nonatomic) CAContactCategory *contactCategory;

@end
