//
//  TTMAppointTimeFooterView.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/23.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMAppointTimeFooterView.h"
#import "TTMScheduleCellModel.h"
#import "UIColor+TTMAddtion.h"
#import "NSString+TTMAddtion.h"

@interface TTMAppointTimeFooterView ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (nonatomic, strong) NSTimer *timer; // 倒计时

@end

@implementation TTMAppointTimeFooterView

- (void)awakeFromNib{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
}

- (void)setModel:(TTMScheduleCellModel *)model{
    _model = model;
    
    switch (model.reserve_status) {
        case TTMApointmentStatusNotStart: {
            [self.timeButton setTitle:@"开始计时" forState:UIControlStateNormal];
            break;
        }
        case TTMApointmentStatusStarting: {
            [self.timeButton setTitle:@"结束计时" forState:UIControlStateNormal];
            self.timeButton.backgroundColor = [UIColor colorWithHex:0xfeb527];
            NSString *timeStr = [NSString stringWithFormat:@"共用时：%@", [model.actual_start_time timeToNow]];
            _timeLabel.attributedText = [self rangeStrOfTargetStr:timeStr];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                          target:self
                                                        selector:@selector(updateTimeLabel)
                                                        userInfo:nil
                                                         repeats:YES];
            break;
        }
        case TTMApointmentStatusWaitPay: {
            [self invalidateTimer];
            
            [self.timeButton setTitle:@"等待付款" forState:UIControlStateNormal];
            [self.timeButton setImage:[UIImage imageNamed:@"clinic_schedule_pay_loading"] forState:UIControlStateNormal];
            [self.timeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            NSString *timeStr = [NSString stringWithFormat:@"共用时：%@\n总费用：%@元", [model.used_time hourMinutesTimeFormat],model.total_money];
            _timeLabel.attributedText = [self rangeStrOfTargetStr:timeStr];
            break;
        }
        case TTMApointmentStatusEnded: {
            [self invalidateTimer];
            
            [self.timeButton setTitle:@"费用确认" forState:UIControlStateNormal];
            self.timeButton.backgroundColor = [UIColor colorWithHex:0xfeb527];
            
            NSString *timeStr = [NSString stringWithFormat:@"共用时：%@\n总费用：%@元", [model.used_time hourMinutesTimeFormat],model.total_money];
            _timeLabel.attributedText = [self rangeStrOfTargetStr:timeStr];
            break;
        }
        case TTMApointmentStatusComplete: {
            [self invalidateTimer];
            
            [self.timeButton setTitle:@"已完成" forState:UIControlStateNormal];
            [self.timeButton setTitleColor:[UIColor colorWithHex:0xfedd27] forState:UIControlStateNormal];
            self.timeButton.backgroundColor = [UIColor clearColor];
            [self.timeButton setImage:[UIImage imageNamed:@"clinic_schedule_pay_end"] forState:UIControlStateNormal];
            [self.timeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
            
            NSString *timeStr = [NSString stringWithFormat:@"共用时：%@\n总费用：%@元", [model.used_time hourMinutesTimeFormat],model.total_money];
            _timeLabel.attributedText = [self rangeStrOfTargetStr:timeStr];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)updateTimeLabel {
    NSString *timeStr = [NSString stringWithFormat:@"共用时：%@", [self.model.actual_start_time timeToNow]];
    self.timeLabel.attributedText = [self rangeStrOfTargetStr:timeStr];
}

- (void)dealloc{
    [self invalidateTimer];
}

- (void)invalidateTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (IBAction)timeAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(appointTimeFooterView:didClickTimeButton:)]) {
        [self.delegate appointTimeFooterView:self didClickTimeButton:sender];
    }
}


#pragma mark 设置不同字体颜色
- (NSMutableAttributedString *)rangeStrOfTargetStr:(NSString *)targetStr{
    NSMutableAttributedString *mStr = [[NSMutableAttributedString alloc] initWithString:targetStr];
    if ([targetStr isContainsString:@"共用时："]) {
        NSUInteger location = [targetStr indexOfString:@"共用时："];
        [mStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x2abcc6] range:NSMakeRange(location, 4)];
    }
    if ([targetStr isContainsString:@"总费用："]) {
        NSUInteger location = [targetStr indexOfString:@"总费用："];
        [mStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0x2abcc6] range:NSMakeRange(location, 4)];
    }
    return mStr;
}

@end
