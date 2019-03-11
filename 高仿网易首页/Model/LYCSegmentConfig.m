//
//  LYCSegmentConfig.m
//  高仿网易首页
//
//  Created by 太极华青协同办公 on 2019/3/11.
//  Copyright © 2019年 太极华青协同办公. All rights reserved.
//

#import "LYCSegmentConfig.h"

@implementation LYCSegmentConfig

static LYCSegmentConfig *_segmentConfig;

+ (instancetype)defaultConfig {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _segmentConfig = [super allocWithZone:NULL];
    });
    return _segmentConfig;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _segmentConfig = [self allocWithZone:zone];
    });
    return _segmentConfig;
}

/** 用于标识选项卡的指示器颜色 */
- (UIColor *)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = [UIColor redColor];
    }
    return _indicatorColor;
}

- (CGFloat)indicatorHeight {
    if (_indicatorHeight <= 0) {
        _indicatorHeight = 2;
    }
    return _indicatorHeight;
}

/** 选项颜色(普通) */
-(UIColor *)segNormalColor {
    if (!_segNormalColor) {
        _segNormalColor = [UIColor grayColor];
    }
    return _segNormalColor;
}

/** 选项颜色(选中) */
-(UIColor *)segSelectedColor {
    if (!_segSelectedColor) {
        _segSelectedColor = [UIColor redColor];
    }
    return _segSelectedColor;
}

/** 选项字体(普通) */
- (UIFont *)segNormalFont {
    if (!_segNormalFont) {
        _segNormalFont = [UIFont systemFontOfSize:12];
    }
    return _segNormalFont;
}

/** 选项字体(选中) */
- (UIFont *)segSelectedFont {
    if (!_segSelectedFont) {
        _segSelectedFont = [UIFont systemFontOfSize:12];
    }
    return _segSelectedFont;
    
}

/** 选项卡之间的最小间距 */
- (CGFloat)limitMargin {
    if (_limitMargin <= 0) {
        _limitMargin = 25;
    }
    
    return _limitMargin;
}



@end
