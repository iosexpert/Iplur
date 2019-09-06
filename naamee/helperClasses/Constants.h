//
//  Constants.h
//  browze
//
//  Created by HashBrown Systems on 27/11/14.
//  Copyright (c) 2014 Hashbrown Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONSUMER_KEY @"ltXj0e79SpitoGjyVgDUxGLXT"
#define CONSUMER_SECRET_KEY @"0saHb6aVT288r6NpmmnLZRY72oIP8SkClx1NDaBafP6y6yZdXs"

/*********************** BASE URL ****************************/

#define BASE_URL @"http://naamee.com/api/"
#define SERVER_URL @"http://naamee.com/"

#define BASE_API_URL @"http://browze.co/api/"

/*********************** COMMON URL ****************************/

// chat images
#define SEND_IMAGE_URL @"UploadForAllfile.aspx"

// profile picture
#define UPLOAD_PROFILE_PICTURE_URL @"UploadProfilePicture.aspx"
#define THUMBNAIL_IMAGE_URL @"api/webroot/img/300x300/"
#define COMPLETE_IMAGE_URL @"webservices/"

//fonts
#define Helvetica_REGULAR @"Helvetica Neue"
#define RALEWAY_LIGHT @"Raleway-Light"
#define RALEWAY_BOLD @"Raleway-SemiBold"
#define RobotoCondensedLight @"RobotoCondensed-Light"
#define RobotoCondensedRegular @"RobotoCondensed-Regular"
#define AristaLight @"[z] Arista light"

//colors
#define APP_COLOR [UIColor colorWithRed:43/255.0f green:49/255.0f blue:53/255.0f alpha:1.0f]
#define BASE_HEIGHT 667

//AlertView Titles
#define ALERT @"Alert"
#define OOPS @"Oops"

// AlertView Error Messages
#define LOGIN_ERROR @"You seem to be offline on this device. Would you like to login?"
#define SERVER_ERROR @"Server not responding. Please try again!"
#define INTERNET_ERROR @"Please check your internet connection!"
#define IMAGE_UPLOAD_ERROR @"Error in saving image. Please try again."

/****************************** ONCANOE APIs FOR V_0.7 *****************************/

#define SERVER_URL_USERS @"api/User/"

@interface Constants : NSObject

@end
