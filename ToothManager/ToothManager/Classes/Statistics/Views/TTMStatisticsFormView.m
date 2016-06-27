//
//  TTMStatisticsFormView.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/22.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMStatisticsFormView.h"
#import "UIColor+TTMAddtion.h"
#import "TTMStatisticsFormCell.h"
#import "XLSegmentView.h"
#import "Masonry.h"

#define kTTMStatisticsFormCellHeight 40
#define kTTMStatisticsFormCellID @"kTTMStatisticsFormCellID"
#define kHeaderViewHeight 44

@interface TTMStatisticsFormView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)XLSegmentView *headerSegmentView;
@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, assign)BOOL showHeader;

@property (nonatomic, strong)NSArray *dataList;

@end

@implementation TTMStatisticsFormView

- (instancetype)initWithFrame:(CGRect)frame showHeader:(BOOL)showHeader
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showHeader = showHeader;
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self addSubview:self.collectionView];
    
    if (self.showHeader) {
        [self addSubview:self.headerSegmentView];
        
        [self.headerSegmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.and.right.equalTo(self);
            make.height.mas_equalTo(kHeaderViewHeight);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(kHeaderViewHeight, 0, 0, 0));
        }];
    }else{
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

+ (CGFloat)formViewHeightWithArray:(NSArray *)array showHeader:(BOOL)showHeader{
    if (!array) return 0;
    if (showHeader) {
        return array.count * kTTMStatisticsFormCellHeight + (array.count - 1) * 1 + kHeaderViewHeight;
    }else{
        return array.count * kTTMStatisticsFormCellHeight + (array.count - 1) * 1;
    }
}

- (void)setSourceModel:(TTMStatisticsFormSourceModel *)sourceModel{
    _sourceModel = sourceModel;
    self.dataList = sourceModel.sourceArray[0];
    [self.collectionView reloadData];
    
    if (sourceModel.titleArray.count > 0) {
        self.headerSegmentView.titleArray = sourceModel.titleArray;
        __weak typeof(self) weakSelf = self;
        self.headerSegmentView.block = ^(NSInteger index) {
            //刷新数据
            weakSelf.dataList = sourceModel.sourceArray[index - 1];
            [weakSelf.collectionView reloadData];
        };
    }
    
}

#pragma mark - ********************* Delegate/DataSource ******************
#pragma mark CollectionViewDelegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

// 设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 1, 1);
    }
    return UIEdgeInsetsMake(0, 0, 1, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake((self.width - 2) / 2, kTTMStatisticsFormCellHeight);
    }
    return CGSizeMake((self.width - 1) / 2, kTTMStatisticsFormCellHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TTMStatisticsFormCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTTMStatisticsFormCellID forIndexPath:indexPath];
    TTMStatisticsFormModel *model = self.dataList[indexPath.section];
    if (indexPath.section == 0) {
        cell.backgroundColor = MainColor;
        cell.contentLabel.textColor = [UIColor whiteColor];
        if (indexPath.item == 0) {
            cell.contentLabel.text = model.title;
        }else{
            cell.contentLabel.text = model.content;
        }
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        cell.contentLabel.textColor = [UIColor blackColor];
        if (indexPath.item == 0) {
            cell.contentLabel.text = model.title;
        }else{
            cell.contentLabel.text = model.content;
        }
    }
    return cell;
}


#pragma mark - ********************* Lazy Method ***********************
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 1;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.layer.borderColor = [UIColor colorWithHex:0xcccccc].CGColor;
        _collectionView.userInteractionEnabled = NO;
        _collectionView.layer.borderWidth = 1;
        _collectionView.backgroundColor = [UIColor colorWithHex:0xcccccc];
        [_collectionView registerClass:[TTMStatisticsFormCell class] forCellWithReuseIdentifier:kTTMStatisticsFormCellID];
    }
    return _collectionView;
}

- (XLSegmentView *)headerSegmentView{
    if (!_headerSegmentView) {
        _headerSegmentView = [[XLSegmentView alloc] initWithFrame:CGRectZero];
        _headerSegmentView.bgNormalColor = [UIColor whiteColor];
        _headerSegmentView.bgSelectColor = MainColor;
        _headerSegmentView.titleSelectColor = [UIColor blackColor];
    }
    return _headerSegmentView;
}

@end


@implementation TTMStatisticsFormModel


- (instancetype)initWIthTitle:(NSString *)title
                      content:(NSString *)content{
    if (self = [super init]) {
        self.title = title;
        self.content = content;
    }
    return self;
}

@end

@implementation TTMStatisticsFormSourceModel

@end