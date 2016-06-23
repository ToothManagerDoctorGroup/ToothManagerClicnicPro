//
//  TTMAppointStartViewController.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/17.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMBaseColorController.h"
#import "TTMApointmentModel.h"
/**
 *  预约开始（包括待计时，计时中，收费待确认，待收费）
 */
@interface TTMAppointStartViewController : TTMBaseColorController

@property (nonatomic, assign)TTMApointmentStatus status;

@end
