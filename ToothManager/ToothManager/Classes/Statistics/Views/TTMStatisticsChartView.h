//
//  TTMStatisticsChartView.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@protocol TTMStatisticsChartViewDataSource;
@class TTMStatisticsChartModel,TTMStatisticsChartHeaderFooterView;
typedef NS_ENUM(NSInteger,StatisticsChartStyle){
    StatisticsChartStyleLine,//折线图
    StatisticsChartStyleBar, //条形图
    StatisticsChartStylePie  //饼状图
};

/**
 *  图表视图
 */
@interface TTMStatisticsChartView : UIView

@property (nonatomic, strong)MASViewAttribute *bottomContraints;

- (instancetype)initWithFrame:(CGRect)frame dataSource:(id<TTMStatisticsChartViewDataSource>)dataSource style:(StatisticsChartStyle)style;

- (void)reloadData;


@end

@protocol TTMStatisticsChartViewDataSource <NSObject>

@required
//图表的数据源方法
- (TTMStatisticsChartModel *)chartViewSourceArrayForChart:(TTMStatisticsChartView *)chartView;

@optional
//是否显示头视图
- (BOOL)chartViewShowHeaderView:(TTMStatisticsChartView *)chartView;
//是否显示底部视图
- (BOOL)chartViewShowFooterView:(TTMStatisticsChartView *)chartView;

@end
