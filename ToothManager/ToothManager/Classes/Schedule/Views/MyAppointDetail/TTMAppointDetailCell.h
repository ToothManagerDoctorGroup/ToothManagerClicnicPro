//
//  TTMAppointDetailCell.h
//  ToothManager
//
//  Created by Argo Zhang on 16/5/23.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTMAppointDetailCellModel;
@interface TTMAppointDetailCell : UITableViewCell

@property (nonatomic, strong)TTMAppointDetailCellModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeightWithContent:(NSString *)content;

@end
