//
//  TTMStatisticsDateTagView.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StatisticsDateSelectBlock)(NSString *startTime,NSString *endTime);

/**
 *  日期选择
 */
@interface TTMStatisticsDateTagView : UIView

@property (nonatomic, copy)StatisticsDateSelectBlock dateSelectBlock;

@end
