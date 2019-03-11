//
//  LYCMenuBarShowDetailViewController.h
//  高仿网易首页
//
//  Created by 太极华青协同办公 on 2019/3/11.
//  Copyright © 2019年 太极华青协同办公. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+LYCSegmentModelProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface LYCMenuBarShowDetailViewController : UICollectionViewController

@property (nonatomic, assign) CGFloat expectedHeight;
/** 数据源 */
@property (nonatomic, strong) NSArray <id<LYCSegmentModelProtocol>>*items;

@end

NS_ASSUME_NONNULL_END
