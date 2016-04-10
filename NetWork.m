//
//  NetWork.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "NetWork.h"

static NetWork *netWork;

@implementation NetWork



+(NetWork *)shareNetworking{
    
    @synchronized(self){
        
        if (netWork == nil) {
            
            netWork = [[NetWork alloc]init];
            
        }
        
        return netWork;
    }
}

//GET异步请求 返回DATA

-(void)netWorkGetWithURL:(NSString *)urlString Block:(NetWorkBlock)block{
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        block(data);
//        
//    }];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            //没有错误，返回正确；
            block(data);
            
        }else{
            //出现错误；
        }
        
    }];
    [dataTask resume];
}

@end

