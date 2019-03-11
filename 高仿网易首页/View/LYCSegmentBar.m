//
//  LYCSegmentBar.m
//  高仿网易首页
//
//  Created by 太极华青协同办公 on 2019/3/11.
//  Copyright © 2019年 太极华青协同办公. All rights reserved.
//

#import "LYCSegmentBar.h"
#import "LYCMenuBarShowDetailViewController.h"
#import "UIView+LYCLayout.h"
#import "LYCSegmentRightLeftBtn.h"

#define kShowMoreBtnW (self.bounds.size.height + 30)

@interface LYCSegmentBar () <UICollectionViewDelegate>

/** 用于显示内容选项卡的视图 */
@property (nonatomic, strong) UIScrollView *contentScrollView;
/** 用于标识选项卡的指示器 */
@property (nonatomic, strong) UIView *indicatorView;
/** 用于存储选项按钮数组 */
@property (nonatomic, strong) NSMutableArray <UIButton *>*segBtns;
/** 用于记录上次选项 */
@property (nonatomic, weak) UIButton *lastBtn;
/** 选项卡显示配置, 修改此模型属性之后, 需要调用updateViewWithConfig 生效 */
@property (nonatomic, strong) LYCSegmentConfig *segmentConfig;
/** 更多按钮 */
@property (nonatomic, strong) LYCSegmentRightLeftBtn *showMoreBtn;
/** 折照视图 */
@property (nonatomic, nonnull, strong) UIView *coverView;
/** 菜单详情Vc */
@property (nonatomic, strong) LYCMenuBarShowDetailViewController *showDetailVC;


@end

@implementation LYCSegmentBar



/**
 *  根据配置选项, 创建一个选项卡条
 *
 *  @param config 选项卡配置
 *
 *  @return 选项卡
 */
+ (instancetype)segmentBarWithConfig: (LYCSegmentConfig *)config {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGRect defaultFrame = CGRectMake(0, 0, width, 40);
    LYCSegmentBar *segBar = [[LYCSegmentBar alloc] initWithFrame:defaultFrame];
    segBar.segmentConfig = config;
    return segBar;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.segmentConfig = [LYCSegmentConfig defaultConfig];
    }
    return self;
}

/** 刷新配置 */
- (void)updateViewWithConfig:(void (^)(LYCSegmentConfig * _Nonnull))configBlock
{
    if (configBlock != nil) {
        configBlock(self.segmentConfig);
    }
    self.segmentConfig = self.segmentConfig;
}


-(void)setSegmentConfig:(LYCSegmentConfig *)segmentConfig
{
    _segmentConfig = segmentConfig;
    
    // 指示器颜色
    self.indicatorView.backgroundColor = segmentConfig.indicatorColor;
    self.indicatorView.height = segmentConfig.indicatorHeight;
    
    // 选项颜色/字体
    for (UIButton *btn in self.segBtns) {
        [btn setTitleColor:segmentConfig.segNormalColor forState:UIControlStateNormal];
        if (btn != self.lastBtn) {
            btn.titleLabel.font = segmentConfig.segNormalFont;
        }else {
            btn.titleLabel.font = segmentConfig.segSelectedFont;
        }
        [btn setTitleColor:segmentConfig.segSelectedColor forState:UIControlStateSelected];
    }
    // 最小间距
    [self layoutIfNeeded];
    [self layoutSubviews];
}

/**
 *  根据配置, 更新视图
 */
- (void)updateViewWithConfig {
    self.segmentConfig = self.segmentConfig;
}


/**
 *  监听选项卡数据源的改变
 *
 *  @param segmentMs 选项卡数据源
 */
