//
//  Helper.m
//  browze
//
//  Created by HashBrown Systems on 26/03/15.
//  Copyright (c) 2015 Hashbrown Systems. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(BOOL)isLocationServiceEnabled
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+(void)saveAllValuesToUserDefault:(NSDictionary *)dic
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dataDic=[dic objectForKey:@"data"];
    if ([dataDic objectForKey:@"Users"])
    {
        NSDictionary *completed=[dataDic objectForKey:@"Users"];
        NSDictionary *countDic=[dataDic objectForKey:@"Count"];
        
        [defaults setObject:[completed objectForKey:@"id"] forKey:@"MyId"];
        [defaults setObject:[completed objectForKey:@"email"] forKey:@"email"];
        [defaults setObject:[completed objectForKey:@"fullname"] forKey:@"name"];
        [defaults setObject:[completed objectForKey:@"username"] forKey:@"username"];
        [defaults setObject:[completed objectForKey:@"a_type"] forKey:@"type"];
        [defaults setObject:[countDic objectForKey:@"followers"] forKey:@"followers"];
        [defaults setObject:[countDic objectForKey:@"following"] forKey:@"following"];
    }
    else
    {
        [defaults setObject:[dataDic objectForKey:@"id"] forKey:@"MyId"];
        [defaults setObject:[dataDic objectForKey:@"email"] forKey:@"email"];
        [defaults setObject:[dataDic objectForKey:@"fullname"] forKey:@"name"];
        [defaults setObject:[dataDic objectForKey:@"username"] forKey:@"username"];
        [defaults setObject:[dataDic objectForKey:@"a_type"] forKey:@"type"];
        [defaults setObject:@"0" forKey:@"followers"];
        [defaults setObject:@"0" forKey:@"following"];
    }
    [defaults synchronize];
}

+(void)saveData:(NSDictionary *)dict
{
    [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"fullname"] forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"username"] forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"email"] forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"website"] forKey:@"website"];
    [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"description"] forKey:@"additionalInfo"];
    [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"coverPic"] forKey:@"coverPic"];
    if ([[dict objectForKey:@"profile_pic"] isKindOfClass:[NSNull class]])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"profilePic"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"profile_pic"] forKey:@"profilePic"];
    }
    
    if ([[dict objectForKey:@"phone"] isKindOfClass:[NSNull class]])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"phone"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[dict objectForKey:@"phone"] forKey:@"phone"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[[dict objectForKey:@"privatePost"] boolValue]] forKey:@"isPostsArePrivate"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[[dict objectForKey:@"commentOnPost"] boolValue]] forKey:@"isCommentAllowed"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[[dict objectForKey:@"sharePost"] boolValue]] forKey:@"isRepeatAllowed"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[[dict objectForKey:@"viewYourAction"] boolValue]] forKey:@"isPostLikedPrivate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)getProfilePictureFromUrl:(NSString *)url coordinates: (NSString *)coordinates onCompletion:(void(^)(UIImage *profileImage))completion
{
    /*NSLog(@"Image Name: %@", url);
    if ([url isKindOfClass:[NSNull class]])
    {
        UIImage *image =[UIImage imageNamed:@"default_profile.jpeg"];
        completion(image);
    }
    else
    {
        NSString *imageUrl;
        if (type==kProfilePictureUrl)
        {
            imageUrl=PROFILE_PICTURE_URL;
        }
        else if (type==kGroupPictureUrl)
        {
            imageUrl=GROUP_IMAGE_URL;
        }
        FileHandler *saveImage=[[FileHandler alloc]init];
        id smallPicture=[saveImage checkSmallProfilePictureExist:url];
        if ([smallPicture isKindOfClass:[NSString class]])
        {
            UIImage *image=[UIImage imageWithContentsOfFile:smallPicture];
            completion(image);
        }
        else
        {
            NSString *imageFullpath;
            if ([coordinates isKindOfClass:[NSNull class]] || [coordinates length]==0)
            {
                imageFullpath=[NSString stringWithFormat:@"%@%@%@",BASE_URL,imageUrl,url];
            }
            else
            {
                imageFullpath=[NSString stringWithFormat:@"%@%@%@?crop=%@",BASE_URL,imageUrl,url, coordinates];
            }
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:imageFullpath]
                                  options:0
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     // progression tracking code
                                 }
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                    if (image) {
                                        // do something with image
                                        NSData *data=UIImageJPEGRepresentation(image, 1);
                                        [saveImage saveSmallPicturesWithData:data withName:url];
                                        completion(image);
                                    }
                                }];
        }
    }*/
}

