//
//  TTMPickerTextField.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMPickerTextField.h"
#import "UIBarButtonItem+TTMAddtion.h"
#import "NSDate+FSExtension.h"

NSString *const UIKeyboardHideNotification = @"UIKeyboardHideNotification";

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

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 初始化
- (void)setUp{
    _inputMode = TextFieldInputModeKeyBoard;//默认初始化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handNotification:) name:UIKeyboardHideNotification object:nil];
}

- (void)handNotification:(NSNotification *)notification {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_inputMode == TextFieldInputModeSinglePicker) {
        self.inputView = [self getDefaultPickerView];
    }else if (_inputMode == TextFieldInputModeCustomPicker){
        self.inputView = [self getCustomPickerView];
    }else if (_inputMode == TextFieldInputModeDatePicker){
        self.inputView = [self getDatePickerView];
    } else if(_inputMode == TextFieldInputModeKeyBoard || _inputMode == TextFieldInputModeExternal) {
        self.inputAccessoryView = [self getAcessoryView];
    }
}

#pragma mark - 创建自定义InputView
- (UIView *)getCustomPickerView{
    if (!_container) {
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
    if (!_container) {
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
        UIBarButtonItem *cancelItem = [UIBarButtonItem barButtonItemWithTitle:@"取消" target:self action:@selector(cancelItemAction)];
        [cancelItem setTitleColor:MainColor forState:UIControlStateNormal];
        //弹簧
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        //确定按钮
        UIBarButtonItem *certainItem = [UIBarButtonItem barButtonItemWithTitle:@"确定" target:self action:@selector(certainItemAction)];
        [certainItem setTitleColor:MainColor forState:UIControlStateNormal];
        
        _toolBar.items = @[cancelItem,spaceItem,certainItem];
    }
}

#pragma mark - Overload
//处理光标
- (CGRect)caretRectForPosition:(UITextPosition *)position{
    if (self.inputMode == TextFieldInputModeKeyBoard) {
        return [super caretRectForPosition:position];
    }
    return CGRectZero;
}

#pragma mark - UIPickerViewDelegate/DataSource
#pragma mark 取消按钮点击
- (void)cancelItemAction{
    if (self.actionDelegate) {
        if ([self.actionDelegate respondsToSelector:@selector(pickerViewCancel:)]) {
            [self.actionDelegate pickerViewCancel:_inputPickerView];
        }
    }
    [self resignFirstResponder];
}
#pragma mark 确定按钮点击
- (void)certainItemAction{
    switch (self.inputMode) {
        case TextFieldInputModeDatePicker:
        {
            self.text = [_datePickerView.date fs_stringWithFormat:@"yyyy-MM-dd"];
            if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(pickerViewFinish:)]) {
                [self.actionDelegate pickerViewFinish:_inputPickerView];
            }
        }
            break;
            
        case TextFieldInputModeSinglePicker:
        {
            if (self.singlePickerDataSource && _inputPickerView) {
                NSInteger selectRow = [_inputPickerView selectedRowInComponent:0];
                self.text = [self.singlePickerDataSource objectAtIndex:selectRow];
            }
        }
            break;
        case TextFieldInputModeCustomPicker:
        {
            if (self.actionDelegate) {
                NSInteger numComponents = [_inputPickerView numberOfComponents];
                for (int i = 0; i < numComponents; i++) {
                    if ([self.actionDelegate respondsToSelector:@selector(pickerView:finishSelectWithRow:inComponent:)]) {
                        [self.actionDelegate pickerView:_inputPickerView finishSelectWithRow:[_inputPickerView selectedRowInComponent:i] inComponent:i];
                    }
                }
            }
        }
            break;
        case TextFieldInputModeKeyBoard:
        {
            if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(pickerViewFinish:)]) {
                [self.actionDelegate pickerViewFinish:_inputPickerView];
            }
        }
            break;
        default:
            break;
    }
    [self resignFirstResponder];
}

#pragma mark 日期发生变化
- (void)dateDidChange:(UIDatePicker *)datePicker{
    self.text = [datePicker.date fs_stringWithFormat:@"yyyy-MM-dd"];
}

- (UIView *)getAcessoryView {
    if (_toolBar == nil) {
        [self initToolBar];
    }
    return _toolBar;
}

#pragma mark 选择某一行的回调
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.actionDelegate && [self.actionDelegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [self.actionDelegate pickerView:_inputPickerView didSelectRow:row inComponent:component];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.dataSource)
    {
        if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInPickerView:)])
        {
            return [self.dataSource numberOfComponentsInPickerView:pickerView];
        }
    }
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.dataSource)
    {
        if ([self.dataSource respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)])
        {
            return [self.dataSource pickerView:pickerView numberOfRowsInComponent:component];
        }
    } else if (self.singlePickerDataSource) {
        return self.singlePickerDataSource.count;
    }
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(pickerView:widthForComponent:)]) {
            return [self.dataSource pickerView:pickerView widthForComponent:component];
        }
    }
    return kScreenWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(pickerView:rowHeightForComponent:)]) {
            return [self.dataSource pickerView:pickerView rowHeightForComponent:component];
        }
    }
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
            return [self.dataSource pickerView:pickerView titleForRow:row forComponent:component];
        }
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)]) {
            return [self.dataSource pickerView:pickerView viewForRow:row forComponent:component reusingView:view];
        }
    } else if (self.singlePickerDataSource && _inputPickerView) {
        UILabel *rowView = nil;
        if ([view isKindOfClass:[UILabel class]]) {
            rowView = (UILabel *)view;
        } else {
            rowView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        }
        rowView.text = [self.singlePickerDataSource objectAtIndex:row];
        if (self.inputMode == TextFieldInputModeSinglePicker) {
            self.text = [self.singlePickerDataSource objectAtIndex:row];
        }
        return rowView;
    }
    return view;
}

@end
