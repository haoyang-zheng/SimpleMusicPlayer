//
//  NSString+GetWidHeight.h
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (GetWidHeight)


//自定义方法  用来获取字符串

+(CGFloat)getHeightWithString:(NSString *)string Width:(CGFloat)Width FonSize:(CGFloat)fontsize;

//自定义方法  用来获取字符串显示的宽度

+(CGFloat)getWidthWithstirng:(NSString*)string Width:(CGFloat)width FonSize:(CGFloat)fontsize;

@end
