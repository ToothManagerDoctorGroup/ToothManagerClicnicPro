//
//  UIColor+TTMAddtion.h
//  ToothManager
//
//  Created by Argo Zhang on 16/5/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TTMAddtion)

//十六进制获取颜色
+ (UIColor *) colorWithHex:(unsigned int)hex;
+ (UIColor *) colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha;
+ (UIColor *) randomColor;


@end
