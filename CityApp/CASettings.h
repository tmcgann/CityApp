//
//  CASettings.h
//  CityApp
//
//  Created by Taylor McGann on 2/24/13.
//  Copyright (c) 2013 Taylor McGann. All rights reserved.
//

#import <Foundation/Foundation.h>

// City/State/Country Details
#define CITY_LATITUDE 40.244288
#define CITY_LONGITUDE -111.658516

#define CITY @"Provo"
#define STATE @"Utah"
#define STATE_ABBREVIATION @"UT"
#define STATE_ABBREVIATION_CAPITALIZED @"Ut"


// External API
#define SERVER_URL @"http://taumu.com"
#define IMAGE_CONTROLLER_PATH @"/fetch/fetch/"


// UI
#define GLOBAL_BACKGROUND_IMAGE @"bg.png"
#define GLOBAL_NAVBAR_IMAGE @"navbar.png"
#define HOME_NAVBAR_IMAGE @"navbar-logo.png"
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


// MapKit values
#define PRIMARY_ADDRESS_DICTIONARY_KEY_FOR_ADDRESS @"Street"
#define SECONDARY_ADDRESS_DICTIONARY_KEY_FOR_ADDRESS @"Name"
#define INDETERMINABLE_ADDRESS_STRING @"Indeterminable"