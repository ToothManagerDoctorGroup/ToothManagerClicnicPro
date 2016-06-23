//
//  TTMStatisticsChartView.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMStatisticsChartView.h"
#import "UUChart.h"
#import "TTMStatisticsChartHeaderFooterView.h"
#import "UIColor+TTMAddtion.h"
#import "TTMStatisticsChartModel.h"

#define kChartViewHeight 150
#define kMargin 10
#define kHeaderFooterDefaultHeight 44

@interface TTMStatisticsChartView ()<UUChartDataSource>
@property (nonatomic, strong)UUChart *uuChartView;
@property (nonatomic, strong)TTMStatisticsChartHeaderFooterView *headerView;
@property (nonatomic, strong)TTMStatisticsChartHeaderFooterView *footerView;
@property (nonatomic, strong)UIView *container;

@property (nonatomic, assign)StatisticsChartStyle style;
@property (assign, nonatomic) id<TTMStatisticsChartViewDataSource> dataSource;

@end

@implementation TTMStatisticsChartView


- (instancetype)initWithFrame:(CGRect)frame dataSource:(id<TTMStatisticsChartViewDataSource>)dataSource style:(StatisticsChartStyle)style{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = dataSource;
        self.style = style;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithHex:0xeeeeee].CGColor;
        
        if ([self.dataSource respondsToSelector:@selector(chartViewSourceArrayForChart:)] && [self.dataSource chartViewSourceArrayForChart:self]) {
            //设置图表视图
            [self setUpChart];
        }
        
    }
    return self;
}

#pragma mark - ********************* Public Method ***********************
- (void)reloadData{
    //移除之前的子视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.container = nil;
    self.uuChartView = nil;
    self.headerView = nil;
    self.footerView = nil;
    
    [self setUpChart];
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 设置图表视图
- (void)setUpChart{
    //添加图表视图
    [self addSubview:self.container];
    [self.uuChartView showInView:self.container];
    //判断是否显示头视图和尾部视图
    if ([self.dataSource respondsToSelector:@selector(chartViewShowHeaderView:)] && [self.dataSource chartViewShowHeaderView:self]) {
        //设置头视图
        [self addSubview:self.headerView];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewShowFooterView:)] && [self.dataSource chartViewShowFooterView:self]) {
        //设置尾视图
        [self addSubview:self.footerView];
    }
    
    //设置约束
    [self setUpContrains];
}
#pragma mark 设置约束
- (void)setUpContrains{
    BOOL hasHeader = [self.dataSource respondsToSelector:@selector(chartViewShowHeaderView:)] && [self.dataSource chartViewShowHeaderView:self];
    BOOL hasFooter = [self.dataSource respondsToSelector:@selector(chartViewShowFooterView:)] && [self.dataSource chartViewShowFooterView:self];
    [self.container mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, kChartViewHeight));
        
        if (hasHeader) {
            make.top.equalTo(self.headerView.mas_bottom);
        }else{
            make.top.equalTo(self);
        }
    }];
    self.bottomContraints = self.container.mas_bottom;
    
    TTMStatisticsChartModel *model = [self.dataSource chartViewSourceArrayForChart:self];
    if (hasHeader) {
        [self.headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.equalTo(self);
            make.height.mas_equalTo([self.headerView headerFooterHeightWithArray:model.headerSourceArray]);
        }];
        self.headerView.dataArray = model.headerSourceArray;
    }
    
    if (hasFooter) {
        [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.top.equalTo(self.container.mas_bottom).offset(kMargin);
            make.height.mas_equalTo([self.footerView headerFooterHeightWithArray:model.footerSourceArray]);
        }];
        self.bottomContraints = self.footerView.mas_bottom;
        self.footerView.dataArray = model.footerSourceArray;
        
    }
}

#pragma mark - ******************* Delegate / DataSource ********************
#pragma mark UUChartDataSource
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart{
    TTMStatisticsChartModel *model = [self.dataSource chartViewSourceArrayForChart:self];
    return model.axisXTitles;
}

- (NSArray *)chartConfigAxisYValue:(UUChart *)chart{
    TTMStatisticsChartModel *model = [self.dataSource chartViewSourceArrayForChart:self];
    return model.axisYDataArray;
}

#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    TTMStatisticsChartModel *model = [self.dataSource chartViewSourceArrayForChart:self];
    return model.colors;
}
//显示数值范围
- (CGRange)chartRange:(UUChart *)chart
{
    TTMStatisticsChartModel *model = [self.dataSource chartViewSourceArrayForChart:self];
    return model.axisYRange;
}


#pragma mark - ********************* Lazy Method ***********************
- (UUChart *)uuChartView{
    if (!_uuChartView) {
        if (self.style == StatisticsChartStyleLine) {
            _uuChartView = [[UUChart alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kChartViewHeight) dataSource:self style:UUChartStyleLine];
        }else{
            _uuChartView = [[UUChart alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kChartViewHeight) dataSource:self style:UUChartStyleBar];
        }
    }
    return _uuChartView;
}

- (UIView *)container{
    if (!_container) {
        _container = [[UIView alloc] init];
    }
    return _container;
}

- (TTMStatisticsChartHeaderFooterView *)headerView{
    if (!_headerView) {
        _headerView = [[TTMStatisticsChartHeaderFooterView alloc] init];
    }
    return _headerView;
}

- (TTMStatisticsChartHeaderFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[TTMStatisticsChartHeaderFooterView alloc] init];
    }
    return _footerView;
}


@end
