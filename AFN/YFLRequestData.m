//
//  YFLRequestData.m
//  AFN
//
//  Created by 杨帅 on 15/8/31.
//  Copyright (c) 2015年 YS . All rights reserved.
//

#import "YFLRequestData.h"
#import "AFNetworking.h"

static NSString *const networkNss  = @"http://api.halo365.cn"  ; //外网接口
static NSString *const IntranetNss = @"http://192.168.31.2:9002";  //内网接口
/**
 *  也可以写成你们的长接口方式后加/v0
 */

@implementation YFLRequestData



+ (void)requestURL:(NSString *)requestURL
        httpMethod:(NSString *)method
            params:(NSMutableDictionary *)parmas
              file:(NSDictionary *)files
           success:(void (^)(id data))success
              fail:(void (^)(NSError *error))fail
{
    
    //1.构造操作对象管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //新加的https协议
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = securityPolicy;
    
    manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:networkNss]];
    
//    
    //2.设置解析格式，默认json
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =
    [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    //3.判断网络状况
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        
        
        
        if (status == AFNetworkReachabilityStatusNotReachable)
        {
            
            //showAlert
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络链接错误,请检查网络链接" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil]show];
            
            //NSLog(@"没有网络");
            
            return;
            
        }else if (status == AFNetworkReachabilityStatusUnknown){
            
            //NSLog(@"未知网络");
            
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            
            //NSLog(@"WiFi");
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            
            //NSLog(@"手机网络");
        }
        
    }];

    // 4.get请求
    if ([[method uppercaseString] isEqualToString:@"GET"]) {
        
        [manager GET:requestURL
          parameters:parmas
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
        
                 if (success != nil)
                 {
                     success(responseObject);
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 if (fail != nil) {
                     fail(error);
                 }
             }];

        
        // 5.post请求不带文件 和post带文件
    }else if ([[method uppercaseString] isEqualToString:@"POST"]) {
        
        if (files == nil) {
            
            [manager POST:requestURL
               parameters:parmas
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
   
                      if (success) {
                          success(responseObject);
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      
       
                      if (fail) {
                          fail(error);
                      }
                      
                  }];
            
        } else {
            
            [manager POST:requestURL
               parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                   
                   for (id key in files) {
                       
                       id value = files[key];
                       
                       [formData appendPartWithFileData:value
                                                   name:key
                                               fileName:@"header.png"
                                               mimeType:@"image/png"];
                   }
                   
               } success:^(AFHTTPRequestOperation *operation, id responseObject) {
   
                   if (success) {
                       success(responseObject);
                   }
                   
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
                   if (fail) {
                       fail(error);
                   }
                   
               }];
        }
    }
}

@end
