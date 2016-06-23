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

+(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
