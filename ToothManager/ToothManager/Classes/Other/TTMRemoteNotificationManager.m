//
//  TTMRemoteNotificationManager.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/24.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMRemoteNotificationManager.h"

@implementation TTMRemoteNotificationManager
Realize_ShareInstance(TTMRemoteNotificationManager);

- (void)didReceiveRemoteNotification:(NSDictionary *)userinfo {
    NSDictionary *aps = [userinfo objectForKey:@"aps"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"消息提醒" message:[aps objectForKey:@"alert"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
