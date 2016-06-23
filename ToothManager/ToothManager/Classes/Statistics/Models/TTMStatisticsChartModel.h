//
//  TTMStatisticsChartModel.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUChartConst.h"

@interface TTMStatisticsChartModel : NSObject

/**
 *  y轴数据（可以是多重数组）
 */
@property (nonatomic, strong)NSArray *axisYDataArray;
/**
 *  y轴标题范围
 */
@property (nonatomic, assign)CGRange axisYRange;
/**
 *  x轴标题数组
 */
@property (nonatomic, strong)NSArray *axisXTitles;
/**
 *  颜色数组
 */
@property (nonatomic, strong)NSArray *colors;
/**
 *  头视图数据(TTMStatisticsChartHeaderFooterModel)
 */
@property (nonatomic, strong)NSArray *headerSourceArray;
/**
 *  尾视图数据(TTMStatisticsChartHeaderFooterModel)
 */
@property (nonatomic, strong)NSArray *footerSourceArray;



@end
