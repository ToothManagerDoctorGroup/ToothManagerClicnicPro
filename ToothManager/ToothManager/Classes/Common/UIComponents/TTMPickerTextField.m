//
//  TTMPickerTextField.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMPickerTextField.h"
#import "UIBarButtonItem+TTMAddtion.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kToolBarHeight 44
#define kPickerViewHeight 216

@interface TTMPickerTextField ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    UIPickerView *_inputPickerView;
    UIDatePicker *_datePickerView;
    UIView *_container;
    
    
    UIToolbar *_toolBar;//工具栏
}

@end

@implementation TTMPickerTextField

#pragma mark - ********************* init method ***********************
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib{
    [self setUp];
}

#pragma mark 初始化
- (void)setUp{
    _inputMode = TextFieldInputModeKeyBoard;//默认初始化
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_inputMode == TextFieldInputModeSinglePicker) {
        self.inputView = [self getDefaultPickerView];
    }else if (_inputMode == TextFieldInputModeCustomPicker){
        self.inputView = [self getCustomPickerView];
    }else if (_inputMode == TextFieldInputModeDatePicker){
        self.inputView = [self getDatePickerView];
    }
}

#pragma mark - 创建自定义InputView
- (UIView *)getCustomPickerView{
    if (_container) {
        [self initToolBar];
        [self initPickerView];
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _toolBar.frame.size.height + _inputPickerView.frame.size.height)];
        [_container addSubview:_toolBar];
        [_container addSubview:_inputPickerView];
    }
    return _container;
}

#pragma mark - 创建日期的inputView
- (UIView *)getDatePickerView{
    if (_container) {
        [self initToolBar];
        [self initDatePickerView];
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _toolBar.frame.size.height + _datePickerView.frame.size.height)];
        [_container addSubview:_toolBar];
        [_container addSubview:_datePickerView];
    }
    return _container;
}

#pragma mark - 创建默认InputView
- (UIView *)getDefaultPickerView{
    if (!_container) {
        [self initToolBar];
        [self initPickerView];
        
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _toolBar.frame.size.height + _inputPickerView.frame.size.height)];
        [_container addSubview:_toolBar];
        [_container addSubview:_inputPickerView];
    }
    return _container;
}

#pragma mark - 创建普通的pickerView
- (void)initPickerView{
    if (!_inputPickerView) {
        _inputPickerView = [[UIPickerView alloc] init];
        _inputPickerView.delegate = self;
        _inputPickerView.dataSource = self;
    }
    _inputPickerView.frame = CGRectMake(0, kToolBarHeight, kScreenWidth, kPickerViewHeight);
}
#pragma mark - 创建日期的pickerView
- (void)initDatePickerView{
    if (!_datePickerView) {
        _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kToolBarHeight, kScreenWidth, kPickerViewHeight)];
        if (self.dateMode == TextFieldDateModeOnlyTime) {
            _datePickerView.datePickerMode = UIDatePickerModeTime;
        }else if (self.dateMode == TextFieldDateModeOnlyDate){
            _datePickerView.datePickerMode = UIDatePickerModeDate;
        }else{
            _datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
        }
        
        [_datePickerView addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - 创建toolBar
- (void)initToolBar{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolBarHeight)];
        
        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor grayColor];
        [_toolBar addSubview:lineView];
        
        //取消按钮
//        UIBarButtonItem *cancelItem = [UIBarButtonItem itemWithTitle:@"取消" target:self action:@selector(cancelItemAction)];
//        [cancelItem setTitleColor:MainColor forState:UIControlStateNormal];
        
        //弹簧
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        //确定按钮
//        UIBarButtonItem *certainItem = [UIBarButtonItem itemWithTitle:@"确定" target:self action:@selector(certainItemAction)];
//        [certainItem setTitleColor:MainColor forState:UIControlStateNormal];
        
//        _toolBar.items = @[cancelItem,spaceItem,certainItem];
    }
}

#pragma mark 取消按钮点击
- (void)cancelItemAction{

}
#pragma mark 确定按钮点击
- (void)certainItemAction{
    
}

#pragma mark 日期发生变化
- (void)dateDidChange:(UIDatePicker *)datePicker{
    
}


@end
