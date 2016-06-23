//
//  TTMCustomDateView.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  自定义时间视图
 */

typedef void(^CustomDateButtonBlock)(NSString *startTime,NSString *endTime);
@interface TTMCustomDateView : UIView

@property (nonatomic, copy)CustomDateButtonBlock buttonBlock;

@end
