//
//  UIButton+TTMAddtion.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/17.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "UIButton+TTMAddtion.h"

@implementation UIButton (TTMAddtion)

#pragma mark - ********************* Public Method ***********************
- (void)imageOnTheBottomOfTitleWithSpace:(CGFloat)space{
    [self judgeImageOnTheTopOfTitle:NO space:space];
}

- (void)imageOnTheTopOfTitleWithSpace:(CGFloat)space{
    [self judgeImageOnTheTopOfTitle:YES space:space];
}

- (void)imageOnTheLeftOfTitleWithSpace:(CGFloat)space{
    [self resetEdgeInsets];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, space, 0, -space)];
    [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, space)];
}

- (void)imageOnTheRightOfTitleWithSpace:(CGFloat)space{
    //重置按钮的内边距
    [self resetEdgeInsets];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGRect contentRect = [self contentRectForBounds:self.bounds];
    CGSize titleSize = [self titleRectForContentRect:contentRect].size;
    CGSize imageSize = [self imageRectForContentRect:contentRect].size;
    
    [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, space)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width+space, 0, -titleSize.width - space)];
    
}

#pragma mark - ********************* Private Method ***********************
//重置内边距
- (void)resetEdgeInsets
{
    [self setContentEdgeInsets:UIEdgeInsetsZero];
    [self setImageEdgeInsets:UIEdgeInsetsZero];
    [self setTitleEdgeInsets:UIEdgeInsetsZero];
}

//判断图片是否在标题的上面
- (void)judgeImageOnTheTopOfTitle:(BOOL)isOnTop space:(CGFloat)space{
    //重置按钮的内边距
    [self resetEdgeInsets];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    //获取按钮各子视图的size
    CGRect contentRect = [self contentRectForBounds:self.bounds];
    CGSize titleSize = [self titleRectForContentRect:contentRect].size;
    CGSize imageSize = [self imageRectForContentRect:contentRect].size;
    
    //调整子视图的位置
    float halfHeight = (titleSize.height + imageSize.height) * 0.5;
    float halfWidth = (titleSize.width + titleSize.width) * 0.5;
    
    float topInset = MIN(halfHeight, titleSize.height);
    float leftInset = (titleSize.width - imageSize.width) > 0 ? (titleSize.width - imageSize.width) * 0.5 : 0;
    float bottomInset = (titleSize.height - imageSize.height) > 0 ? (titleSize.height - imageSize.height) * 0.5 : 0;
    float rightInset = MIN(halfWidth, titleSize.width);
    if (isOnTop) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + space, - halfWidth, -titleSize.height - space, halfWidth)];
        [self setContentEdgeInsets:UIEdgeInsetsMake(-bottomInset, leftInset, topInset + space, -rightInset)];
    }else{
        [self setTitleEdgeInsets:UIEdgeInsetsMake(-titleSize.height - space, - halfWidth, imageSize.height + space, halfWidth)];
        [self setContentEdgeInsets:UIEdgeInsetsMake(topInset + space, leftInset, -bottomInset, -rightInset)];
    }
}

@end
