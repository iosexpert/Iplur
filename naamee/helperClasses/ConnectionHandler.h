//
//  ConnectionHandler.h
//  browzeApp
//
//  Created by HashBrown Systems on 14/03/14.
//  Copyright (c) 2014 hashbrown. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Constants.h"

@interface ConnectionHandler : NSObject
{
    AFHTTPSessionManager *manager;
}

@property (strong, nonatomic) AFHTTPSessionManager *manager;

+(ConnectionHandler *)getSharedInstance;
-(void)stopAllRequests;
- (void)cancelAllHTTPOperationsWithPath:(NSString *)path;

-(void)jsonGETData:(NSString *)url onCompletion:(void(^)(id completed))completion;
-(void)jsonPostData:(NSString *)url : (NSDictionary *)params onCompletion:(void(^)(id completed))completion;
-(void)jsonPostDataHTTP:(NSString *)url : (NSDictionary *)params onCompletion:(void(^)(id completed))completion;
-(void)jsonPostDataForImage:(NSString *)url : (NSDictionary *)params :(NSData *)imageData onCompletion:(void(^)(id completed))completion;
-(void)jsonGETDataHTTP:(NSString *)url onCompletion:(void(^)(id completed))completion;
-(void)jsonGETDataHTTPWithDictionary:(NSString *)url params:(NSDictionary *)dic onCompletion:(void(^)(id completed))completion;

-(void)jsonGETDataForMap:(NSString *)url onCompletion:(void(^)(id completed))completion;
@end
