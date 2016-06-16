//
//  TTMScheduleDetailController.h
//  ToothManager
//

#import "TTMBaseColorController.h"
@class TTMScheduleCellModel;


extern NSString *const kTTMScheduleDetailAppointStateChangedNotification;
/**
 *  预约详情Controller
 */
@interface TTMScheduleDetailController : TTMBaseColorController
/**
 *  传递的model
 */
@property (nonatomic, strong) TTMScheduleCellModel *model;

@end
