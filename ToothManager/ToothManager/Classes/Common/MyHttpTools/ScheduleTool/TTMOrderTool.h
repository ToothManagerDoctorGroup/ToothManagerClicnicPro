//
//  TTMOrderTool.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTMOrderQueryModel;
@interface TTMOrderTool : NSObject
/**
 *  查询预约列表
 *
 *  @param queryModel 查询条件
 *  @param complete   完成回调
 */
+ (void)queryAppointmentListWithQueryModel:(TTMOrderQueryModel *)queryModel complete:(CompleteBlock)complete;

@end



/**
 *  预约查询model
 */
@interface TTMOrderQueryModel : NSObject

@property (nonatomic, copy)NSString *clinicId;      //诊所id
@property (nonatomic, copy)NSString *reserverStatus;//预约状态
@property (nonatomic, copy)NSString *reserverTime;  //预约时间
@property (nonatomic, copy)NSString *seatId;        //椅位id
@property (nonatomic, copy)NSString *keyWord;       //关键字
@property (nonatomic, copy)NSString *sortField;     //排序字段
@property (nonatomic, assign)BOOL isAsc;            //是否升序
@property (nonatomic, assign)int pageIndex;         //页码
@property (nonatomic, assign)int pageSize;          //每页显示数量

- (instancetype)initWithReserveStatus:(NSString *)reserveStatus
                               seatId:(NSString *)seatId
                            pageIndex:(int)pageIndex
                             pageSize:(int)pageSize;

@end