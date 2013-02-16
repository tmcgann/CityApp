//
//  CPDirectoryTVC.h
//  CityApp
//
//  Created by Taylor McGann on 1/20/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CACoreDataTVC.h"

@interface CAContactCategoriesTVC : CACoreDataTVC

@property (nonatomic, strong) UIManagedDocument *contactCategoriesDatabase;
@property (nonatomic, strong) NSOrderedSet *contactCategories;

@end