-(void)setSegmentMs:(NSArray<id<LYCSegmentModelProtocol>> *)segmentMs
{
    _segmentMs = segmentMs;
    
    if (self.segmentConfig.isShowMore) {
        self.showDetailVC.items = _segmentMs;
        self.showDetailVC.collectionView.height = 0;
    }
    
    // 移除之前所有的子控件
    [self.segBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.segBtns = nil;
    self.lastBtn = nil;
    [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;
    
    // 添加最新的子控件
    for (NSObject<LYCSegmentModelProtocol> *segM in segmentMs) {
        UIButton *btn = [[UIButton alloc] init];
        if (segM.segID == -1) {
            btn.tag = self.segBtns.count;
            
        }else {
            btn.tag = segM.segID;
        }
        
        [btn addTarget:self action:@selector(segClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = self.segmentConfig.segNormalFont;
        [btn setTitleColor:self.segmentConfig.segNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.segmentConfig.segSelectedColor forState:UIControlStateSelected];
        [btn setTitle:segM.segContent forState:UIControlStateNormal];
        [self.contentScrollView addSubview:btn];
        [btn sizeToFit];
        
        // 保存到一个数组中
        [self.segBtns addObject:btn];
        
    }
    // 重新布局
    [self layoutIfNeeded];
    [self layoutSubviews];
    
    
    // 默认选中第一个选项卡
    [self segClick:[self.segBtns firstObject]];
    
}


- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    for (UIButton *btn in self.segBtns) {
        if (btn.tag == selectedIndex) {
            [self segClick:btn];
            break;
        }
    }
}


/**
 *  点击某个选项卡调用的事件
 */
- (void)segClick: (UIButton *)btn {
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(segmentBarDidSelectIndex:fromIndex:)])
    {
        _selectedIndex = btn.tag;
        [self.delegate segmentBarDidSelectIndex:_selectedIndex fromIndex:self.lastBtn.tag];
    }
    
    // 修改状态，让上个选中的按钮取消选中
    self.lastBtn.selected = NO;
    self.lastBtn.titleLabel.font = self.segmentConfig.segNormalFont;
    [self.lastBtn sizeToFit];
    self.lastBtn.height = self.contentScrollView.height - self.segmentConfig.indicatorHeight;
    
    // 点击的按钮选中
    btn.selected = YES;
    btn.titleLabel.font = self.segmentConfig.segSelectedFont;
    [btn sizeToFit];
    btn.height = self.contentScrollView.height - self.segmentConfig.indicatorHeight;
    // 把选中的按钮设为上次选中的
    self.lastBtn = btn;
    
    if (self.segmentConfig.isShowMore) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.lastBtn.tag inSection:0];
        [self.showDetailVC.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [self hideDetailPane];
    }
    
    
    // 移动指示器位置
    [UIView animateWithDuration:0.2 animations:^{
        
        // 控制宽度, 和中心
        NSString *text = btn.titleLabel.text;
        NSDictionary *fontDic = @{
                                  NSFontAttributeName : btn.titleLabel.font
                                  };
        CGSize size = [text sizeWithAttributes:fontDic];
        self.indicatorView.y = self.contentScrollView.height - self.segmentConfig.indicatorHeight;
        self.indicatorView.width = size.width + self.segmentConfig.indicatorExtraWidth;
        self.indicatorView.centerX = btn.centerX;
        
    }];
    
    
    // 自动滚动到中间位置
    CGFloat shouldScrollX = btn.centerX - self.contentScrollView.width * 0.5;
    
    if (shouldScrollX < 0) { // 如果滚动到最左边了setContentOffset.x就置为0
        shouldScrollX = 0;
    }
    
    // 滚动到右边的最大值 self.contentScrollView.contentSize.width - self.contentScrollView.width
    if (shouldScrollX > self.contentScrollView.contentSize.width - self.contentScrollView.width) { // 滚动到最右边了
        shouldScrollX = self.contentScrollView.contentSize.width - self.contentScrollView.width;
    }
    [self.contentScrollView setContentOffset:CGPointMake(shouldScrollX, 0) animated:YES];
}

- (void)showOrHide:(UIButton *)btn {
    
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self showDetailPane];
    }else {
        [self hideDetailPane];
    }
    
}

- (void)showDetailPane {
    
    self.showMoreBtn.selected = YES;
    self.showDetailVC.collectionView.hidden = NO;
    self.coverView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.showDetailVC.collectionView.height = self.showDetailVC.expectedHeight;
        self.coverView.height = [UIScreen mainScreen].bounds.size.height;
    }];
    
}

- (void)hideDetailPane {
    self.showMoreBtn.selected = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.showDetailVC.collectionView.height = 0;
        self.coverView.height = 0;
    } completion:^(BOOL finished) {
        self.coverView.hidden = YES;
        self.showDetailVC.collectionView.hidden = YES;
    }];
}



