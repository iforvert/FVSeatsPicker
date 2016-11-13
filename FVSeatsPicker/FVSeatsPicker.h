//
//  FVSeatsPicker.h
//  FVCinemaSeatsView
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVSeatItem.h"

@class FVSeatsPicker;

@protocol FVSeatsPickerDelegate<NSObject>

@optional
- (BOOL)shouldSelectSeat:(FVSeatItem *)seatInfo inPicker:(FVSeatsPicker* )picker;
- (BOOL)shouldDeselectSeat:(FVSeatItem *)seatInfo inPicker:(FVSeatsPicker* )picker;

- (void)seatsPicker:(FVSeatsPicker* )picker didSelectSeat:(FVSeatItem *)seatInfo;
- (void)seatsPicker:(FVSeatsPicker* )picker didDeselectSeat:(FVSeatItem *)seatInfo;

- (void)selectionDidChangeInSeatsPicker:(FVSeatsPicker *)picker;

@end

@interface FVSeatsPicker : UIScrollView

@property (nonatomic, weak) id<FVSeatsPickerDelegate> seatsDelegate;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) NSUInteger rowCount;
@property (nonatomic, assign) NSUInteger colCount;
@property (nonatomic, assign) NSArray<FVSeatItem *>* seats;

- (NSArray<FVSeatItem *>*)selectedSeats;

- (void)setImage:(UIImage* )image forState:(UIControlState)state;
- (void)reloadData;

- (void)tryToChangeSelectionOfSeat:(FVSeatItem *)seat;

@end
