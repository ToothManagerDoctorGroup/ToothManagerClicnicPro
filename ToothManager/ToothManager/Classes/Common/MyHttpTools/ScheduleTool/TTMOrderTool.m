//
//  TTMOrderTool.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMOrderTool.h"
#import "TTMApointmentModel.h"

@implementation TTMOrderTool

/**
 *  查询预约列表
 *
 *  @param queryModel 查询条件
 *  @param complete   完成回调
 */
+ (void)queryAppointmentListWithQueryModel:(TTMOrderQueryModel *)queryModel complete:(CompleteBlock)complete{
    TTMUser *user = [TTMUser unArchiveUser];
    // 必填项
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:user.accessToken forKey:@"accessToken"];
    [param setObject:@"listbyparam" forKey:@"action"];
    [param setObject:[queryModel.keyValues JSONString] forKey:@"QueryModel"];
    
    [TTMNetwork getWithURL:QueryAppointmentListURL params:param success:^(id responseObject) {
        TTMResponseModel *response = [TTMResponseModel objectWithKeyValues:responseObject];
        if (response.code == kSuccessCode) {
            NSArray *rows = response.result;
            NSMutableArray *mutArray = [NSMutableArray array];
            for (NSDictionary *dict in rows) {
                TTMApointmentModel *model = [TTMApointmentModel objectWithKeyValues:dict];
                model.used_time = [model.used_time hourMinutesTimeFormat];
                [mutArray addObject:model];
            }
            
            NSMutableArray *tempArray = [NSMutableArray array];
            NSEnumerator *enumerator = [mutArray objectEnumerator];
            TTMApointmentModel *tempModel = nil;
            while (tempModel = [enumerator nextObject]) {
                [tempArray addObject:tempModel];
            }
            complete(tempArray);
        } else {
            complete(response.result);
        }
    } failure:^(NSError *error) {
        complete(NetError);
    }];
}

@end


@implementation TTMOrderQueryModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"clinicId" : @"ClinicId",
             @"reserverStatus" : @"ReserverStatus",
             @"reserverTime" : @"ReserverTime",
             @"seatId" : @"SeatId",
             @"keyWord" : @"KeyWord",
             @"sortField" : @"SortField",
             @"isAsc" : @"IsAsc",
             @"pageIndex" : @"PageIndex",
             @"pageSize" : @"PageSize"};
}

- (instancetype)initWithReserveStatus:(NSString *)reserveStatus
                               seatId:(NSString *)seatId
                            pageIndex:(int)pageIndex
                             pageSize:(int)pageSize{
    if (self = [super init]) {
        TTMUser *user = [TTMUser unArchiveUser];
        self.clinicId = user.keyId;
        self.reserverStatus = reserveStatus;
        self.reserverTime = @"";
        self.seatId = seatId;
        self.keyWord = @"";
        self.sortField = @"";
        self.isAsc = YES;
        self.pageIndex = pageIndex;
        self.pageSize = pageSize;
    }
    return self;
}

@end
