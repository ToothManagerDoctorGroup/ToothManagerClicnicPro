//
//  TTMStatisticsBaseController.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMBaseColorController.h"
#import "TTMStatisticsChartView.h"

@class XLTagView,TTMStatisticsFormSourceModel;
@interface TTMStatisticsBaseController : TTMBaseColorController<TTMStatisticsChartViewDataSource>

//统计图的样式
@property (nonatomic, assign)StatisticsChartStyle style;

//是否显示表格数据的头视图
@property (nonatomic, assign)BOOL showFormViewHeader;

//表格数据的数据源
@property (nonatomic, strong)TTMStatisticsFormSourceModel *formSourceModel;

//导出
- (void)exportButtonAction;

//选择时间
- (void)selectDateWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

@end
