//
//  TTMRemoteNotificationManager.h
//  ToothManager
//
//  Created by Argo Zhang on 16/5/24.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  推送处理类
 */
@interface TTMRemoteNotificationManager : NSObject
Declare_ShareInstance(TTMRemoteNotificationManager);

- (void)didReceiveRemoteNotification:(NSDictionary *)userinfo;

@end
