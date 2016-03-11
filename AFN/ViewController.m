//
//  ViewController.m
//  AFN
//
//  Created by 杨帅 on 15/8/31.
//  Copyright (c) 2015年 ys. All rights reserved.
//

#import "ViewController.h"
#import "YFLRequestData.h"
#import "interface.h"
@interface ViewController ()

@end

@implementation ViewController

#pragma mark - ViewController Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //请求数据
    [self _requestData];

}//视图加载

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}//视图卸载


#pragma mark - Private Methods
- (void)_requestData
{
    
  //  http://api.halo365.cn/v0?moment/max/0/min/0/uuid/72muax/
 //请求参数
    
    /**
     *  这个字典就是你需要往后台传的字典参数
     */
    NSMutableDictionary *params = [
                                  @{@"max":@0,
                                    @"min" :@0,
                                    @"uuid":@"72muax"
                                    }
                                   mutableCopy
                                   ];
    
    [YFLRequestData requestURL:listData
                    httpMethod:@"GET"
                        params:params
                          file:nil
                       success:^(id data) {
                           
        NSString *jsonString = [[NSString alloc]
                                initWithData:data
                                encoding:NSUTF8StringEncoding];
                           
                           NSLog(@"成功返回json%@",jsonString);
                       }
                          fail:^(NSError *error) {
                NSLog(@"错误本身:%@ 错误原因:%@ 错误描述%@",
                error,
                error.localizedRecoverySuggestion,
                error.localizedDescription);
                              
                          }];
    
}//请求数据



@end
