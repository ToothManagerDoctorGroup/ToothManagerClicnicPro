//
//  TTMDoctorTool.h
//  ToothManager
//
//  Created by Argo Zhang on 15/12/8.
//  Copyright © 2015年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTMDoctorModel.h"

@interface TTMDoctorTool : NSObject

/*获取医生的详细信息*/
+ (void)requestDoctorInfoWithDoctorId:(NSString *)doctorId success:(void(^)(TTMDoctorModel *dcotorInfo))success failure:(void(^)(NSError *error))failure;

/**
 *  获取预约的详细信息
 *
 *  @param reserveId 预约id
 *  @param patientId 患者id
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+ (void)getAppointmentDetailWithReserveId:(NSString *)reserveId patientId:(NSString *)patientId success:(void(^)(TTMResponseModel *respond))success failure:(void(^)(NSError *error))failure;

@end
