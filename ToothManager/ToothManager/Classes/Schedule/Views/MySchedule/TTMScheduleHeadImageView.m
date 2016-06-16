//
//  TTMScheduleHeadImageView.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/26.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMScheduleHeadImageView.h"
#import "Masonry.h"

@interface TTMScheduleHeadImageView ()

@property (nonatomic, strong)UIView *nameSuperView;
@property (nonatomic, strong)UILabel *nameLabel;

@end

@implementation TTMScheduleHeadImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
#pragma mark - 初始化
- (void)setUp{
    [self addSubview:self.nameSuperView];
    
    [self setUpContrains];
}
#pragma mark - 设置约束
- (void)setUpContrains{
    [self.nameSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.and.right.equalTo(self);
        make.height.mas_equalTo(18);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.nameSuperView);
    }];
}

- (void)setName:(NSString *)name{
    _name = name;
    
    self.nameLabel.text = name;
}

#pragma mark - ********************* Lazy Method ***********************
- (UIView *)nameSuperView{
    if (!_nameSuperView) {
        _nameSuperView = [[UIView alloc] init];
        _nameSuperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_nameSuperView addSubview:self.nameLabel];
    }
    return _nameSuperView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [_nameLabel sizeToFit];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

@end
