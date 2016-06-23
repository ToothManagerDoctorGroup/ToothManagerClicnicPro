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
#import "Masonry.h"

#define kTTMStatisticsFormCellHeight 40
#define kTTMStatisticsFormCellID @"kTTMStatisticsFormCellID"

@interface TTMStatisticsFormView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UIView *headerView;
@property (nonatomic, strong)UICollectionView *collectionView;

@end

@implementation TTMStatisticsFormView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

+ (CGFloat)formViewHeightWithArray:(NSArray *)array{
    if (!array) return 0;
    return array.count * kTTMStatisticsFormCellHeight + (array.count - 1) * 1;
}

- (void)setSourceArray:(NSArray *)sourceArray{
    _sourceArray = sourceArray;
    
    [self.collectionView reloadData];
}

#pragma mark - ********************* Delegate/DataSource ******************
#pragma mark CollectionViewDelegate/DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sourceArray.count;
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
    TTMStatisticsFormModel *model = self.sourceArray[indexPath.section];
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