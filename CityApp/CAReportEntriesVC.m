//
//  CAReportEntriesSegmentedVC.m
//  CityApp
//
//  Created by Taylor McGann on 3/17/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAReportEntriesVC.h"
#import "CAReportEntriesTimelineTVC.h"
#import "CAReportEntriesMapVC.h"
#import "CAReportEntriesCollectionVC.h"

@interface CAReportEntriesVC ()

@end

@implementation CAReportEntriesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSegmentedControl];
    [self indexDidChangeForSegmentedControl:self.segmentedControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.segmentedControl) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (UIViewController *)viewControllerForSegmentIndex:(NSInteger)index {
    UIViewController *vc;
    switch (index) {
        case 0:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportEntriesTimeline"];
            break;
        case 1:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportEntriesCollection"];
            break;
        case 2:
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportEntriesMap"];
            break;
    }
    return vc;
}

- (void)setupSegmentedControl
{
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Timeline", @"Collection", @"Map"]];
    self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(indexDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *segmentedControlWrapper = [[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    [self setToolbarItems:@[flexibleSpace, segmentedControlWrapper, flexibleSpace] animated:NO];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
    UIViewController *newVC = [self viewControllerForSegmentIndex:index];
    UIViewController *currentVC = [self.childViewControllers lastObject];
    
    [self addChildViewController:newVC];
    [self transitionFromViewController:currentVC toViewController:newVC duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [currentVC.view removeFromSuperview];
        newVC.view.frame = self.view.bounds;
        [self.view addSubview:newVC.view];
    } completion:^(BOOL finished) {
        [newVC didMoveToParentViewController:self];
        [currentVC removeFromParentViewController];
    }];
}

@end
