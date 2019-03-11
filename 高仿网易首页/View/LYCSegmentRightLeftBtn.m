//
//  LYCSegmentRightLeftBtn.m
//  高仿网易首页
//
//  Created by 太极华青协同办公 on 2019/3/11.
//  Copyright © 2019年 太极华青协同办公. All rights reserved.
//

#import "LYCSegmentRightLeftBtn.h"

@interface LYCSegmentRightLeftBtn()

@property (nonatomic, assign) CGFloat radio;

@end


@implementation LYCSegmentRightLeftBtn


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (CGFloat)radio {
    return 0.7;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width * self.radio, contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width * self.radio, 0, contentRect.size.width * ( 1 - self.radio - 0.2), contentRect.size.height);
}


@end