-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentScrollView.frame = self.bounds;
    
    if (!self.segmentConfig.isShowMore) {
        self.contentScrollView.frame = self.bounds;
        self.showMoreBtn.width = -1;
    }else {
        self.contentScrollView.frame = CGRectMake(0, 0, self.width - kShowMoreBtnW, self.height);
        self.showMoreBtn.frame = CGRectMake(self.width - kShowMoreBtnW, 0, kShowMoreBtnW, self.height);
    }
    
    
    // 1. 计算间距
    CGFloat titleTotalW = 0;
    for (int i = 0; i < self.segBtns.count; i++)  {
        [self.segBtns[i] sizeToFit];
        CGFloat width = self.segBtns[i].width;
        titleTotalW += width;
    }
    
    CGFloat margin = (self.contentScrollView.width - titleTotalW) / (self.segmentMs.count + 1);
    margin = margin < self.segmentConfig.limitMargin ? self.segmentConfig.limitMargin : margin;
    
    
    // 布局topmMenue 内部控件
    CGFloat btnY = 0;
    
    CGFloat btnHeight = self.contentScrollView.height - self.segmentConfig.indicatorHeight;
    UIButton *lastBtn;
    for (int i = 0; i < self.segBtns.count; i++) {
        
        // 计算每个控件的宽度
        CGFloat btnX = CGRectGetMaxX(lastBtn.frame) + margin;
        self.segBtns[i].x = btnX;
        self.segBtns[i].y = btnY;
        self.segBtns[i].height = btnHeight;
        
        lastBtn = self.segBtns[i];
        
    }
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame) + margin, 0);
    
    
    // 修正指示器的位置, 控制宽度, 和中心
    if (self.lastBtn) {
        NSString *text = self.lastBtn.titleLabel.text;
        NSDictionary *fontDic = @{
                                  NSFontAttributeName : self.lastBtn.titleLabel.font
                                  };
        CGSize size = [text sizeWithAttributes:fontDic];
        self.indicatorView.y = self.contentScrollView.height - self.segmentConfig.indicatorHeight;
        self.indicatorView.width = size.width + self.segmentConfig.indicatorExtraWidth;
        self.indicatorView.centerX = self.lastBtn.centerX;
    }
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    [self hideDetailPane];
}


#pragma mark - Set & Get
- (LYCMenuBarShowDetailViewController *)showDetailVC
{
    if (!_showDetailVC) {
        _showDetailVC = [[LYCMenuBarShowDetailViewController alloc] init];
        _showDetailVC.collectionView.delegate = self;
    }
    if (_showDetailVC.collectionView.superview != self.superview) {
        _showDetailVC.collectionView.frame = CGRectMake(0, self.y + self.height, self.width, 0);
        [self.superview addSubview:_showDetailVC.collectionView];
    }
    return _showDetailVC;
}


- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, self.y + self.height, self.width, 0)];
        _coverView.backgroundColor = [UIColor colorWithRed:55 / 255.0 green:55 / 255.0 blue:55 / 255.0 alpha:0.4];
        UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDetailPane)];
        [_coverView addGestureRecognizer:gester];
    }
    if (!_coverView.superview) {
        // 把折照视图插在collectionView的下面
        [self.superview insertSubview:_coverView belowSubview:self.showDetailVC.collectionView];
    }
    return _coverView;
}


- (LYCSegmentRightLeftBtn *)showMoreBtn
{
    if (!_showMoreBtn) {
        
        //        NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
        //        NSString *sourcePath = [currentBundle.infoDictionary[@"CFBundleName"] stringByAppendingString:@".bundle"];
        //        NSString *showImgPath = [currentBundle pathForResource:@"icon_radio_show@2x" ofType:@".png" inDirectory:sourcePath];
        //        UIImage *showImage = [UIImage imageWithContentsOfFile:showImgPath];
        //
        //        NSString *hideImgPath = [currentBundle pathForResource:@"icon_radio_hide@2x" ofType:@".png" inDirectory:sourcePath];
        //        UIImage *hideImage = [UIImage imageWithContentsOfFile:hideImgPath];
        
        UIImage *showImage = [UIImage imageNamed:@"icon_radio_show"];
        UIImage *hideImage = [UIImage imageNamed:@"icon_radio_hide"];
        _showMoreBtn = [[LYCSegmentRightLeftBtn alloc] init];
        [_showMoreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_showMoreBtn setImage:showImage forState:UIControlStateNormal];
        [_showMoreBtn setTitle:@"收起" forState:UIControlStateSelected];
        [_showMoreBtn setImage:hideImage forState:UIControlStateSelected];
        _showMoreBtn.imageView.contentMode = UIViewContentModeCenter;
        [_showMoreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        //        _showMoreBtn.backgroundColor = [UIColor greenColor];
        _showMoreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        // 添加分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 1, 20)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_showMoreBtn addSubview:line];
        
        [_showMoreBtn addTarget:self action:@selector(showOrHide:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_showMoreBtn];
    }
    return _showMoreBtn;
}


/** 用于显示内容选项卡的视图 */
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentScrollView];
    }
    return _contentScrollView;
}


/** 用于标识选项卡的指示器 */
- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - self.segmentConfig.indicatorHeight, 0, self.segmentConfig.indicatorHeight)];
        _indicatorView.backgroundColor = self.segmentConfig.indicatorColor;
        [self.contentScrollView addSubview:_indicatorView];
    }
    return _indicatorView;
}

/** 用于存储选项卡的数组 */
- (NSMutableArray<UIButton *> *)segBtns
{
    if (!_segBtns) {
        _segBtns = [NSMutableArray array];
    }
    return _segBtns;
}


@end
