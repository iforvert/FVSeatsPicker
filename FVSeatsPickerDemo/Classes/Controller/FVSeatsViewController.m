//
//  FVSeatsViewController.m
//  FVSeatsPicker
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//

#import "FVSeatsViewController.h"
#import "NSDictionary+FVExtension.h"
#import "UIColor+FVExtension.h"
#import "FVSeatsPicker.h"
#import "FVSeatsTitleView.h"

static NSString * const kSourceA = @"districtOne";
static NSString * const kSourceB = @"districtTwo";
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface FVSeatsViewController ()<FVSeatsPickerDelegate>

@property (nonatomic, strong) FVSeatsPicker *seatsPicker;
@property (nonatomic, strong) FVSeatsTitleView *titleView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, strong) NSArray <FVSeatItem *>* seatsInfo;
@property (nonatomic, assign) int areaId;
@property (nonatomic, strong) NSString *districtName;
@property (nonatomic, assign) int seatMaxX;
@property (nonatomic, assign) int seatMaxY;
@property (nonatomic, assign) int maxSeatNum;

@end

@implementation FVSeatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseInfo];
    [self loadData];
}

- (void)configBaseInfo
{
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    
    _titleView = ({
        FVSeatsTitleView *titleView = [FVSeatsTitleView seleSeatsTitleView];
        [self.view addSubview:titleView];
        titleView;
    });
    _titleView.frame = CGRectMake(0, 64, kScreenWidth, 120);
    _seatsPicker = ({
        FVSeatsPicker *picker = [FVSeatsPicker new];
        picker.backgroundColor = [UIColor rgba:0xF9F9F9FF];
        picker.cellSize = CGSizeMake(24, 24);
        picker.minimumZoomScale = 1;
        picker.maximumZoomScale = 2;
        picker.seatsDelegate = self;
// 你可以在这里设置图片，同时你也可以不设置FVSeatsPicker内部会自动设置默认的图片，如果设置新的图片将会采用最新设置的图片
        [picker setImage:[UIImage imageNamed:@"seat_available"] forState:UIControlStateNormal];
        [picker setImage:[UIImage imageNamed:@"seat_unavailable"] forState:UIControlStateDisabled];
        [picker setImage:[UIImage imageNamed:@"seat_selected"] forState:UIControlStateSelected];

        [self.view addSubview:picker];
        picker;
    });
    _seatsPicker.frame = CGRectMake(0, 184, kScreenWidth, kScreenHeight * 0.6);
}


- (void)loadData
{
    NSString *sourceName = self.district == DistrictA ? kSourceA : kSourceB;
    NSString *path = [[NSBundle mainBundle] pathForResource:sourceName ofType:@"plist"];
    NSDictionary *result = [NSDictionary dictionaryWithContentsOfFile:path];
    if (result)
    {
        _areaId = [result intValueForKey:@"areaid"];
        _districtName = [result stringForKey:@"name"];
        _seatMaxX = [result intValueForKey:@"x"];
        _seatMaxY = [result intValueForKey:@"y"];
        _maxSeatNum = [result intValueForKey:@"max_num"];
        NSArray *tempArray = [result arrayForKey:@"seats"];
        
        id resultData = [NSMutableArray new];
        for (NSDictionary* dict in tempArray)
        {
            if (NO == [dict isKindOfClass:[NSDictionary class]])
            {
                continue;
            }
            FVSeatItem* seatsInfo = [FVSeatItem new];
            seatsInfo.seatId = [dict intValueForKey:@"id"];
            seatsInfo.seatName = [dict stringForKey:@"name"];
            seatsInfo.price = [dict intValueForKey:@"price"];
            seatsInfo.col = [dict intValueForKey:@"col"];
            seatsInfo.row = [dict intValueForKey:@"row"];
            seatsInfo.seatStatus = [dict intValueForKey:@"status"];
            seatsInfo.coordinateX = [dict intValueForKey:@"x"];
            seatsInfo.coordinateY = [dict intValueForKey:@"y"];
            
            [resultData addObject:seatsInfo];
        }
        _seatsInfo = resultData;
        [self fillDataToSeatsSelector];
    }
}

- (void)fillDataToSeatsSelector
{
    _seatsPicker.rowCount = _seatMaxX;
    _seatsPicker.colCount = _seatMaxY;
    _seatsPicker.seats = _seatsInfo;
    [_seatsPicker reloadData];
}


#pragma mark - FVSeatsPickerDelegate

- (BOOL)shouldSelectSeat:(FVSeatItem *)seatInfo inPicker:(FVSeatsPicker* )picker
{
    return YES;
}

- (BOOL)shouldDeselectSeat:(FVSeatItem *)seatInfo inPicker:(FVSeatsPicker* )picker
{
    return YES;
}

- (void)seatsPicker:(FVSeatsPicker* )picker didSelectSeat:(FVSeatItem *)seatInfo
{
    NSLog(@"%s---%@",__func__,seatInfo);
}
- (void)seatsPicker:(FVSeatsPicker* )picker didDeselectSeat:(FVSeatItem *)seatInfo
{
    NSLog(@"%s---%@",__func__,seatInfo);
}

- (void)selectionDidChangeInSeatsPicker:(FVSeatsPicker *)picker
{
    NSLog(@"%s",__func__);
}

- (void)setDistrict:(District)district
{
    _district = district;
    switch (district) {
        case DistrictA: {
            self.title = @"区域A";
            break;
        }
        case DistrictB: {
            self.title = @"区域B";
            break;
        }
        default:
            break;
    }
}

@end
