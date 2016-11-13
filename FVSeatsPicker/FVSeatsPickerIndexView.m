//
//  FVSeatsPickerIndexView.m
//  FVCinemaSeatsView
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//

#import "FVSeatsPickerIndexView.h"
#import <CoreText/CoreText.h>
@implementation FVSeatsPickerIndexView
{
    NSParagraphStyle* _style;
    UIFont* _defaultFont;
    UIColor* _defaultColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        self.layer.masksToBounds = YES;
        _defaultFont = [UIFont systemFontOfSize:10];
        _defaultColor = [UIColor whiteColor];
        _style = ({
            NSMutableParagraphStyle* style = [NSMutableParagraphStyle new];
            style.alignment = NSTextAlignmentCenter;
            style;
        });
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_indexList.count)
    {
        CGFloat height = CGRectGetHeight(self.bounds);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(context, 0, height);
        CGContextScaleCTM(context, 1, -1);
        
        [_indexList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary* attributes = @{NSFontAttributeName:_indexNumFont?:_defaultFont,
                                         NSForegroundColorAttributeName:_indexNumColor?:_defaultColor,
                                         NSParagraphStyleAttributeName:_style};
            NSAttributedString* attStr = [[NSAttributedString alloc] initWithString:obj attributes:attributes];
            
            CGMutablePathRef path = CGPathCreateMutable();
            CGFloat rectHeight = height / _indexList.count;
            CGFloat rectOffset = (rectHeight - [attributes[NSFontAttributeName] lineHeight]) / 2;
            CGRect rect = CGRectMake(0, (_indexList.count - idx - 1) * rectHeight - rectOffset, CGRectGetWidth(self.bounds), rectHeight);
            CGPathAddRect(path, NULL, rect);
            
            CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
            CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
            CTFrameDraw(frame, context);
            CFRelease(frame);
            CGPathRelease(path);
            CFRelease(framesetter);
        }];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2;
}


@end
