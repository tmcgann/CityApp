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
        
        // Add toolbar with back, forward, action buttons
//        self.toolbar = [[UIToolbar alloc] init];
//        self.toolbarItems
//        [self.view addSubview:self.toolbar];
        
//        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        UIToolbar *toolbar = [[UIToolbar alloc] init];
        self.toolbar = [[UIToolbar alloc] init];
//        [self.navigationController setToolbarHidden:NO animated:YES];
//        [self.navigationController.toolbar setBarStyle:UIBarStyleBlackOpaque];
        self.backButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self     action:@selector(onToolbarTapped:)];
        self.forwardButton = [[UIBarButtonItem alloc] initWithTitle:@"forward" style:UIBarButtonItemStylePlain target:self     action:@selector(onToolbarTapped:)];
        NSArray *toolbarItems = [NSArray arrayWithObjects:self.backButton, self.forwardButton, nil];
//        [self.navigationController setToolbarItems:toolbarItems animated:NO];
        [self setToolbar:self.toolbar];
        [self setToolbarItems:toolbarItems];
        [self.toolbar setItems:toolbarItems animated:NO];
    }
    return self;
}

- (void)initWebView
{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    self.webView.autoresizesSubviews = YES;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    [self.webView setDelegate:self];
    
//    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 504)];
    self.view.frame = CGRectMake(0, 64, 320, 504);
    [self.view addSubview:self.webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSURL *url = [NSURL URLWithString:self.url];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:requestObj];
//    backButton.enabled = NO;
//    forwardButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *) portal {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading...";
    hud.dimBackground = YES;
    
    //    UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    //    UIBarButtonItem *actItem = [[UIBarButtonItem alloc] initWithCustomView:actInd];
    //    self.navigationItem.rightBarButtonItem = actItem;
    //    [actInd startAnimating];
    
    //    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
//    self.navigationItem.rightBarButtonItem = nil;
//    [actInd stopAnimating];

//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

//    backButton.enabled = (self.webView.canGoBack);
//    forwardButton.enabled = (self.webView.canGoForward);
}

@end
