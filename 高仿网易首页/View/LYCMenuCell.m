//
//  LYCMenuCell.m
//  高仿网易首页
//
//  Created by 太极华青协同办公 on 2019/3/11.
//  Copyright © 2019年 太极华青协同办公. All rights reserved.
//

#import "LYCMenuCell.h"

@interface LYCMenuCell ()

/** <#注释#> */
@property (nonatomic, strong) UILabel *menuNameLabel;

@end

@implementation LYCMenuCell

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.menuNameLabel];
    }
    return self;
}

- (void)setMenu:(NSString *)menu
{
    _menu = menu;
    self.menuNameLabel.text = menu;
}

- (UILabel *)menuNameLabel
{
    if (!_menuNameLabel) {
        _menuNameLabel = [[UILabel alloc] init];
        _menuNameLabel.font = [UIFont systemFontOfSize:14];
        _menuNameLabel.frame = self.contentView.bounds;
        _menuNameLabel.textAlignment = NSTextAlignmentCenter;
        _menuNameLabel.textColor = UIColor.grayColor;
        _menuNameLabel.highlightedTextColor = UIColor.blackColor;
    }
    return _menuNameLabel;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
//    if (selected) {
//        self.backgroundColor = [UIColor redColor];
//    } else {
//        self.backgroundColor = [UIColor colorWithRed:160 / 255.0 green:160 / 255.0 blue:160 / 255.0 alpha:0.4];
//    }
}

@end
