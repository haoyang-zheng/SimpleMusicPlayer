//
//  NetWork.h
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetWorkBlock)(id object);

@interface NetWork : NSObject


+(NetWork *)shareNetworking;

//GET异步请求

-(void)netWorkGetWithURL:(NSString *)urlString Block:(NetWorkBlock)block;

@end

