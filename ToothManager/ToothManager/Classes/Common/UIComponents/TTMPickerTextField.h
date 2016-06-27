//
//  TTMPickerTextField.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TextFieldInputMode) {
    TextFieldInputModeKeyBoard = 1,     //普通的UITextField，使用系统的键盘
    TextFieldInputModeSinglePicker = 2, //固定一列的选择器模式
    TextFieldInputModeCustomPicker = 3, //自定义的选择器模式
    TextFieldInputModeDatePicker = 4,   //日期选择模式
    TextFieldInputModeDropdownTablePicker = 5,//下拉列表的选择器模式
    TextFieldInputModeExternal = 6     //跳转页面的选择器模式
};

typedef NS_ENUM(NSInteger,TextFieldDateMode){
    TextFieldDateModeOnlyTime = 1, //只显示时间
    TextFieldDateModeOnlyDate = 2, //只显示日期
    TextFieldDateModeDateAndTime = 3 //显示时间和日期
};

@protocol TTMPickerTextFieldDelegate,TTMPickerTextFieldDataSource;

@interface TTMPickerTextField : UITextField

@property (nonatomic, assign)TextFieldInputMode inputMode;//选择器模式
@property (nonatomic, assign)TextFieldDateMode dateMode;  //时间选择模式

//固定一列的选择器模式，数据源
@property (nonatomic, strong)NSArray *singlePickerDataSource;

//自定义选择器 delegate 和 dataSource
@property (nonatomic, assign)id<TTMPickerTextFieldDelegate> actionDelegate;
@property (nonatomic, assign)id<TTMPickerTextFieldDataSource> dataSource;


@end

@protocol TTMPickerTextFieldDataSource <NSObject>

@optional
//设置PickerView的rect
- (CGRect)boundsOfPickerView:(UIPickerView *)pickerView;
//设置段数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
//设置每段几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
//设置 段宽 和 行高
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component;
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
//设置每行的文字，或者显示特殊文字
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
//设置行视图
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

@end


@protocol TTMPickerTextFieldDelegate <NSObject>

@optional
//取消按钮的回调
- (void)pickerViewCancel:(UIPickerView *)pickerView;
//完成按钮的回调
- (void)pickerViewFinish:(UIPickerView *)pickerView;
//按完成按钮的回调
- (void)pickerView:(UIPickerView *)pickerView finishSelectWithRow:(NSInteger)row inComponent:(NSInteger)component;
//选中某行的回调
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end
