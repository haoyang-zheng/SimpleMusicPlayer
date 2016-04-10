//
//  NSString+GetWidHeight.m
//  MusicPlayer
//
//  Created by haoyang_zheng on 16/4/9.
//  Copyright © 2016年 DAC. All rights reserved.
//

#import "NSString+GetWidHeight.h"

@implementation NSString (GetWidHeight)

#pragma mark++自定义方法  用来获取字符串显示的高度

+(CGFloat)getHeightWithString:(NSString *)string Width:(CGFloat)Width FonSize:(CGFloat)fontsize
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]};
    
    
    CGRect rect=[string boundingRectWithSize:CGSizeMake(Width, 1000000000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    
    return rect.size.height;
    
}

+(CGFloat)getWidthWithstirng:(NSString *)string Width:(CGFloat)width FonSize:(CGFloat)fontsize
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]};
    
    CGRect rect=[string boundingRectWithSize:CGSizeMake(width, 1000000000) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    
    return rect.size.width;
}

@end