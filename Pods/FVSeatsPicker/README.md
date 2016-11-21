# FVSeatsPicker
 A simple and efficient seat control, it can display a variety of seating styles, and supports custom stretching ratio, seat information transmission, and so on, I hope it is you want.

<img src="https://img.shields.io/badge/build-passing-orange.svg?style=flat" alt="build passing" />
<img src="https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat" alt="license MIT" />
<img src="https://img.shields.io/badge/platform-iOS-green.svg?style=flat" alt="license MIT" />

## Introduction


FVSeatsPicker can help us to achieve the following results


<img src="image/seats_picker.gif" width = 200 />

FVSeatsPicker There are three main categories, namely FVSeatsPicker, FVSeatsPickerIndexView and FVSeatsItem. The following brief description of the various types of functions is to use!
The FVSeatsPicker is the main display class. We can use it as a UIView when we use it. In addition, you need to tell it the size, number of rows, number of columns, and number of columns you want to display. Seat information can be. In addition, this class provides a way to set the state of the picture, if we do not call the change method or image pass empty, FVSeatsPicker will use the framework of the internal image resources.
FVSeatsPickerIndexView is a helper class that indicates the line number in the FVSeatsPicker and does not need to be set outside.
FVSeatsItem is a model class, a FVSeatsItem object represents a seat information displayed on the FVSeatsPicker.
Finally, we can achieve FVSeatsPickerDelegate method to obtain the user to select the seat information, and control the user when the seat selection behavior.

## Basic usage

FVSeatsPicker can be added as a normal View to the view, as we usually add other child controls. E.g:

```objc
- (void)viewDidLoad 
{
    [super viewDidLoad];
    FVSeatsPicker *picker = [FVSeatsPicker new];
    picker.cellSize = CGSizeMake(24, 24);
    picker.minimumZoomScale = 1;
    picker.maximumZoomScale = 2;
    picker.seatsDelegate = self;
    [picker setImage:[UIImage imageNamed:@"seat_available"] forState:UIControlStateNormal];
    [picker setImage:[UIImage imageNamed:@"seat_unavailable"] forState:UIControlStateDisabled];
    [picker setImage:[UIImage imageNamed:@"seat_selected"] forState:UIControlStateSelected];
    [self.view addSubview:picker];
    _seatsPicker.frame = CGRectMake(0, 100, kScreenWidth, kScreenHeight * 0.6);
}
```

We can implement the `FVSeatsPickerDelegate` method to get the seat information selected by the user, and control the behavior of the user when making selections.

```objc
- (BOOL)shouldSelectSeat:(FVSeatItem *)seatInfo inPicker:(FVSeatsPicker* )picker;
- (BOOL)shouldDeselectSeat:(FVSeatItem *)seatInfo inPicker:(FVSeatsPicker* )picker;

- (void)seatsPicker:(FVSeatsPicker* )picker didSelectSeat:(FVSeatItem *)seatInfo;
- (void)seatsPicker:(FVSeatsPicker* )picker didDeselectSeat:(FVSeatItem *)seatInfo;

- (void)selectionDidChangeInSeatsPicker:(FVSeatsPicker *)picker;

```

Refer to the example project for detailed information.



## Requirements

iOS 7.0 or above.

## Installation

FVSeatsPicker is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod "FVSeatsPicker"
```

## License

FVSeatsPicker is available under the MIT license. See the LICENSE file for more info.
