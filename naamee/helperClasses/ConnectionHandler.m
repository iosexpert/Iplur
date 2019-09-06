//
//  ConnectionHandler.m
//  browze
//
//  Created by HashBrown Systems on 14/03/14.
//  Copyright (c) 2014 hashbrown. All rights reserved.
//

#import "ConnectionHandler.h"
#import "AppDelegate.h"

@implementation ConnectionHandler
@synthesize manager;

static ConnectionHandler *sharedInstance = nil;

#pragma mark -- Initialization

+(ConnectionHandler *)getSharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance initializeConnection];
    }
    return sharedInstance;
}

-(void)initializeConnection
{
    if (manager==nil)
    {
        manager = [AFHTTPSessionManager manager];
    }
}

#pragma mark -- Cancel Requests

-(void)stopAllRequests
{
    [manager.operationQueue cancelAllOperations];
}

- (void)cancelAllHTTPOperationsWithPath:(NSString *)path
{
    [[manager session] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        [self cancelTasksInArray:dataTasks withPath:path];
        [self cancelTasksInArray:uploadTasks withPath:path];
        [self cancelTasksInArray:downloadTasks withPath:path];
    }];
}

- (void)cancelTasksInArray:(NSArray *)tasksArray withPath:(NSString *)path
{
    for (NSURLSessionTask *task in tasksArray) {
        NSRange range = [[[[task currentRequest]URL] absoluteString] rangeOfString:path];
        if (range.location != NSNotFound)
        {
            NSLog(@"------ Request canceled --------");
            [task cancel];
        }
    }
}

#pragma mark -- Server Requests

-(void)jsonGETData:(NSString *)url onCompletion:(void(^)(id completed))completion
{
    [self initializeConnection];
    url=[NSString stringWithFormat:@"%@%@", BASE_URL,url];
    NSLog(@"Token %@",url);
    
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"AfNetworkResponse %@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            completion(responseObject);
        }
        else
        {
            NSError* error;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:&error];
            NSLog(@"AfNetworkResponse: %@", json);
            completion(json);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failer %@",error);
        NSDictionary *dic=error.userInfo;
        if (![[dic objectForKey:@"NSLocalizedDescription"] isEqualToString:@"cancelled"])
        {
            completion(error);
        }
        else
        {
            NSLog(@"No response");
        }
    }];
}

-(void)jsonPostData:(NSString *)url : (NSDictionary *)params onCompletion:(void(^)(id completed))completion
{
    [self initializeConnection];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    
    url=[NSString stringWithFormat:@"%@%@", BASE_URL,url];
  
    [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        @try {
            NSLog(@"AfNetworkResponse: %@", responseObject);
            completion(responseObject);
        }
        @catch (NSException *exception) {
            NSLog(@"Exception: %@", exception);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"Error %@",error);
        NSDictionary *dic=error.userInfo;
        if (![[dic objectForKey:@"NSLocalizedDescription"] isEqualToString:@"cancelled"])
        {
            completion(error);
        }
        else
        {
            NSLog(@"No response");
        }
    }];
}

-(void)jsonPostDataHTTP:(NSString *)url : (NSDictionary *)params onCompletion:(void(^)(id completed))completion
{
    [self initializeConnection];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    url=[NSString stringWithFormat:@"%@%@", BASE_URL,url];
    
    [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        NSLog(@"AfNetworkResponse: %@", json);
        completion(json);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error %@",error);
        NSDictionary *dic=error.userInfo;
        if (![[dic objectForKey:@"NSLocalizedDescription"] isEqualToString:@"cancelled"])
        {
            completion(error);
        }
        else
        {
            NSLog(@"No response");
        }
    }];
}

-(void)jsonPostDataForImage:(NSString *)url : (NSDictionary *)params : (NSData *)imageData onCompletion:(void(^)(id completed))completion
{
    [self initializeConnection];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:5*60];
    
    url=[NSString stringWithFormat:@"%@%@", BASE_URL,url];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"AfNetworkResponse: %@", responseObject);
        completion(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error %@",error);
        NSDictionary *dic=error.userInfo;
        if (![[dic objectForKey:@"NSLocalizedDescription"] isEqualToString:@"cancelled"])
        {
            completion(error);
        }
        else
        {
            NSLog(@"No response");
        }
    }];
}

-(void)jsonGETDataHTTP:(NSString *)url onCompletion:(void(^)(id completed))completion
{
    [self initializeConnection];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSLog(@"Time Out Interval %f",[manager.requestSerializer timeoutInterval]);
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    url=[NSString stringWithFormat:@"%@%@", BASE_URL,url];
    
    [manager.requestSerializer setValue:[defaults objectForKey:@"auth_token"] forHTTPHeaderField:@"TOKEN"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", [defaults objectForKey:@"MyId"]] forHTTPHeaderField:@"UserId"];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"AfNetworkResponse %@",responseObject);
        completion(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failer %@",error);
        NSDictionary *dic=error.userInfo;
        if (![[dic objectForKey:@"NSLocalizedDescription"] isEqualToString:@"cancelled"])
        {
            completion(error);
        }
        else
        {
            NSLog(@"No response");
        }
    }];
}

-(void)jsonGETDataHTTPWithDictionary:(NSString *)url params:(NSDictionary *)dic onCompletion:(void(^)(id completed))completion
{
    [self initializeConnection];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //NSLog(@"Time Out Interval %f",[manager.requestSerializer timeoutInterval]);
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    url=[NSString stringWithFormat:@"%@%@", BASE_URL,url];
    
    [manager.requestSerializer setValue:[defaults objectForKey:@"auth_token"] forHTTPHeaderField:@"TOKEN"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@", [defaults objectForKey:@"MyId"]] forHTTPHeaderField:@"UserId"];
    [manager GET:url parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"AfNetworkResponse %@",responseObject);
        completion(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failer %@",error);
        NSDictionary *dic=error.userInfo;
        if (![[dic objectForKey:@"NSLocalizedDescription"] isEqualToString:@"cancelled"])
        {
            completion(error);
        }
        else
        {
            NSLog(@"No response");
        }
    }];
}

-(void)jsonGETDataForMap:(NSString *)url onCompletion:(void(^)(id completed))completion
{
    [self initializeConnection];
    
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"AfNetworkResponse %@",responseObject);
        completion(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"failer %@",error);
        NSDictionary *dic=error.userInfo;
        if (![[dic objectForKey:@"NSLocalizedDescription"] isEqualToString:@"cancelled"])
        {
            completion(error);
        }
        else
        {
            NSLog(@"No response");
        }
    }];
}

@end
