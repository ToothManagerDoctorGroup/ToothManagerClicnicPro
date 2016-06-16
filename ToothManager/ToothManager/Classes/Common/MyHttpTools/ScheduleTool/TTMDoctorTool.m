//
//  TTMDoctorTool.m
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import "TTMDoctorTool.h"
#import "TTMMyHttpTool.h"

@implementation TTMDoctorTool

+ (void)requestDoctorInfoWithDoctorId:(NSString *)doctorId success:(void (^)(TTMDoctorModel *))success failure:(void (^)(NSError *))failure{

    NSString *urlStr = [NSString stringWithFormat:@"%@his.crm/ashx/DoctorInfoHandler.ashx",DomainName];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getdatabyid";
    params[@"userid"] = doctorId;
    
    [TTMMyHttpTool GET:urlStr parameters:params success:^(id responseObject) {
        
        TTMDoctorModel *doctorInfo = [TTMDoctorModel objectWithKeyValues:[responseObject[@"Result"] lastObject]];
        if (success) {
            success(doctorInfo);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取预约的详细信息
 *
 *  @param reserveId 预约id
 *  @param patientId 患者id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)getAppointmentDetailWithReserveId:(NSString *)reserveId patientId:(NSString *)patientId success:(void(^)(TTMResponseModel *respond))success failure:(void(^)(NSError *error))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"getPatientAndFiles";
    params[@"reserver_id"] = reserveId;
    params[@"patient_id"] =  patientId;
    
    [TTMMyHttpTool GET:QueryScheduleListURL parameters:params success:^(id responseObject) {
        
        TTMResponseModel *respond = [TTMResponseModel objectWithKeyValues:responseObject];
        if (success) {
            success(respond);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
