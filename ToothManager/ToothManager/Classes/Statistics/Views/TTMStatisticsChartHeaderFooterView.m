//
//  TTMStatisticsChartHeaderFooterView.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMStatisticsChartHeaderFooterView.h"
#import "Masonry.h"

#define kMargin 15
#define kItemHeight 14

#pragma mark ------TTMStatisticsChartHeaderFooterView------------------

@interface TTMStatisticsChartHeaderFooterView ()

@property (nonatomic, assign)CGFloat headerFooterHeight;

@end

@implementation TTMStatisticsChartHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxNumOneLine = 4;
        self.headerFooterHeight = 0;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    //创建按钮视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //创建新视图
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < dataArray.count; i++) {
        TTMStatisticsChartHeaderFooterModel *model = dataArray[i];
        TTMStatisticsChartHeaderFooterItemView *itemView = [[TTMStatisticsChartHeaderFooterItemView alloc] initColor:model.color content:model.content];
        [self addSubview:itemView];
        [views addObject:itemView];
    }
    NSArray *items = views;
    
    NSInteger rowCapacity = self.maxNumOneLine;//每行item容量(个数)
    
    CGFloat itemSpacing = kMargin; //item间距
    CGFloat rowSpacing = kMargin; //行间距
    CGFloat topMargin = kMargin; //上边距
    CGFloat leftMargin = kMargin; //左边距
    CGFloat rightMargin = kMargin; //右边距
    
    __block UIView *lastView;
    [items enumerateObjectsUsingBlock:^(UIView   *view, NSUInteger idx, BOOL *  stop) {
        NSInteger rowIndex = idx / rowCapacity; //行index
        NSInteger columnIndex = idx % rowCapacity;//列index
        
        if (lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //设置 各个item 大小相等
                make.size.equalTo(lastView);
            }];
        }
        if (columnIndex == 0) {//每行第一列
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //设置左边界
                make.left.offset(leftMargin);
                if (rowIndex == 0) {//第一行 第一个
                    make.height.mas_equalTo(kItemHeight);
                    if (items.count < rowCapacity) {//不满一行时 需要 计算item宽
                        //比如 每行容量是6,则公式为:(superviewWidth/6) - (leftMargin + rightMargin + SumOfItemSpacing)/6
                        make.width.equalTo(view.superview).multipliedBy(1.0/rowCapacity).offset(-(leftMargin + rightMargin + (rowCapacity -1) * itemSpacing)/rowCapacity);
                    }
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {//设置上边界
                        make.top.offset(topMargin);
                    }];
                }else {//其它行 第一个
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        //和上一行的距离
                        make.top.equalTo(lastView.mas_bottom).offset(rowSpacing);
                    }];
                }
            }];
        }else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //设置item水平间距
                make.left.equalTo(lastView.mas_right).offset(itemSpacing);
                //设置item水平对齐
                make.centerY.equalTo(lastView);
                
                //设置右边界距离
                if (columnIndex == rowCapacity - 1 && rowIndex == 0) {//只有第一行最后一个有必要设置与父视图右边的距离，因为结合这条约束和之前的约束可以得出item的宽，前提是必须满一行，不满一行 需要计算item的宽
                    make.right.offset(- rightMargin);
                }
            }];
        }
        lastView = view;
    }];
}

- (CGFloat)headerFooterHeightWithArray:(NSArray *)sourceArray{
    CGFloat headerFooterHeight = 0;
    if (!sourceArray || sourceArray.count == 0) {
        return headerFooterHeight;
    }
    //判断总共有多少列  9/3 = 3
    NSInteger colums = 1;
    if (sourceArray.count > self.maxNumOneLine) {
        colums = sourceArray.count / self.maxNumOneLine == 0 ? sourceArray.count / self.maxNumOneLine : sourceArray.count / self.maxNumOneLine + 1;
    }
    
    headerFooterHeight = kItemHeight * colums + kMargin * (colums + 1);
    
    return headerFooterHeight;
}

@end


#pragma mark ------TTMStatisticsChartHeaderFooterItemView------------------

@interface TTMStatisticsChartHeaderFooterItemView ()

@property (nonatomic, strong)UIView *colorView;//颜色View
@property (nonatomic, strong)UILabel *contentLabel; //描述

@property (nonatomic, strong)UIColor *color;
@property (nonatomic, copy)NSString *content;

@end

@implementation TTMStatisticsChartHeaderFooterItemView

- (instancetype)initColor:(UIColor *)color content:(NSString *)content{
    if (self = [super init]) {
        self.color = color;
        self.content = content;
        [self setUp];
    }
    return self;
}
#pragma mark 初始化
- (void)setUp{
    [self addSubview:self.colorView];
    [self addSubview:self.contentLabel];
    //设置约束
    [self setUpContrains];
}

#pragma mark 设置约束
- (void)setUpContrains{
    CGFloat margin = 5;
    
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kItemHeight, kItemHeight));
    }];
    self.colorView.backgroundColor = self.color;
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.colorView.mas_right).offset(margin);
        make.right.equalTo(self);
        make.height.mas_equalTo(kItemHeight);
    }];
    self.contentLabel.text = self.content;
}

#pragma mark - Lazy Method
- (UIView *)colorView{
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.layer.cornerRadius = 2;
        _colorView.layer.masksToBounds = YES;
    }
    return _colorView;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}
@end

#pragma mark ------TTMStatisticsChartHeaderFooterModel------------------

@implementation TTMStatisticsChartHeaderFooterModel


@end

