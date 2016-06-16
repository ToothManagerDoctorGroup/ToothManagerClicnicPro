//
//  TTMPatientImageCell.h
//  ToothManager
//
//  Created by Argo Zhang on 16/5/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TTMPatientImageCell : UITableViewCell

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;

@property (nonatomic, strong)NSArray *imageList;//图片集合

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (CGFloat)cellHeightWithImageList:(NSArray *)imageList;

@end
