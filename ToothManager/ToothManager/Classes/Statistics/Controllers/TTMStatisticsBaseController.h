//
//  TTMStatisticsBaseController.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMBaseColorController.h"
#import "TTMStatisticsChartView.h"

@class XLTagView;
@interface TTMStatisticsBaseController : TTMBaseColorController<TTMStatisticsChartViewDataSource>

@property (nonatomic, assign)StatisticsChartStyle style;

@property (nonatomic, strong)NSArray *formSourceArray;

- (void)exportButtonAction;


@end
