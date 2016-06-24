//
//  TTMStatisticsChartModel.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMStatisticsChartModel : NSObject

/**
 *  y轴数据（可以是多重数组）
 */
@property (nonatomic, strong)NSArray *axisYDataArray;

/**
 *  Y轴最大值
 */
@property (nonatomic, assign)CGFloat maxValue;
/**
 *  y轴分段数
 */
@property (nonatomic, assign)NSInteger ySection;

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
