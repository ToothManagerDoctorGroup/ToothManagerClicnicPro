//
//  TTMStatisticsTool.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/22.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMStatisticsTool.h"

@implementation TTMStatisticsTool


/**
 *  查询医生预约量
 *
 *  @param beginTime 开始时间
 *  @param endTime   结束时间
 *  @param complete  完成回调
 */
+ (void)queryDoctorReserveAmountWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime complete:(CompleteBlock)complete{
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"DoctorReserveAmount" forKey:@"action"];
    [param setObject:user.keyId forKey:@"clinic_id"];
    [param setObject:beginTime forKey:@"begin_time"];
    [param setObject:endTime forKey:@"end_time"];
    
    [TTMNetwork getWithURL:QueryClinicChartURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in rows) {
                TTMReserveAmountModel *model = [TTMReserveAmountModel objectWithKeyValues:dict];
                [mutArray addObject:model];
            }
            complete(mutArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}


/**
 *  查询椅位使用率
 *
 *  @param beginTime 开始时间
 *  @param endTime   结束时间
 *  @param complete  完成回调
 */
+ (void)queryChairUsageRateWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime complete:(CompleteBlock)complete{
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"SeatUseageRate" forKey:@"action"];
    [param setObject:user.keyId forKey:@"clinic_id"];
    [param setObject:beginTime forKey:@"begin_time"];
    [param setObject:endTime forKey:@"end_time"];
    
    
    [TTMNetwork getWithURL:QueryClinicChartURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSArray *tempArr in rows) {
                //@[@[],@[]];
                NSMutableArray *subArray = [NSMutableArray array];
                for (NSDictionary *dic in tempArr) {
                    TTMChairUsageRateModel *rateModel = [TTMChairUsageRateModel objectWithKeyValues:dic];
                    [subArray addObject:rateModel];
                }
                [mutArray addObject:subArray];
            }
            complete(mutArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}


/**
 *  查询预约事项所占百分比
 *
 *  @param beginTime 开始时间
 *  @param endTime   结束时间
 *  @param complete  完成回调
 */
+ (void)queryOrderItemRatioWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime complete:(CompleteBlock)complete{
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"ReserveItemProportion" forKey:@"action"];
    [param setObject:user.keyId forKey:@"clinic_id"];
    [param setObject:beginTime forKey:@"begin_time"];
    [param setObject:endTime forKey:@"end_time"];
    
    [TTMNetwork getWithURL:QueryClinicChartURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dic in rows) {
                TTMOrderItemRatioModel *rateModel = [TTMOrderItemRatioModel objectWithKeyValues:dic];
                [mutArray addObject:rateModel];
            }
            complete(mutArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

/**
 *  查询收入
 *
 *  @param beginTime 开始时间
 *  @param endTime   结束时间
 *  @param complete  完成回调
 */
+ (void)queryIncomeWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime complete:(CompleteBlock)complete{
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"ClinicIncomeStat" forKey:@"action"];
    [param setObject:user.keyId forKey:@"clinic_id"];
    [param setObject:beginTime forKey:@"begin_time"];
    [param setObject:endTime forKey:@"end_time"];
    
    [TTMNetwork getWithURL:QueryClinicChartURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dic in rows) {
                TTMStatisticsIncomeModel *incomeModel = [TTMStatisticsIncomeModel objectWithKeyValues:dic];
                [mutArray addObject:incomeModel];
            }
            complete(mutArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

/**
 *  查询预约统计
 *
 *  @param beginTime 开始时间
 *  @param endTime   结束时间
 *  @param complete  完成回调
 */
+ (void)queryOrderIncrementWithBeginTime:(NSString *)beginTime endTime:(NSString *)endTime complete:(CompleteBlock)complete{
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"ReserveIncrement" forKey:@"action"];
    [param setObject:user.keyId forKey:@"clinic_id"];
    [param setObject:beginTime forKey:@"begin_time"];
    [param setObject:endTime forKey:@"end_time"];
    
    [TTMNetwork getWithURL:QueryClinicChartURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dic in rows) {
                TTMOrderIncrementModel *incrementModel = [TTMOrderIncrementModel objectWithKeyValues:dic];
                [mutArray addObject:incrementModel];
            }
            complete(mutArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

@end


#pragma mark --------------------------model------------------------------
/**
 *  医生预约量模型
 */
@implementation TTMReserveAmountModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"doctorId" : @"DoctorId",
             @"doctorName" : @"DoctorName",
             @"reserveCount" : @"ReserveCount"};
}

@end

/**
 *  椅位使用率模型
 */
@implementation TTMChairUsageRateModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"curDate" : @"CurDate",
             @"seatId" : @"SeatId",
             @"seatName" : @"SeatName",
             @"curRate" : @"CurRate"};
}

@end

/**
 *  预约事项占百分比
 */
@implementation TTMOrderItemRatioModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"curType" : @"CurType",
             @"proportion" : @"Proportion"};
}

@end

/**
 *  收入统计
 */
@implementation TTMStatisticsIncomeModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"curDate" : @"CurDate",
             @"totalMoney" : @"TotalMoney"};
}

@end

/**
 *  预约增量
 */
@implementation TTMOrderIncrementModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"curDate" : @"CurDate",
             @"count" : @"Count"};
}

@end