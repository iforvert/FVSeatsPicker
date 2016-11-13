//
//  FVSeatsPicker.m
//  FVCinemaSeatsView
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//

#import "FVSeatsPicker.h"
#import "FVSeatsPickerIndexView.h"
#import <objc/runtime.h>

static const CGFloat kRowIndexWidth = 14;
static const char kSeatInfo;


@interface FVSeatsPicker()<UIScrollViewDelegate>

@end

@implementation FVSeatsPicker
{
    UIView* _contentView;
    FVSeatsPickerIndexView* _rowIndexView;
    
    NSMutableDictionary<NSNumber*, UIImage*>* _imageDict;
    NSArray<UIButton*>* _buttons;
    
    UIEdgeInsets _boundsInset;
    
    struct {
        BOOL responseToShouldSelectSeat: 1;
        BOOL responseToShouldDeselectSeat: 1;
        BOOL responseToDidSelectSeat: 1;
        BOOL responseToDidDeselectSeat: 1;
        BOOL responseToSelectionChanged: 1;
    } _flags;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageDict = [NSMutableDictionary dictionary];
        [self configDefaultSeatsIcon];
        _boundsInset = UIEdgeInsetsMake(20, 20, 20, 20);
        self.delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _contentView.center = [self contentCenter];
}

- (void)setImage:(UIImage*)image forState:(UIControlState)state
{
    if (image != nil)
    {
        _imageDict[@(state)] = image;
    }
    [self configDefaultSeatsIcon];
}

- (void)configDefaultSeatsIcon
{
    NSString *source1 = [[self fv_bundle] pathForResource:@"seat_available@2x" ofType:@"png"];
    _imageDict[@(UIControlStateNormal)] = [[UIImage imageWithContentsOfFile:source1] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSString *source2 = [[self fv_bundle] pathForResource:@"seat_disabled@2x" ofType:@"png"];
    _imageDict[@(UIControlStateDisabled)] = [[UIImage imageWithContentsOfFile:source2] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSString *source3 = [[self fv_bundle] pathForResource:@"seat_selected@2x" ofType:@"png"];
    _imageDict[@(UIControlStateSelected)] = [[UIImage imageWithContentsOfFile:source3] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (NSBundle *)fv_bundle
{
    static NSBundle *seatBundle = nil;
    if (seatBundle == nil)
    {
        seatBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"FVSeatsPicker" ofType:@"bundle"]];
    }
    return seatBundle;
}

- (NSArray<FVSeatItem *>*)selectedSeats
{
    NSArray<UIButton*>* buttons = [_buttons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected = %@", @(YES)]];
    if (buttons.count)
    {
        NSMutableArray<FVSeatItem *>* list = [NSMutableArray array];
        [buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FVSeatItem* info = objc_getAssociatedObject(obj, &kSeatInfo);
            if (info) {[list addObject:info];};
        }];
        [list sortUsingComparator:^NSComparisonResult(FVSeatItem* _Nonnull obj1, FVSeatItem* _Nonnull obj2) {
            if (obj1.row < obj2.row) return NSOrderedAscending;
            else if (obj1.row > obj2.row) return NSOrderedDescending;
            else if (obj1.col < obj2.col) return NSOrderedAscending;
            else if (obj1.col > obj2.col) return NSOrderedDescending;
            else return NSOrderedSame;
        }];
        return [NSArray arrayWithArray:list];
    }
    return nil;
}

- (void)setSeatsDelegate:(id<FVSeatsPickerDelegate>)seatsDelegate
{
    _seatsDelegate = seatsDelegate;
    
    _flags.responseToShouldSelectSeat = [seatsDelegate respondsToSelector:@selector(shouldSelectSeat:inPicker:)];
    _flags.responseToShouldDeselectSeat = [seatsDelegate respondsToSelector:@selector(shouldDeselectSeat:inPicker:)];
    _flags.responseToDidSelectSeat = [seatsDelegate respondsToSelector:@selector(seatsPicker:didSelectSeat:)];
    _flags.responseToDidDeselectSeat = [seatsDelegate respondsToSelector:@selector(seatsPicker:didDeselectSeat:)];
    _flags.responseToSelectionChanged = [seatsDelegate respondsToSelector:@selector(selectionDidChangeInSeatsPicker:)];
}

- (void)reloadData
{
    [_contentView removeFromSuperview];
    _buttons = nil;
    _rowIndexView = nil;
    
    if (_cellSize.width < 1 || _cellSize.height < 1 || !_seats.count)
    {
        if (_flags.responseToSelectionChanged)
        {
            [_seatsDelegate selectionDidChangeInSeatsPicker:self];
        }
        return;
    }
    
    _contentView = [UIView new];
    NSMutableArray<UIButton*>* buttons = [NSMutableArray array];
    
    for (FVSeatItem* info in _seats)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((info.coordinateX - 1) * _cellSize.width + _boundsInset.left,
                                  (info.coordinateY - 1) * _cellSize.height + _boundsInset.top,
                                  _cellSize.width,
                                  _cellSize.height);
        
        for (NSNumber* state in _imageDict)
        {
            [button setImage:_imageDict[state] forState:state.unsignedIntegerValue];
        }
        
        button.enabled = info.seatStatus == FVSeatsStateAvailable;
        objc_setAssociatedObject(button, &kSeatInfo, info, OBJC_ASSOCIATION_ASSIGN);
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
        
        [_contentView addSubview:button];
    }
    
    self.zoomScale = 1;
    CGSize size = CGSizeMake(_colCount * _cellSize.width + _boundsInset.left + _boundsInset.right,
                             _rowCount * _cellSize.height + _boundsInset.top + _boundsInset.bottom);
    _contentView.frame = (CGRect){0, 0, size};
    [self addSubview:_contentView];
    self.contentSize = size;
    _buttons = [NSArray arrayWithArray:buttons];
    
    _rowIndexView = ({
        FVSeatsPickerIndexView* indexView = [[FVSeatsPickerIndexView alloc] initWithFrame:CGRectMake(0, _boundsInset.top, kRowIndexWidth, _rowCount * _cellSize.height)];
        indexView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.6];
        indexView.indexList = [self buildRowIndexList];
        [_contentView addSubview:indexView];
        indexView;
    });
}

