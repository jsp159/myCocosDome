//
//  HttpTool.m
//  RSDoor
//
//  Created by 杨继雷 on 15/7/29.
//  Copyright (c) 2015年 qixiekeji. All rights reserved.
//

#import "HttpTool.h"

#define TIMEOUTVALUE 20 //网络请求超时时间

@implementation HttpTool
+ (void)GET:(NSString *)url parameters:(NSDictionary *)params andJsessionid:(NSString *)jsessionid success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];//返回的是json文件
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.requestSerializer.timeoutInterval = TIMEOUTVALUE;
    
//    NSString * firstJsessionid = GET_FIRST_JSESSIONIDOThER;
//    [session.requestSerializer setValue:firstJsessionid forHTTPHeaderField:@"Cookie"];
    
    
    if (jsessionid != nil) {
        [session.requestSerializer setValue:jsessionid forHTTPHeaderField:@"Cookie"];
    }
    
//    NSString * firstJsessionid = GET_FIRST_JSESSIONIDOThER;
//    NSString * loginJsessionid = GET_LOGIN_JSESSIONID;
//    NSString * jidStr = [NSString stringWithFormat:@"%@;%@",firstJsessionid,loginJsessionid];
//    [session.requestSerializer setValue:jidStr forHTTPHeaderField:@"Cookie"];
    
    
//    NSString * singStr = [Tool createSingStr:url];
//    [session.requestSerializer setValue:singStr forHTTPHeaderField:@"sign"];
    
    [session GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"\n======================================\n");
//        NSDictionary *fields = ((NSHTTPURLResponse*)task.response).allHeaderFields;
//        //                NSLog(@"fields = %@",[fields description]);
//        NSString* dataCookie = [NSString stringWithFormat:@"%@",[[fields[@"Set-Cookie"]componentsSeparatedByString:@";"]objectAtIndex:0]];
//        NSLog(@"dataCookie ==================== %@",dataCookie);
//        NSLog(@"\n======================================\n");
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
    
}

+ (void)POST:(NSString *)url parameters:(NSDictionary *)params andJsessionid:(NSString *)jsessionid success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];//返回的是json文件
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    [session.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Contsetent-Type"];
    session.requestSerializer.timeoutInterval = TIMEOUTVALUE;
    
    if (jsessionid != nil) {
        
    }
    
//    NSString * firstJsessionid = GET_FIRST_JSESSIONIDOThER;
//    NSString * loginJsessionid = GET_LOGIN_JSESSIONID;
//    NSString * jidStr = [NSString stringWithFormat:@"%@;%@",firstJsessionid,loginJsessionid];
//    [session.requestSerializer setValue:jidStr forHTTPHeaderField:@"Cookie"];
    
//    NSString * singStr = [Tool createSingStr:url];
//    NSLog(@"======%@",singStr);
    
//    [session.requestSerializer setValue:singStr forHTTPHeaderField:@"sign"];
    
    // 2.发送请求
    [session POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"\n======================================\n");
//        NSDictionary *fields = ((NSHTTPURLResponse*)task.response).allHeaderFields;
//        //                NSLog(@"fields = %@",[fields description]);
//        NSString* dataCookie = [NSString stringWithFormat:@"%@",[[fields[@"Set-Cookie"]componentsSeparatedByString:@";"]objectAtIndex:0]];
//        NSLog(@"dataCookie ==================== %@",dataCookie);
//        
//        NSLog(@"\n======================================\n");
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}

+ (void)PUT:(NSString *)url parameters:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];//返回的是json文件
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
//    NSString * singStr = [Tool createSingStr:url];
//    [session.requestSerializer setValue:singStr forHTTPHeaderField:@"sign"];
    
    // 2.发送请求
    [session PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}
+(void)DELETE:(NSString *)url parameters:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];//返回的是json文件
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
//    NSString * singStr = [Tool createSingStr:url];
//    [session.requestSerializer setValue:singStr forHTTPHeaderField:@"sign"];
    
    // 2.发送请求
    [session DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}
+ (void)POST:(NSString *)url parameters:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];//返回的是json文件
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.requestSerializer.timeoutInterval = TIMEOUTVALUE;
    
//    NSString * singStr = [Tool createSingStr:url];
//    [session.requestSerializer setValue:singStr forHTTPHeaderField:@"sign"];
    
    // 2.发送请求
    [session POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        block(formData);
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}
+ (void)POST:(NSString *)url parameters:(NSDictionary*)params andJsessionid:(NSString *)jsessionid constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure{

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];//返回的是json文件
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    [session.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Contsetent-Type"];
    session.requestSerializer.timeoutInterval = TIMEOUTVALUE;
    
    if (jsessionid != nil) {
        
    }
    
//    NSString * firstJsessionid = GET_FIRST_JSESSIONIDOThER;
//    NSString * loginJsessionid = GET_LOGIN_JSESSIONID;
//    NSString * jidStr = [NSString stringWithFormat:@"%@;%@",firstJsessionid,loginJsessionid];
//    [session.requestSerializer setValue:jidStr forHTTPHeaderField:@"Cookie"];
    
//    NSString * singStr = [Tool createSingStr:url];
//    [session.requestSerializer setValue:singStr forHTTPHeaderField:@"sign"];
    
    // 2.发送请求
    [session POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        block(formData);
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];



}
@end