+(NSNumber *)getNumberFromString:(NSString *)strValue
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterNoStyle;
    NSNumber *number = [f numberFromString:[NSString stringWithFormat:@"%@", strValue]];
    return number;
}

+(NSString *)getDateStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSLog(@"GMT date: %@", dateString);
    return dateString;
}

+ (NSDate *)getDateFromDateString:(NSString *)dateStr
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    return date;
}

+(NSString *)calculatePlainTextTimeFromSeconds:(float)seconds
{
    NSString *time;
    if (seconds>3599)
    {
        long hours=seconds/3600;
        long remaingMinute=seconds-(hours*3600);
        long minutes=remaingMinute/60;
        long lastSeconds=remaingMinute-(minutes*60);
        
        NSString *hourText=(hours>9?[NSString stringWithFormat:@"%lu", hours]:[NSString stringWithFormat:@"0%lu", hours]);
        
        NSString *minuteText=(minutes>9?[NSString stringWithFormat:@"%lu", minutes]:[NSString stringWithFormat:@"0%lu", minutes]);
        
        NSString *secondsText=(lastSeconds>9?[NSString stringWithFormat:@"%lu", lastSeconds]:[NSString stringWithFormat:@"0%lu", lastSeconds]);
        
        time=[NSString stringWithFormat:@"%@:%@:%@", hourText, minuteText, secondsText];
    }
    else if (seconds>60)
    {
        long minutes=seconds/60;
        long lastSeconds=seconds-(minutes*60);
        
        NSString *minuteText=(minutes>9?[NSString stringWithFormat:@"%lu", minutes]:[NSString stringWithFormat:@"0%lu", minutes]);
        
        NSString *secondsText=(lastSeconds>9?[NSString stringWithFormat:@"%lu", lastSeconds]:[NSString stringWithFormat:@"0%lu", lastSeconds]);
        
        time=[NSString stringWithFormat:@"%@:%@", minuteText, secondsText];
    }
    else
    {
        long sec=seconds;
        NSString *secondsText=(seconds>9?[NSString stringWithFormat:@"%ld", sec]:[NSString stringWithFormat:@"0%ld", sec]);
        
        time=[NSString stringWithFormat:@"00:%@", secondsText];
    }
    return time;
}

+(NSString *)generateTempID
{
    double sec=([NSDate timeIntervalSinceReferenceDate] * 1000);
    NSString *tempMessageId=[NSString stringWithFormat:@"%@%0.f", [[NSUserDefaults standardUserDefaults] objectForKey:@"MyId"], sec];
    return tempMessageId;
}

+(float)fontSizeForCurrentViewHeight:(float)viewHeight baseHeight:(float)baseHeight baseFontSize:(float)baseFontSize
{
    float heightRatio=viewHeight/baseHeight;
    float fontSize=heightRatio*baseFontSize;
    return fontSize;
}

+(float)calculateViewWidthForView:(float)viewHeight baseWidth:(float)baseWidth baseFontSize:(float)baseFontSize
{
    float heightRatio=viewHeight/baseWidth;
    float fontSize=heightRatio*baseFontSize;
    return fontSize;
}

+(BOOL)isNotificationServicesEnabled
{
    BOOL isEnabled = NO;
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]){
        UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (!notificationSettings || (notificationSettings.types == UIUserNotificationTypeNone)) {
            isEnabled = NO;
        } else {
            isEnabled = YES;
        }
    } else {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (types & UIRemoteNotificationTypeAlert) {
            isEnabled = YES;
        } else{
            isEnabled = NO;
        }
    }
    return isEnabled;
}