- (NSArray<NSString*>*)buildRowIndexList
{
    if (_seats.count)
    {
        NSMutableArray<NSString*>* arr = [[NSMutableArray alloc] initWithCapacity:_rowCount];
        for (NSUInteger row = 0; row < _rowCount; row ++) {
            [arr addObject:[NSString string]];
        }
        
        [_seats enumerateObjectsUsingBlock:^(FVSeatItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSUInteger row = obj.coordinateY - 1;
            if (row < _rowCount && arr[row].length == 0)
            {
                arr[row] = @(obj.row).stringValue;
            }
        }];
        
        return [NSArray arrayWithArray:arr];
    }
    else
    {
        return nil;
    }
}

- (void)buttonClicked:(UIButton* )button
{
    FVSeatItem *info = objc_getAssociatedObject(button, &kSeatInfo);
    if (button.selected)
    {
        if (!_flags.responseToShouldDeselectSeat || [_seatsDelegate shouldDeselectSeat:info inPicker:self])
        {
            button.selected = NO;
            if (_flags.responseToDidDeselectSeat)
            {
                [_seatsDelegate seatsPicker:self didDeselectSeat:info];
            }
            if (_flags.responseToSelectionChanged)
            {
                [_seatsDelegate selectionDidChangeInSeatsPicker:self];
            }
        }
    }
    else
    {
        if (!_flags.responseToShouldSelectSeat || [_seatsDelegate shouldSelectSeat:info inPicker:self])
        {
            button.selected = YES;
            if (_flags.responseToDidSelectSeat)
            {
                [_seatsDelegate seatsPicker:self didSelectSeat:info];
            }
            if (_flags.responseToSelectionChanged)
            {
                [_seatsDelegate selectionDidChangeInSeatsPicker:self];
            }
        }
    }
}

- (void)tryToChangeSelectionOfSeat:(FVSeatItem *)seat
{
    if (!seat || !_buttons.count)
    {
        return;
    }
    
    NSUInteger index = [_buttons indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL* stop) {
        return objc_getAssociatedObject(obj, &kSeatInfo) == seat;
    }];
    
    if (index != NSNotFound)
    {
        [self buttonClicked:_buttons[index]];
    }
}

- (CGPoint)contentCenter
{
    CGSize outerSize = self.bounds.size;
    CGSize innerSize = self.contentSize;
    return CGPointMake(MAX(outerSize.width / 2, innerSize.width / 2), MAX(outerSize.height / 2, innerSize.height / 2));
}

- (void)repositionIndexView
{
    _rowIndexView.frame = ({
        CGRect rect = _rowIndexView.frame;
        rect.origin.x = self.contentOffset.x / self.zoomScale;
        rect;
    });
}

#pragma mark - Scroll View Delegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _contentView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self repositionIndexView];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self repositionIndexView];
}



@end
