//
//  TTMStatisticsFormView.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/22.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  表格视图
 */
@class TTMStatisticsFormSourceModel;
@interface TTMStatisticsFormView : UIView

@property (nonatomic, strong)TTMStatisticsFormSourceModel *sourceModel;//数据源

+ (CGFloat)formViewHeightWithArray:(NSArray *)array showHeader:(BOOL)showHeader;

- (instancetype)initWithFrame:(CGRect)frame showHeader:(BOOL)showHeader;

@end


@interface TTMStatisticsFormModel : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *content;

- (instancetype)initWIthTitle:(NSString *)title
                      content:(NSString *)content;
@end


@interface TTMStatisticsFormSourceModel : NSObject

@property (nonatomic, strong)NSArray *titleArray;//标题数组
@property (nonatomic, strong)NSArray *sourceArray;//表格数据数组

@end
