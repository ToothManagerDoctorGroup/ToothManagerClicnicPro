//
//  TTMAppointPatientModel.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/26.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMAppointPatientModel.h"
#import "MJExtension.h"

@implementation TTMAppointPatientModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"files" : @"Files",
             @"patientAge" : @"PatientAge",
             @"patientGender" : @"PatientGender",
             @"patientId" : @"PatientId",
             @"patientName" : @"PatientName"};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"files" : [TTMAppointImageModel class]};
}


@end


@implementation TTMAppointImageModel


@end
