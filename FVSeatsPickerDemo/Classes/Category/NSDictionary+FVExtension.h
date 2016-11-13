//
//  NSDictionary+FVExtension.h
//  FVSeatsPicker
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FVExtension)

- (NSString*)stringForKey: (NSString*)key;
- (NSArray*)arrayForKey: (NSString*)key;
- (NSDictionary*)dictionaryForKey: (NSString*)key;
- (NSNumber*)numberForKey:(NSString*)key;

- (int)intValueForKey:(NSString*)key;
- (int64_t)int64ValueForKey:(NSString*)key;
- (BOOL)boolValueForKey:(NSString*)key;
- (NSInteger)integerValueForKey:(NSString*)key;

@end
