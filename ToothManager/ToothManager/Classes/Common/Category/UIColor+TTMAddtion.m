//
//  UIColor+TTMAddtion.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "UIColor+TTMAddtion.h"

@implementation UIColor (TTMAddtion)
+ (UIColor *) colorWithHex:(unsigned int)hex
{
    return [UIColor colorWithHex:hex alpha:1];
}

+ (UIColor *) colorWithHex:(unsigned int)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hex & 0xFF)) / 255.0
                           alpha:alpha];
}
@end
