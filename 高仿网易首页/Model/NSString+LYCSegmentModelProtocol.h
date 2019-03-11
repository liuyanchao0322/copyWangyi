//
//  NSString+LYCSegmentModelProtocol.h
//  高仿网易首页
//
//  Created by 太极华青协同办公 on 2019/3/11.
//  Copyright © 2019年 太极华青协同办公. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYCSegmentModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LYCSegmentModelProtocol) <LYCSegmentModelProtocol>

/** 选项卡的ID, 如果不设置, 默认是索引值(从0开始) */
- (NSInteger)segID;

/** 选项卡内容 */
- (NSString *)segContent;


@end

NS_ASSUME_NONNULL_END