+(NSString *)getNotificationToken
{
    NSString *hexToken;
    if([self isNotificationServicesEnabled]==YES)
    {
        NSLog(@"Notification services is enabled");
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        hexToken=[defaults objectForKey:@"token"];
        if (!hexToken)
        {
            hexToken=@"1234567890";
        }
    }
    else
    {
        NSLog(@"Notification services is disabled");
        hexToken=@"1234567890";
    }
    NSLog(@"Token Data %@",hexToken);
    return hexToken;
}

+(NSString *)getIMEINumber
{
    UIDevice *myDevice = [UIDevice currentDevice];
    NSUUID *identifier = myDevice.identifierForVendor;
    NSString *imei=identifier.UUIDString;
    return imei;
}

+(CGRect)calculateHeightForText:(NSString *)text fontName:(NSString *)fontName fontSize:(float)fontSize maximumWidth:(float)width
{
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    
    return rect;
} //CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];

+(CGRect)calculateHeightForAttributedText:(NSAttributedString *)text font:(UIFont *)font maximumWidth:(float)width
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return rect;
}

+ (UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}

+(BOOL)removeAllKeysFromUserDefaults
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"MyId"];
    [defaults removeObjectForKey:@"isLoggedIn"];
    [defaults removeObjectForKey:@"isOnline"];
    [defaults removeObjectForKey:@"MyPic"];
    [defaults removeObjectForKey:@"coordinates"];
    [defaults removeObjectForKey:@"MyStatus"];
    [defaults removeObjectForKey:@"profile_picture"];
    [defaults removeObjectForKey:@"SenderId"];
    [defaults removeObjectForKey:@"Nickname"];
    [defaults removeObjectForKey:@"Phone"];  //
    [defaults removeObjectForKey:@"IsPhonePublic"];
    [defaults removeObjectForKey:@"isAvailableToChat"];
    [defaults removeObjectForKey:@"isLocationShared"];
    [defaults removeObjectForKey:@"twitterId"];
    [defaults removeObjectForKey:@"twitter_imageUrl"];
    [defaults removeObjectForKey:@"twitter_username"];
    [defaults removeObjectForKey:@"isVerified"];
    [defaults removeObjectForKey:@"emailId"];
    [defaults removeObjectForKey:@"TwitterTokenSecret"];
    [defaults removeObjectForKey:@"TwitterToken"];
    [defaults removeObjectForKey:@"SavedProfileImage"];
    [defaults removeObjectForKey:@"social_media"];
    [defaults removeObjectForKey:@"social_id"];
    [defaults removeObjectForKey:@"IsUsernameChangedOnce"];
    [defaults removeObjectForKey:@"AuthenticatedStatus"];
    [defaults removeObjectForKey:@"IsEmailVerified"]; //
    [defaults removeObjectForKey:@"isPasswordEmpty"];
    [defaults removeObjectForKey:@"last_sync_time"];
    [defaults removeObjectForKey:@"hidden_activities_last_sync_time"]; //
    
    [defaults removeObjectForKey:@"isAllNotifications"];
    [defaults removeObjectForKey:@"isAllMessageNotifications"];
    [defaults removeObjectForKey:@"isNewMessageNotifications"];
    [defaults removeObjectForKey:@"isFriendMessageNotifications"];
    [defaults removeObjectForKey:@"isPostMessageNotifications"];
    [defaults removeObjectForKey:@"isFriendRequestsNotifications"];
    
    [defaults synchronize];
    return YES;
}

#pragma mark -- Internet Connectivity

+(BOOL) isInternetConnected
{
    // called after network status changes
    Reachability* internetReachable = [Reachability reachabilityForInternetConnection];;
    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            // NSLog(@"The internet is down.");
            return NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            // NSLog(@"The internet is working via WIFI.");
            return YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            // NSLog(@"The internet is working via WWAN.");
            return YES;
            
            break;
        }
    }
}

#pragma mark -- View Indicator

+(void)showIndicatorWithText:(NSString *)text inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
}

+(void)hideIndicatorFromView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
