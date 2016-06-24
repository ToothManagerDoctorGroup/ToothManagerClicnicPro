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

/**
 *  查询椅位使用率
 *
 *  @param beginTime 开始时间
 *  @param endTime   结束时间
 *  @param complete  完成回调
 */
+ (void)queryChairUsageRateWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime complete:(CompleteBlock)complete;

/**
 *  查询预约事项所占百分比
 *
 *  @param beginTime 开始时间
 *  @param endTime   结束时间
 *  @param complete  完成回调
 */
+ (void)queryOrderItemRatioWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime complete:(CompleteBlock)complete;


/**
 *  查询收入
 *
 *  @param beginTime 开始时间
 *  @param endTime   结束时间
 *  @param complete  完成回调
 */
+ (void)queryIncomeWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime complete:(CompleteBlock)complete;


/**
 *  查询预约统计
 *
 *  @param beginTime 开始时间
 *  @param endTime   结束时间
 *  @param complete  完成回调
 */
+ (void)queryOrderIncrementWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime complete:(CompleteBlock)complete;

@end


/**
 *  医生预约量模型
 */
@interface TTMReserveAmountModel : NSObject

@property (nonatomic, copy)NSString *doctorId;
@property (nonatomic, copy)NSString *doctorName;
@property (nonatomic, strong)NSNumber *reserveCount;

@end

/**
 *  椅位使用率模型
 */
@interface TTMChairUsageRateModel : NSObject

@property (nonatomic, copy)NSString *curDate;
@property (nonatomic, copy)NSString *seatId;
@property (nonatomic, copy)NSString *seatName;
@property (nonatomic, strong)NSNumber *curRate;

@end

/**
 *  预约事项占百分比
 */
@interface TTMOrderItemRatioModel : NSObject

@property (nonatomic, copy)NSString *curType;
@property (nonatomic, strong)NSNumber *proportion;

@end


/**
 *  收入模型
 */
@interface TTMStatisticsIncomeModel : NSObject

@property (nonatomic, copy)NSString *curDate;
@property (nonatomic, strong)NSNumber *totalMoney;

@end

/**
 *  预约增量
 */
@interface TTMOrderIncrementModel : NSObject

@property (nonatomic, copy)NSString *curDate;
@property (nonatomic, strong)NSNumber *count;

@end