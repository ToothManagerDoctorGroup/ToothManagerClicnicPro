
#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TTMAddtion)

/**
 *  创建一个custom的UIBarButtonItem
 *
 *  @param imageName         普通状态下的图片名字
 *  @param selectedImageName 高亮状态下的图片名字
 *  @param action            按钮执行的SEL
 *  @param target            一般来说是控制器
 *
 *  @return 返回custom的UIBarButtonItem
 */
+ (instancetype)barButtonItemWithImage:(NSString *)imageName
                         selectedImage:(NSString *)selectedImageName
                                action:(SEL)action
                                target:(id)target;

/**
 *  创建有title和背景图片的item
 *
 *  @param title           标题
 *  @param normalImageName 普通状态的图片
 *  @param action          action description
 *  @param target          target description
 *
 *  @return return value description
 */
+ (instancetype)barButtonItemWithTitle:(NSString *)title
                       normalImageName:(NSString *)normalImageName
                                action:(SEL)action
                                target:(id)target;

/**
 *  新建待数字的按钮
 *
 *  @param imageName         普通图片
 *  @param selectedImageName 选中图片
 *  @param number            数字
 *  @param action            按钮执行的SEL
 *  @param target            一般来说是控制器
 *
 *  @return 按钮
 */
+ (instancetype)barButtonItemWithTitle:(NSString *)title
                                number:(NSNumber *)number
                                action:(SEL)action
                                target:(id)target;

/**
 *  新建只有title的按钮
 *
 *  @param title  标题
 *  @param target target description
 *  @param action action description
 *
 *  @return 按钮
 */
+ (instancetype)barButtonItemWithTitle:(NSString*)title
                                target:(id)target
                                action:(SEL)action;

/**
 *  设置按钮的文字颜色
 *
 *  @param color color
 *  @param state 状态
 */
- (void)setTitleColor:(UIColor *)color
             forState:(UIControlState)state;
@end
