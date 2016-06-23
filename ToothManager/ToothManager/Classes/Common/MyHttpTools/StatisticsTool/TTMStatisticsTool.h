//
//  TTMStatisticsTool.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/22.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMStatisticsTool : NSObject
/**
 *  查询医生预约量
 *
 *  @param beginTime 开始时间
 *  @param endTime   结束时间
 *  @param complete  完成回调
 */
+ (void)queryDoctorReserveAmountWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime complete:(CompleteBlock)complete;


@end


/**
 *  医生预约量模型
 */
@interface TTMReserveAmountModel : NSObject

@property (nonatomic, copy)NSString *doctorId;
@property (nonatomic, copy)NSString *doctorName;
@property (nonatomic, strong)NSNumber *reserveCount;


@end