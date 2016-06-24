//
//  TTMStatisticsChartView.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMStatisticsChartView.h"
#import "TTMStatisticsChartHeaderFooterView.h"
#import "UIColor+TTMAddtion.h"
#import "TTMStatisticsChartModel.h"
#import "ZFChart.h"

#define kChartViewHeight 200
#define kMargin 10
#define kHeaderFooterDefaultHeight 44

@interface TTMStatisticsChartView ()<ZFGenericChartDataSource,ZFBarChartDelegate,ZFLineChartDelegate,ZFPieChartDataSource>

@property (nonatomic, strong)ZFBarChart *barChart;
@property (nonatomic, strong)ZFLineChart *lineChart;
@property (nonatomic, strong)ZFPieChart *pieChart;

@property (nonatomic, strong)TTMStatisticsChartHeaderFooterView *headerView;
@property (nonatomic, strong)TTMStatisticsChartHeaderFooterView *footerView;
@property (nonatomic, strong)UIView *container;

@property (nonatomic, assign)StatisticsChartStyle style;
@property (assign, nonatomic) id<TTMStatisticsChartViewDataSource> dataSource;

@property (nonatomic, strong)TTMStatisticsChartModel *currentChartModel;

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
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setUpChart];
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 设置图表视图
- (void)setUpChart{
    
     self.currentChartModel = [self.dataSource chartViewSourceArrayForChart:self];
    
    //添加图表视图
    [self addSubview:self.container];
    //判断是否显示头视图和尾部视图
    if ([self.dataSource respondsToSelector:@selector(chartViewShowHeaderView:)] && [self.dataSource chartViewShowHeaderView:self]) {
        //设置头视图
        [self addSubview:self.headerView];
    }
    
    if ([self.dataSource respondsToSelector:@selector(chartViewShowFooterView:)] && [self.dataSource chartViewShowFooterView:self]) {
        //设置尾视图
        [self addSubview:self.footerView];
    }
    
    //设置图表视图
    [self setUpChartView];
    //设置约束
    [self setUpContrains];
    
}
#pragma mark 设置图表视图
- (void)setUpChartView{
    switch (self.style) {
        case StatisticsChartStyleBar:
        {
            [self.container addSubview:self.barChart];
        }
            break;
        case StatisticsChartStyleLine:
        {
            [self.container addSubview:self.lineChart];
        }
            break;
        case StatisticsChartStylePie:
        {
            [self.container addSubview:self.pieChart];
        }
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.currentChartModel) {
        return;
    }
    switch (self.style) {
        case StatisticsChartStyleBar:
        {
            [self.barChart strokePath];
        }
            break;
        case StatisticsChartStyleLine:
        {
            [self.lineChart strokePath];
        }
            break;
        case StatisticsChartStylePie:
        {
            [self.pieChart strokePath];
        }
            break;
    }
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
#pragma mark -ZFGenericChartDataSource
- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return self.currentChartModel.axisYDataArray;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return self.currentChartModel.axisXTitles;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return self.currentChartModel.colors;
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return self.currentChartModel.maxValue;
}

- (NSInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart{
    return self.currentChartModel.ySection;
}

#pragma mark - ZFPieChartDataSource

- (NSArray *)valueArrayInPieChart:(ZFPieChart *)chart{
    return self.currentChartModel.axisYDataArray;
}

- (NSArray *)nameArrayInPieChart:(ZFPieChart *)chart{
    return self.currentChartModel.axisXTitles;
}

- (NSArray *)colorArrayInPieChart:(ZFPieChart *)chart{
    return self.currentChartModel.colors;
}


#pragma mark - ********************* Lazy Method ***********************
- (ZFBarChart *)barChart{
    if (!_barChart) {
        _barChart = [[ZFBarChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kChartViewHeight)];
        _barChart.dataSource = self;
        _barChart.delegate = self;
        _barChart.isShowSeparate = YES;
    }
    return _barChart;
}

- (ZFLineChart *)lineChart{
    if (!_lineChart) {
        _lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kChartViewHeight)];
        _lineChart.dataSource = self;
        _lineChart.delegate = self;
        _lineChart.topicColor = ZFPurple;
        _lineChart.isResetAxisLineMinValue = YES;
        _lineChart.isShowSeparate = YES;
    }
    return _lineChart;
}

- (ZFPieChart *)pieChart{
    if (!_pieChart) {
        _pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kChartViewHeight)];
        _pieChart.dataSource = self;
        _pieChart.piePatternType = kPieChartPatternTypeForCircle;
        _pieChart.isShadow = NO;
        _pieChart.userInteractionEnabled = NO;
        _pieChart.isShowPercent = NO;
    }
    return _pieChart;
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
        _footerView.maxNumOneLine = 3;
    }
    return _footerView;
}

@end
