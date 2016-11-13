//
//  FVSeatsViewController.h
//  FVSeatsPicker
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, District){
    DistrictA,
    DistrictB,
};

@interface FVSeatsViewController : UIViewController

@property (nonatomic, assign) District district;

@end
