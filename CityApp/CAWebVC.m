//
//  CAWebVC.m
//  CityApp
//
//  Created by Taylor McGann on 2/20/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import "CAWebVC.h"
#import "MBProgressHUD.h"

@interface CAWebVC ()

@end

@implementation CAWebVC

- (id)init
{
    self = [super init];
    if (self) {
        // Set modal transition style
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        // Add web view
        [self initWebView];
    }
    return self;
}

- (void)initWebView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
//    self.webView.autoresizesSubviews = YES;
//    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    [self.webView setDelegate:self];
    
//    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 504)];
//    self.view.frame = CGRectMake(0, 64, 320, 514);
    [self.view addSubview:self.webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add toolbar with back, forward, action buttons
    self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(onToolbarTapped:)];
    self.backButton.enabled = NO;
    self.forwardButton = [[UIBarButtonItem alloc] initWithTitle:@"forward" style:UIBarButtonItemStylePlain target:self action:@selector(onToolbarTapped:)];
    self.forwardButton.enabled = NO;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    [self setToolbarItems:@[self.backButton, self.forwardButton, flexibleSpace] animated:NO];
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlack];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
//    NSURL *url = [NSURL URLWithString:self.url];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:requestObj];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *) portal {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"Loading...";
//    hud.dimBackground = YES;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *actItem = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    self.navigationItem.rightBarButtonItem = actItem;
    [self.activityIndicator startAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    self.navigationItem.rightBarButtonItem = nil;
    [self.activityIndicator stopAnimating];

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    self.backButton.enabled = (self.webView.canGoBack);
    self.forwardButton.enabled = (self.webView.canGoForward);
}

@end
