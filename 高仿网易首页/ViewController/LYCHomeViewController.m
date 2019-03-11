//
//  LYCHomeViewController.m
//  高仿网易首页
//
//  Created by 太极华青协同办公 on 2019/3/11.
//  Copyright © 2019年 太极华青协同办公. All rights reserved.
//

#import "LYCHomeViewController.h"
#import "LYCSegmentBar.h"
#import "UIView+LYCLayout.h"
#import "LYCChildViewController.h"

// 导航栏的高度
//CGFloat const kNavigationBarMaxY = 64;

#define YYISiPhoneX [[UIScreen mainScreen] bounds].size.width >=375.0f && [[UIScreen mainScreen] bounds].size.height >=812.0f&& YYIS_IPHONE
#define YYIS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kNavBarHeight   (YYISiPhoneX?(88):(64))

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define XMGColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define XMGRandomColor XMGColor(arc4random_uniform(255.0), arc4random_uniform(255.0), arc4random_uniform(255.0))



@interface LYCHomeViewController () <UIScrollViewDelegate, LYCSegmentBarDelegate>
@property (nonatomic, strong) LYCSegmentBar *segmentBar;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray<NSString *> *categoryMs;

@end

@implementation LYCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"今日最火";
    
    self.contentScrollView.contentInsetAdjustmentBehavior = NO;
    self.view.backgroundColor = [UIColor grayColor];
    // 2. 添加内容视图
    [self.view addSubview:self.contentScrollView];
    
    // 1. 设置菜单栏
    [self.view addSubview:self.segmentBar];

    // 3. 模拟数据
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString *category = [NSString stringWithFormat:@"分类%d", i];
        [tempArray addObject: category];
    }
    self.categoryMs = tempArray;
}

-(void)setCategoryMs:(NSMutableArray<NSString *> *)categoryMs
{
    _categoryMs = categoryMs;
    [self setUpWithItems:categoryMs];
}


- (void)setUpWithItems: (NSArray <NSString *>*)items {
    
    // 0.添加子控制器
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    for (int i = 0; i < items.count; i++) {
        LYCChildViewController *vc = [[LYCChildViewController alloc] init];
        vc.view.backgroundColor = XMGRandomColor;
        [self addChildViewController:vc];
    }
    
    // 1. 设置菜单项展示
    self.segmentBar.segmentMs = items;
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width * items.count, 0);
    self.segmentBar.selectedIndex = 0;
}



- (void)showControllerView:(NSInteger)index {
    
    LYCChildViewController *cvc = self.childViewControllers[index];
    cvc.loadKey = self.categoryMs[index];
    UIView *view = cvc.view;
    CGFloat contentViewW = self.contentScrollView.width;
    view.frame = CGRectMake(contentViewW * index, 0, contentViewW, self.contentScrollView.height);
    [self.contentScrollView addSubview:view];
    [self.contentScrollView setContentOffset:CGPointMake(contentViewW * index, 0) animated:YES];
}


#pragma mark - <LYCSegmentBarDelegate>
- (void)segmentBarDidSelectIndex:(NSInteger)selectedIndex fromIndex:(NSInteger)fromIndex
{
    [self showControllerView:selectedIndex];
}

#pragma mark - <UIScollerViewDelegate>
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / scrollView.width;
    self.segmentBar.selectedIndex = page;
}


#pragma mark - Set & Get
-(LYCSegmentBar *)segmentBar
{
    if (!_segmentBar) {
        LYCSegmentConfig *config = [LYCSegmentConfig defaultConfig];
        config.isShowMore = YES;
        config.segSelectedFont = [UIFont systemFontOfSize:14];
        _segmentBar = [LYCSegmentBar segmentBarWithConfig:config];
        _segmentBar.y = kNavBarHeight;
        _segmentBar.backgroundColor = [UIColor whiteColor];
        _segmentBar.delegate = self;
    }
    return _segmentBar;
}

-(UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + self.segmentBar.height, kScreenWidth, kScreenHeight - (kNavBarHeight + self.segmentBar.height))];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(scrollView.width * self.childViewControllers.count, 0);
        _contentScrollView = scrollView;
    }
    return _contentScrollView;
}

@end
