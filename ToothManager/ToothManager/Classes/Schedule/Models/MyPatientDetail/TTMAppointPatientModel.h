//
//  TTMAppointPatientModel.h
//  ToothManager
//
//  Created by Argo Zhang on 16/5/26.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  预约中患者详情
 */
@interface TTMAppointPatientModel : NSObject

@property (nonatomic, strong)NSArray *files;//医生上传的文件
@property (nonatomic, strong)NSNumber *patientAge;//患者年龄
@property (nonatomic, copy)NSString *patientGender;//患者性别
@property (nonatomic, copy)NSString *patientId;//患者id
@property (nonatomic, copy)NSString *patientName;//患者姓名

@end


@interface TTMAppointImageModel : NSObject

@property (nonatomic, copy)NSString *creation_time;//创建时间
@property (nonatomic, copy)NSString *doctor_id;//医生id
@property (nonatomic, copy)NSString *file_name;//文件名称
@property (nonatomic, copy)NSString *file_type;//文件类型
@property (nonatomic, copy)NSString *middleImgPath;//中等图片
@property (nonatomic, copy)NSString *reserverPath;//原图
@property (nonatomic, copy)NSString *reserver_id;//预约id
@property (nonatomic, copy)NSString *smallImgPath;//小图
@property (nonatomic, copy)NSString *thumbImgPath;//缩略图

@end
