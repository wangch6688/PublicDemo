//
//  MTDataService.h
//  DataService
//
//  Created by mR yang on 16/5/11.
//  Copyright © 2016年 mR yang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(id data);
@interface MTDataService : NSObject

// GET
+ (void)GETWithURLString:(NSString *)url
                  params:(NSMutableDictionary *)params
             headrFields:(NSMutableDictionary *)header
        complectionBlock:(CompletionBlock)complectionBlock;

/**
 *url
 *params post请求设置请求体的参数
 *header 请求头
 *bodyData上传图片或者文件的时候 需要转化的data
 *complectionBlock完成时回调block
 */

+ (void)GETWithURLString:(NSString *)url
                  params:(NSMutableDictionary *)params
             headrFields:(NSMutableDictionary *)header
             accessToken:(NSString *)accessToken
        complectionBlock:(CompletionBlock)complectionBlock;
// POST
+ (void)POSTWithURLString:(NSString *)url
                   params:(NSMutableDictionary *)params
              headrFields:(NSMutableDictionary *)header
                 bodyData:(NSData *)bodyData
         complectionBlock:(CompletionBlock)complectionBlock;

// GET+POST
+ (void)requestWithURLString:(NSString *)url
                  httpMethod:(NSString *)method
                      params:(NSMutableDictionary *)params
                 headrFields:(NSMutableDictionary *)header
                    bodyData:(NSData *)bodyData
            complectionBlock:(CompletionBlock)complectionBlock;

@end
