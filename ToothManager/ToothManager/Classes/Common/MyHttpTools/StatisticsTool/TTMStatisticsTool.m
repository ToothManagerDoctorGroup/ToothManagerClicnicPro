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

@end



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