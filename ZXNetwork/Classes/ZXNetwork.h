//
//  ZXNetwork.h
//  AFNetworking
//
//  Created by 谢泽鑫 on 2018/4/23.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@class ZXNetwork;

/**
 * GET：获取资源，不会改动资源
 * POST：创建记录
 * PATCH：改变资源状态或更新部分属性
 * PUT：更新全部属性
 * DELETE：删除资源
 */
typedef NS_ENUM(NSUInteger, HTTPMethod) {
    HTTPMethodGET,
    HTTPMethodPOST,
    HTTPMethodPUT,
    HTTPMethodPATCH,
    HTTPMethodDELETE,
};



#define ZXNetworkManager ([ZXNetwork defaultManager])

@interface ZXNetwork : NSObject
+ (nonnull instancetype)defaultManager;

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
                                            failure:(nullable void (^)(NSString * _Nullable errorMessage))failure;
@end
