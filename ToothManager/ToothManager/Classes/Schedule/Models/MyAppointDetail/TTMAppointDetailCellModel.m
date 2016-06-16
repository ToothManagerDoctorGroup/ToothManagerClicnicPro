//
//  TTMAppointDetailCellModel.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/23.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMAppointDetailCellModel.h"

@implementation TTMAppointDetailCellModel

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content{
    if (self = [super init]) {
        self.title = title;
        self.content = content;
        self.showArrow = NO;
        self.contentColor = [UIColor blackColor];
    }
    return self;
}


@end
