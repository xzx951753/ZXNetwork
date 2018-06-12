//
//  ZXNetwork.m
//  AFNetworking
//
//  Created by 谢泽鑫 on 2018/4/23.
//

#import "ZXNetwork.h"
#import "AFNetworking/AFNetworking.h"

//全局静态变量
static ZXNetwork* ZXNetworkDefaultManager = nil;

@interface ZXNetwork()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation ZXNetwork

+ (nonnull instancetype)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !ZXNetworkDefaultManager ){
            ZXNetworkDefaultManager = [[ZXNetwork alloc] init];
        }
    });
    return ZXNetworkDefaultManager;
}

- (instancetype)init{
    if ( self = [super init] ){
        self.sessionManager = [AFHTTPSessionManager manager];
        //设置请求以及相应的序列化器
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        //设置超时时间
        self.sessionManager.requestSerializer.timeoutInterval = 10.0;
        //设置相应内容的类型
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/javascript",@"text/html",nil];

    }
    return self;
}


- (void)failureNotificationHandle:(NSNotification*)noti{
    
}




/**
    常用网络请求方式
    @param requestMethod 请求方试
    @param serverUrl 服务器地址
    @param apiPath 方法的链接
    @param parameters 参数
    @param progress 进度
    @param success 成功
    @param failure 失败
    @return return value description
 */
- (nullable NSURLSessionDataTask*)sendRequestMethod:(HTTPMethod)requestMethod
                                          serverUrl:(nonnull NSString*)serverUrl
                                            apiPath:(nullable NSString*)apiPath
                                         parameters:(nullable id)parameters
                                           progress:(nullable void (^)(NSProgress * _Nullable progress))progress
                                            success:(nullable void (^)(BOOL isSuccess,id _Nullable responseObject))success
                                            failure:(nullable void (^)(NSString * _Nullable errorMessage))failure{
    NSString * requestPath = [serverUrl stringByAppendingPathComponent:apiPath];
    NSURLSessionDataTask * task = nil;
    switch (requestMethod) {
        case HTTPMethodGET:
        {
            task = [self.sessionManager GET:requestPath parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ( success ){
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if ( failure ){
                    failure([self failHandleWithErrorResponse:error task:task]);
                }else{
                    [self failHandleWithErrorResponse:error task:task];
                }
            }];
        }
            break;
        case HTTPMethodPOST:
        {
            task = [self.sessionManager POST:requestPath parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ( success ){
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if ( failure ){
                    failure([self failHandleWithErrorResponse:error task:task]);
                }else{
                    [self failHandleWithErrorResponse:error task:task];
                }
            }];
        }
            break;
        case HTTPMethodPUT:
        {
            task = [self.sessionManager PUT:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ( success ){
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if ( failure ){
                    failure([self failHandleWithErrorResponse:error task:task]);
                }else{
                    [self failHandleWithErrorResponse:error task:task];
                }
            }];
        }
            break;
        case HTTPMethodPATCH:
        {
            task = [self.sessionManager PATCH:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ( success ){
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if ( failure ){
                    failure([self failHandleWithErrorResponse:error task:task]);
                }else{
                    [self failHandleWithErrorResponse:error task:task];
                }
            }];
        }
            break;
        case HTTPMethodDELETE:
        {
            task = [self.sessionManager DELETE:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ( success ){
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if ( failure ){
                    failure([self failHandleWithErrorResponse:error task:task]);
                }else{
                    [self failHandleWithErrorResponse:error task:task];
                }
            }];
        }
    }
    return task;
}



#pragma mark 报错信息
/**
 处理报错信息
 
 @param error AFN返回的错误信息
 @param task 任务
 @return description
 */
- (NSString *)failHandleWithErrorResponse:( NSError * _Nullable )error task:( NSURLSessionDataTask * _Nullable )task {
    __block NSString *message = nil;
    // 这里可以直接设定错误反馈，也可以利用AFN 的error信息直接解析展示
    NSData *afNetworking_errorMsg = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
//    NSLog(@"afNetworking_errorMsg == %@",[[NSString alloc]initWithData:afNetworking_errorMsg encoding:NSUTF8StringEncoding]);
    if (!afNetworking_errorMsg) {
        message = @"网络连接失败";
        //发送通知，告知网络连接失败
        [[NSNotificationCenter defaultCenter] postNotificationName:ZXNetworkDidFailureNotification object:nil];
    }
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger responseStatue = response.statusCode;
    if (responseStatue >= 500) {  // 网络错误
        message = @"服务器维护升级中,请耐心等待";
    } else if (responseStatue >= 400) {
        // 错误信息
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:afNetworking_errorMsg options:NSJSONReadingAllowFragments error:nil];
        message = responseObject[@"error"];
    }
//    NSLog(@"error == %@",error);
    return message;
}
@end
