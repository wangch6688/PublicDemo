//
//  MTDataService.m
//  DataService
//
//  Created by mR yang on 16/5/11.
//  Copyright © 2016年 mR yang. All rights reserved.
//

#import "MTDataService.h"
#define Boundary @"--aGHJF653ds---"

@implementation MTDataService

// GET
+ (void)GETWithURLString:(NSString *)url
                  params:(NSMutableDictionary *)params
             headrFields:(NSMutableDictionary *)header
        complectionBlock:(CompletionBlock)complectionBlock {

  //  容错处理防止传了一个空对象
  if (!params) {
    params = [NSMutableDictionary dictionary];
  }
  
  

  NSMutableString *bodyStr = [NSMutableString string];

  for (NSString *key in params) {

    id value = [params valueForKey:key];

    NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@", key, value];

    [bodyStr appendFormat:@"%@&", keyValueStr];
  }
  //  去掉最后一个&
  if (bodyStr.length != 0) {
    [bodyStr deleteCharactersInRange:NSMakeRange(bodyStr.length - 1, 1)];
  }

  //  urlStr + contactStr = fullStr   不要忘了？
  NSString *fullStr = [NSString stringWithFormat:@"%@?%@", url, bodyStr];

  //  1.url
  NSURL *fullURL = [NSURL URLWithString:fullStr];

  //  2.request
  NSMutableURLRequest *request =
      [NSMutableURLRequest requestWithURL:fullURL
                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                          timeoutInterval:120];

  //  (1)设置请求方式
  [request setHTTPMethod:@"GET"];

  //  (2)设置请求头
  //  [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
  if (header) {
    [request setAllHTTPHeaderFields:header];
  }

  //  3.session
  NSURLSession *session = [NSURLSession sharedSession];

  //  4.发送请求
  NSURLSessionDataTask *task = [session
      dataTaskWithRequest:request
        completionHandler:^(NSData *_Nullable data,
                            NSURLResponse *_Nullable response,
                            NSError *_Nullable error) {

          if (error) {
            NSLog(@"error = %@", error);
            //      如果出错直接返回
            return;
          }

          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
          
          id jsonData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
          

          if (httpResponse.statusCode == 200) {

            dispatch_sync(dispatch_get_main_queue(), ^{

              //        回调block
              complectionBlock(jsonData);
            });
          }
        }];

  //  5.执行任务
  [task resume];
}

/**
 *url
 *params post请求设置请求体的参数
 *header 请求头
 *bodyData上传图片或者文件的时候 需要转化的data
 *complectionBlock完成时回调block
 */


+(void)GETWithURLString:(NSString *)url params:(NSMutableDictionary *)params headrFields:(NSMutableDictionary *)header accessToken:(NSString *)accessToken complectionBlock:(CompletionBlock)complectionBlock{
  //  容错处理防止传了一个空对象
  if (!params) {
    params = [NSMutableDictionary dictionary];
  }
  
  if (accessToken.length==0) {
    return;
  }
  [params setObject:accessToken forKey:@"access_token"];
  
  
  NSMutableString *bodyStr = [NSMutableString string];
  
  for (NSString *key in params) {
    
    id value = [params valueForKey:key];
    
    NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@", key, value];
    
    [bodyStr appendFormat:@"%@&", keyValueStr];
  }
  //  去掉最后一个&
  if (bodyStr.length != 0) {
    [bodyStr deleteCharactersInRange:NSMakeRange(bodyStr.length - 1, 1)];
  }
  
  //  urlStr + contactStr = fullStr   不要忘了？
  NSString *fullStr = [NSString stringWithFormat:@"%@?%@", url, bodyStr];
  
  //  1.url
  NSURL *fullURL = [NSURL URLWithString:fullStr];
  
  //  2.request
  NSMutableURLRequest *request =
  [NSMutableURLRequest requestWithURL:fullURL
                          cachePolicy:NSURLRequestUseProtocolCachePolicy
                      timeoutInterval:120];
  
  //  (1)设置请求方式
  [request setHTTPMethod:@"GET"];
  
  //  (2)设置请求头
  //  [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
  if (header) {
    [request setAllHTTPHeaderFields:header];
  }
  
  //  3.session
  NSURLSession *session = [NSURLSession sharedSession];
  
  //  4.发送请求
  NSURLSessionDataTask *task = [session
                                dataTaskWithRequest:request
                                completionHandler:^(NSData *_Nullable data,
                                                    NSURLResponse *_Nullable response,
                                                    NSError *_Nullable error) {
                                  
                                  if (error) {
                                    NSLog(@"error = %@", error);
                                    //      如果出错直接返回
                                    return;
                                  }
                                  
                                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                  
                                  id jsonData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                  
                                  
                                  if (httpResponse.statusCode == 200) {
                                    
                                    dispatch_sync(dispatch_get_main_queue(), ^{
                                      
                                      //        回调block
                                      complectionBlock(jsonData);
                                    });
                                  }
                                }];
  
  //  5.执行任务
  [task resume];
}

