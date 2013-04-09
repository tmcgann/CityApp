//
//  CASettings.h
//  CityApp
//
//  Created by Taylor McGann on 2/24/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>

// City
#define CITY @"Provo"

// External API
#define SERVER_URL @"http://taumu.com"
#define IMAGE_CONTROLLER_PATH @"/fetch/fetch/"

// UI
#define GLOBAL_BACKGROUND_IMAGE @"bg.png"
#define GLOBAL_NAVBAR_IMAGE @"navbar-blue.png"
#define GLOBAL_DATE_FORMAT @"d MMMM yyyy - h:mm a"

// Image Attributes
#define REPORT_ENTRY_THUMBNAIL_CORNER_RADIUS 3.0f
#define LANDSCAPE_IMAGE_SCALED_WIDTH 1920
#define LANDSCAPE_IMAGE_SCALED_HEIGHT 1440
#define PORTRAIT_IMAGE_SCALED_WIDTH 1440
#define PORTRAIT_IMAGE_SCALED_HEIGHT 1920

// NSUserDefaults Keys
#define REPORTER_INFO_DICT_KEY @"reporterInfo"
#define REPORTER_FIRST_NAME_KEY @"firstName"
#define REPORTER_LAST_NAME_KEY @"lastName"
#define REPORTER_EMAIL_ADDRESS_KEY @"emailAddress"
#define REPORTER_TWITTER_HANDLE_KEY @"twitterHandle"
#define REPORTER_PHONE_NUMBER_KEY @"phoneNumber"
#define REPORTER_INFO_DEFAULT_NAME @"Anonymous"