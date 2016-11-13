//
//  NSDictionary+FVExtension.m
//  FVSeatsPicker
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//

#import "NSDictionary+FVExtension.h"

@implementation NSDictionary (FVExtension)


- (NSArray *)arrayForKey:(NSString *)key
{
    id ret = [self objectForKey:key];
    if ([ret isKindOfClass:[NSArray class]])
    {
        return ret;
    }
    return nil;
}

- (NSDictionary*)dictionaryForKey:(NSString *)key
{
    id ret = [self objectForKey:key];
    if ([ret isKindOfClass:[NSDictionary class]])
    {
        return ret;
    }
    return nil;
}

- (NSString*)stringForKey:(NSString*)key
{
    id ret = [self objectForKey:key];
    if ([ret isKindOfClass:[NSString class]])
    {
        return ret;
    }
    else if (ret)
    {
        return [NSString stringWithFormat:@"%@", ret];
    }
    return @"";
}

- (NSNumber *)numberForKey:(NSString *)key
{
    id ret = [self objectForKey:key];
    if ([ret isKindOfClass:[NSNumber class]])
    {
        return ret;
    }
    else if ([ret isKindOfClass:[NSString class]])
    {
        static NSNumberFormatter* formatter;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
        });
        return [formatter numberFromString:ret];
    }
    
    return nil;
}

- (int)intValueForKey: (NSString*)key
{
    return [self numberForKey:key].intValue;
}

- (int64_t)int64ValueForKey: (NSString*)key
{
    return [self numberForKey:key].longLongValue;
}

- (BOOL)boolValueForKey: (NSString*)key
{
    return [self numberForKey:key].boolValue;
}

- (NSInteger)integerValueForKey:(NSString *)key
{
    return [self numberForKey:key].integerValue;
}

@end
