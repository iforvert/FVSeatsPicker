//
//  FVSeatItem.m
//  FVCinemaSeatsView
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//

#import "FVSeatItem.h"

@implementation FVSeatItem

- (NSString *)description
{
    NSArray *properties = @[@"seatId",@"seatName",@"price",@"col",@"row",@"seatStatus",@"coordinateX",@"coordinateY"];
    NSDictionary *propertiesDict = [self dictionaryWithValuesForKeys:properties];
    return [NSString stringWithFormat:@"<%@: %p> %@",self.class, self, propertiesDict];
}

@end
