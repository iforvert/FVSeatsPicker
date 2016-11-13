//
//  UIColor+FVExtension.m
//  FVSeatsPicker
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//

#import "UIColor+FVExtension.h"

@implementation UIColor (FVExtension)

+ (instancetype)r:(uint8_t)r g:(uint8_t)g b:(uint8_t)b a:(uint8_t)a
{
    return [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a/255.];
}

+ (instancetype)rgba:(NSUInteger)rgba
{
    return [self r:(rgba >> 24)&0xFF g:(rgba >> 16)&0xFF b:(rgba >> 8)&0xFF a:rgba&0xFF];
}


@end
