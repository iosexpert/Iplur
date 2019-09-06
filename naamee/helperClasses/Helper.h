//
//  Helper.h
//  browze
//
//  Created by HashBrown Systems on 26/03/15.
//  Copyright (c) 2015 Hashbrown Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "Constants.h"

@interface Helper : NSObject<UIAlertViewDelegate>

+(BOOL)isLocationServiceEnabled;
+(BOOL) isInternetConnected;
+(BOOL)isNotificationServicesEnabled;
+(NSString *)calculatePlainTextTimeFromSeconds:(float)seconds;
+(NSString *)generateTempID;
+(NSString *)getNotificationToken;
+(NSString *)getIMEINumber;
+(NSNumber *)getNumberFromString:(NSString *)strValue;

+(float)fontSizeForCurrentViewHeight:(float)viewHeight baseHeight:(float)baseHeight baseFontSize:(float)baseFontSize;
+(float)calculateViewWidthForView:(float)viewHeight baseWidth:(float)baseWidth baseFontSize:(float)baseFontSize;

+(void)getProfilePictureFromUrl:(NSString *)url coordinates: (NSString *)coordinates onCompletion:(void(^)(UIImage *image))completion;

+(void)saveAllValuesToUserDefault:(NSDictionary *)completed;
+(void)saveData:(NSDictionary *)dict;

+(CGRect)calculateHeightForText:(NSString *)text fontName:(NSString *)fontName fontSize:(float)fontSize maximumWidth:(float)width;
+(CGRect)calculateHeightForAttributedText:(NSAttributedString *)text font:(UIFont *)font maximumWidth:(float)width;

+(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message;

+ (UIColor *) colorFromHexString:(NSString *)hexString;
+ (NSString *)getDateStringFromDate:(NSDate *)date;
+ (NSDate *)getDateFromDateString:(NSString *)dateStr;
+(BOOL)validateEmailWithString:(NSString*)emailmatch;
+(BOOL)validateUsernameWithString:(NSString*)username;
+(BOOL)removeAllKeysFromUserDefaults;

// indicator
+(void)showIndicatorWithText:(NSString *)text inView:(UIView *)view;
+(void)hideIndicatorFromView:(UIView *)view;

@end
