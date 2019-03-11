//
//  LYCMenuBarShowDetailViewController.m
//  高仿网易首页
//
//  Created by 太极华青协同办公 on 2019/3/11.
//  Copyright © 2019年 太极华青协同办公. All rights reserved.
//

#import "LYCMenuBarShowDetailViewController.h"
#import "UIView+LYCLayout.h"
#import "LYCMenuCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kRowCount 4
#define kMargin 6
#define kCellH 30


@interface LYCMenuBarShowDetailViewController ()

@end

@implementation LYCMenuBarShowDetailViewController

static NSString * const reuseIdentifier = @"menue";

- (void)setItems:(NSArray<id<LYCSegmentModelProtocol>> *)items
{
    _items = items;
    NSInteger rows = (_items.count + (kRowCount - 1)) / kRowCount;
    CGFloat height = rows * (kCellH + kMargin);
    self.collectionView.height = height;
    self.expectedHeight = height;
    [self.collectionView reloadData];
}


-(instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (kScreenWidth - kMargin * (kRowCount + 1)) / kRowCount;
    CGFloat height = kCellH;
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.minimumLineSpacing = kMargin;
    flowLayout.minimumInteritemSpacing = kMargin;
    return [super initWithCollectionViewLayout:flowLayout];
}

-(instancetype)init
{
    return [self initWithCollectionViewLayout:[UICollectionViewLayout new]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[LYCMenuCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}



#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LYCMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.menu = (NSString *)self.items[indexPath.row];
    return cell;
}



@end
