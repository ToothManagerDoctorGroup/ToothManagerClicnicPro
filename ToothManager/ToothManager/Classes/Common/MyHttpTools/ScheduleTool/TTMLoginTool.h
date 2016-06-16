//
//  TTMLoginTool.h
//  ToothManager
//
//  Created by Argo Zhang on 16/5/26.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TTMLoginTool : NSObject
/**
 *  退出程序时，更新registerId
 www.ibeituan.com/clinicServer/ashx/SysUserHandler.ashx?action=updatedevicetoken&keyid=123&devicetoken=lkjsdfjioew2
 *
 *  @param clinicId    诊所
 *  @param devicetoken devicetoken
 *  @param success     成功回调
 *  @param failure     失败回调
 */
+ (void)logoutOfUpdateRegisterIdWithClinicId:(NSString *)clinicId devicetoken:(NSString *)devicetoken success:(void(^)(TTMResponseModel *respond))success failure:(void(^)(NSError *error))failure;

@end
