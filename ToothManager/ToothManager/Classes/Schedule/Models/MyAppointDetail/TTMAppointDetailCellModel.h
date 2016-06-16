//
//  TTMAppointDetailCellModel.h
//  ToothManager
//
//  Created by Argo Zhang on 16/5/23.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTMAppointDetailCellModel : NSObject

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *content;

@property (nonatomic, strong)UIColor *contentColor;
@property (nonatomic, assign)BOOL showArrow;


- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content;

@end
