//
//  TTMLoginTool.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/26.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMLoginTool.h"
#import "TTMMyHttpTool.h"

@implementation TTMLoginTool

/**
 *  退出程序时，更新registerId
 *
 *  @param clinicId    诊所
 *  @param devicetoken devicetoken
 *  @param success     成功回调
 *  @param failure     失败回调
 */
+ (void)logoutOfUpdateRegisterIdWithClinicId:(NSString *)clinicId devicetoken:(NSString *)devicetoken success:(void(^)(TTMResponseModel *respond))success failure:(void(^)(NSError *error))failure{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"updatedevicetoken";
    params[@"keyid"] = clinicId;
    params[@"devicetoken"] = devicetoken;
    
    [TTMMyHttpTool POST:UserURL parameters:params success:^(id responseObject) {
        TTMResponseModel *model = [TTMResponseModel objectWithKeyValues:responseObject];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
