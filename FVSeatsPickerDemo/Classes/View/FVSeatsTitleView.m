//
//  FVSeatsTitleView.m
//  FVSeatsPicker
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//

#import "FVSeatsTitleView.h"
#import "UIColor+FVExtension.h"

@interface FVSeatsTitleView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabelView;
@property (weak, nonatomic) IBOutlet UIView *leftStateView;
@property (weak, nonatomic) IBOutlet UIView *centerStateView;
@property (weak, nonatomic) IBOutlet UIView *rightStateView;
@property (weak, nonatomic) IBOutlet UIView *seperatorLineView;

@end

@implementation FVSeatsTitleView

+ (instancetype)seleSeatsTitleView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor rgba:0xF9F9F9FF];
    self.seperatorLineView.backgroundColor = [UIColor rgba:0XDCDCDCFF];
    self.titleLabelView.layer.borderWidth = 1 / [UIScreen mainScreen].scale;
    self.titleLabelView.layer.cornerRadius = 4 / [UIScreen mainScreen].scale;
    self.titleLabelView.layer.borderColor = [[UIColor rgba:0X999999FF] CGColor];
    self.titleLabelView.textColor = [UIColor rgba:0x666666ff];
}

@end
