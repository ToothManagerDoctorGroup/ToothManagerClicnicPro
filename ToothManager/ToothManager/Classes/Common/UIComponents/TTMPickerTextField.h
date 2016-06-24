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

@interface TTMPickerTextField : UITextField

@property (nonatomic, assign)TextFieldInputMode inputMode;//选择器模式
@property (nonatomic, assign)TextFieldDateMode dateMode;  //时间选择模式

//固定一列的选择器模式，数据源
@property (nonatomic, strong)NSArray *singlePickerDataSource;


@end
