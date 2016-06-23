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
@interface TTMStatisticsFormView : UIView

@property (nonatomic, strong)NSArray *sourceArray;

+ (CGFloat)formViewHeightWithArray:(NSArray *)array;

@end


@interface TTMStatisticsFormModel : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *content;

- (instancetype)initWIthTitle:(NSString *)title
                      content:(NSString *)content;
@end
