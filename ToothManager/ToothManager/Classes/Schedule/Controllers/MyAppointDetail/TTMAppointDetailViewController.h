//
//  TTMAppointDetailViewController.h
//  ToothManager
//
//  Created by Argo Zhang on 16/5/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMBaseColorController.h"

extern NSString *const kTTMAppointStateChangedNotification;

@class TTMScheduleCellModel;
@interface TTMAppointDetailViewController : TTMBaseColorController

/**
 *  传递的model
 */
@property (nonatomic, strong) TTMScheduleCellModel *model;

@end
