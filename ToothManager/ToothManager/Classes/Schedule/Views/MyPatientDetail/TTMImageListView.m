//
//  TTMImageListView.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMImageListView.h"
#import "UIColor+TTMAddtion.h"
#import "Masonry.h"

@interface TTMImageListView ()

@property (nonatomic, strong)UIView *dividerView;

@end

@implementation TTMImageListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self addSubview:self.dividerView];
    
    [self.dividerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}


- (UIView *)dividerView{
    if (!_dividerView) {
        _dividerView = [[UIView alloc] init];
        _dividerView.backgroundColor = [UIColor colorWithHex:0xcccccc];
    }
    return _dividerView;
}

@end
