//
//  TTMStatisticsFormCell.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/22.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMStatisticsFormCell.h"
#import "Masonry.h"

@implementation TTMStatisticsFormCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self.contentView addSubview:self.contentLabel];
    
    [self setUpContraints];
}

- (void)setUpContraints{
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.adjustsFontSizeToFitWidth = YES;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor whiteColor];
    }
    return _contentLabel;
}

@end
