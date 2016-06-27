//
//  TTMCustomDateView.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMCustomDateView.h"
#import "TTMPickerTextField.h"
#import "UIColor+TTMAddtion.h"
#import "Masonry.h"

@interface TTMCustomDateView ()<TTMPickerTextFieldDelegate>

@property (nonatomic, strong)TTMPickerTextField *startTime;//开始时间
@property (nonatomic, strong)TTMPickerTextField *endTime;//结束时间
@property (nonatomic, strong)UIButton *finishButton;//完成按钮

@end

@implementation TTMCustomDateView
#pragma mark - ********************* Life Method ***********************

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}


#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化
- (void)setUp{
    [self addSubview:self.startTime];
    [self addSubview:self.endTime];
    [self addSubview:self.finishButton];
    
    //设置约束
    [self setUpContrains];
}
#pragma mark 设置约束
- (void)setUpContrains{
    
    CGFloat marginX = 15;
    CGFloat fieldH = 35;
    CGFloat btnW = 60;
    CGFloat btnH = fieldH;
    
    [self.startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(marginX);
        make.height.mas_equalTo(fieldH);
        make.width.equalTo(self.endTime);
        make.right.equalTo(self.endTime.mas_left).with.offset(-marginX);
    }];
    
    [self.endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.finishButton.mas_left).with.offset(-marginX);
        make.height.mas_equalTo(fieldH);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-marginX);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
}

- (void)finishButtonAction{
    if (self.buttonBlock) {
        self.buttonBlock(self.startTime.text,self.endTime.text);
    }
}


#pragma mark - ********************* Lazy Method ***********************
- (TTMPickerTextField *)startTime{
    if (!_startTime) {
        _startTime = [[TTMPickerTextField alloc] init];
        _startTime.placeholder = @"开始时间";
        _startTime.textAlignment = NSTextAlignmentCenter;
        _startTime.textColor = [UIColor blackColor];
        _startTime.font = [UIFont systemFontOfSize:14];
        _startTime.layer.cornerRadius = 5;
        _startTime.layer.masksToBounds = YES;
        _startTime.layer.borderWidth = 1;
        _startTime.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
        _startTime.inputMode = TextFieldInputModeDatePicker;
        _startTime.dateMode = TextFieldDateModeOnlyDate;
        _startTime.actionDelegate = self;
        
    }
    return _startTime;
}

- (TTMPickerTextField *)endTime{
    if (!_endTime) {
        _endTime = [[TTMPickerTextField alloc] init];
        _endTime.placeholder = @"结束时间";
        _endTime.textAlignment = NSTextAlignmentCenter;
        _endTime.textColor = [UIColor blackColor];
        _endTime.font = [UIFont systemFontOfSize:14];
        _endTime.layer.cornerRadius = 5;
        _endTime.layer.masksToBounds = YES;
        _endTime.layer.borderWidth = 1;
        _endTime.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
        _endTime.inputMode = TextFieldInputModeDatePicker;
        _endTime.dateMode = TextFieldDateModeOnlyDate;
        _endTime.actionDelegate = self;
    }
    return _endTime;
}

- (UIButton *)finishButton{
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishButton setTitle:@"确定" forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _finishButton.layer.cornerRadius = 5;
        _finishButton.layer.masksToBounds = YES;
        _finishButton.backgroundColor = MainColor;
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}

@end
