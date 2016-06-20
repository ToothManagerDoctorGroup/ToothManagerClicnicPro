//
//  UIButton+TTMAddtion.h
//  ToothManager
//
//  Created by Argo Zhang on 16/6/17.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TTMAddtion)
/**
 *  图片在标题的上方
 *
 *  @param space 图片与标题的间距
 */
- (void)imageOnTheTopOfTitleWithSpace:(CGFloat)space;
/**
 *  图片在标题的下方
 *
 *  @param space 图片与标题的间距
 */
- (void)imageOnTheBottomOfTitleWithSpace:(CGFloat)space;
/**
 *  图片在标题左边
 *
 *  @param space 图片与标题的间距
 */
- (void)imageOnTheLeftOfTitleWithSpace:(CGFloat)space;

/**
 *  图片在标题右边
 *
 *  @param space 图片与标题的间距
 */
- (void)imageOnTheRightOfTitleWithSpace:(CGFloat)space;

@end