// POST
+ (void)POSTWithURLString:(NSString *)url
                   params:(NSMutableDictionary *)params
              headrFields:(NSMutableDictionary *)header
                 bodyData:(NSData *)bodyData
         complectionBlock:(CompletionBlock)complectionBlock {
  //  1.url
  NSURL *fullURL = [NSURL URLWithString:url];

  //  2.request
  NSMutableURLRequest *request =
      [NSMutableURLRequest requestWithURL:fullURL
                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                          timeoutInterval:120];

  //  (1)设置请求方式
  [request setHTTPMethod:@"POST"];

  //  (2)设置请求头
  //  [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
  if (header) {
    [request setAllHTTPHeaderFields:header];
  }

  //  容错处理防止传了一个空对象
  if (!params) {
    params = [NSMutableDictionary dictionary];
  }
  
 
  
  // -------------------- 没有复杂数据 ---------------------

  if (!bodyData) {
    //  (3)请求体
    //  params {key1:value1,key2:value2...}
    //  转化成字符串
    //  key1=value1&key2=value2

    NSMutableString *bodyStr = [NSMutableString string];

    for (NSString *key in params) {

      id value = [params valueForKey:key];

      NSString *keyValueStr = [NSString stringWithFormat:@"%@=%@", key, value];

      [bodyStr appendFormat:@"%@&", keyValueStr];
    }
    //  去掉最后一个&
    if (bodyStr.length != 0) {
      [bodyStr deleteCharactersInRange:NSMakeRange(bodyStr.length - 1, 1)];
    }

    //  转化成data类型
    [request setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
  } else {

    //  ---------------------  有复杂数据  ---------------------

//    添加请求头
    NSString *headrStr = [NSString
        stringWithFormat:@"multipart/form-data; charset=utf-8;boundary=%@",
                         Boundary];

    [request addValue:headrStr forHTTPHeaderField:@"Content-Type"];

//    获取请求体
    NSData *data = [self buildBodyDataWithParams:params bodyData:bodyData];

    [request setHTTPBody:data];
  }

  //  3.session
  NSURLSession *session = [NSURLSession sharedSession];

  //  4.发送请求
  NSURLSessionDataTask *task = [session
      dataTaskWithRequest:request
        completionHandler:^(NSData *_Nullable data,
                            NSURLResponse *_Nullable response,
                            NSError *_Nullable error) {

          if (error) {
            NSLog(@"error = %@", error);
            //      如果出错直接返回
            return;
          }

          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
          id jsonData=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
          
          if (httpResponse.statusCode == 200) {

            dispatch_sync(dispatch_get_main_queue(), ^{

              //        回调block
              complectionBlock(jsonData);
            });
          }
        }];

  //  5.执行任务
  [task resume];
}

+ (NSData *)buildBodyDataWithParams:(NSMutableDictionary *)params
                           bodyData:(NSData *)formData {

  //按照请求体的格式，拼接请求体
  //开头的bodyStr + 图片数据 + 结束str
  NSMutableData *bodyData = [NSMutableData data];

  //(1)bodyStr
  NSMutableString *bodyStr = [NSMutableString string];
  for (NSString *key in params) {
    id value = [params objectForKey:key];

    [bodyStr appendFormat:@"--%@\r\n", Boundary]; // \n 换行，\r 切换到行首
    [bodyStr appendFormat:@"Content-Disposition: form-data; name=\"%@\"", key];
    [bodyStr appendFormat:@"\r\n\r\n"];
    [bodyStr appendFormat:@"%@\r\n", value];
  }

  //.pic ---- 图片
  [bodyStr appendFormat:@"--%@\r\n", Boundary]; // \n 换行，\r 切换到行首
  [bodyStr
      appendFormat:
          @"Content-Disposition: form-data; name=\"pic\"; filename=\"file\""];
  [bodyStr appendFormat:@"\r\n"];
  [bodyStr appendFormat:@"Content-Type: application/octet-stream"];
  [bodyStr appendFormat:@"\r\n\r\n"];

  NSData *startData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
  [bodyData appendData:startData];

  //(2)pic
  //图片数据添加
  [bodyData appendData:formData];

  //(3)--str--
  NSString *endStr = [NSString stringWithFormat:@"\r\n--%@--\r\n", Boundary];
  NSData *endData = [endStr dataUsingEncoding:NSUTF8StringEncoding];
  [bodyData appendData:endData];

  return bodyData;
}

// GET+POST
+ (void)requestWithURLString:(NSString *)url
                  httpMethod:(NSString *)method
                      params:(NSMutableDictionary *)params
                 headrFields:(NSMutableDictionary *)header
                    bodyData:(NSData *)bodyData
            complectionBlock:(CompletionBlock)complectionBlock {
  
//  GET
  if ([method isEqualToString:@"GET"]) {
    
    [self GETWithURLString:url params:params headrFields:header complectionBlock:^(id data) {
      
      complectionBlock(data);
      
    }];
  }else if ([method isEqualToString:@"POST"]){//POST
    
    [self POSTWithURLString:url params:params headrFields:header bodyData:bodyData complectionBlock:^(id data) {
      
      complectionBlock(data);
    }];
  }
  
}
@end
