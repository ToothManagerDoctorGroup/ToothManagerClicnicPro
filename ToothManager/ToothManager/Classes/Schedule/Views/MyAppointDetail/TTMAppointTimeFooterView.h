//
//  TTMAppointTimeFooterView.h
//  ToothManager
//
//  Created by Argo Zhang on 16/5/23.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTMAppointTimeFooterView,TTMScheduleCellModel;
@protocol TTMAppointTimeFooterViewDelegate <NSObject>

@optional
- (void)appointTimeFooterView:(TTMAppointTimeFooterView *)footerView didClickTimeButton:(UIButton *)button;

@end

@interface TTMAppointTimeFooterView : UIView

@property (nonatomic, strong)TTMScheduleCellModel *model;

@property (nonatomic, weak)id<TTMAppointTimeFooterViewDelegate> delegate;
@end
