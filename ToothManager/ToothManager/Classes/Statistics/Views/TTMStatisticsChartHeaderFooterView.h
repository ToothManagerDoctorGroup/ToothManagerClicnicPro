//
//  TTMStatisticsChartHeaderFooterView.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  图表视图的头视图和尾视图
 */
@interface TTMStatisticsChartHeaderFooterView : UIView

@property (nonatomic, assign)NSInteger maxNumOneLine;//一行显示的最大个数

@property (nonatomic, strong)NSArray *dataArray;//数据源

- (CGFloat)headerFooterHeightWithArray:(NSArray *)sourceArray;

@end


//列表item视图
@interface TTMStatisticsChartHeaderFooterItemView : UIView

- (instancetype)initColor:(UIColor *)color content:(NSString *)content;

@end


//模型
@interface TTMStatisticsChartHeaderFooterModel : NSObject

@property (nonatomic, strong)UIColor *color;
@property (nonatomic, copy)NSString *content;

@end