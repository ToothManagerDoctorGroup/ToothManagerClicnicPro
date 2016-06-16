//
//  TTMAppointDetailCell.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/23.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMAppointDetailCell.h"
#import "UIColor+TTMAddtion.h"
#import "NSString+TTMAddtion.h"
#import "TTMAppointDetailCellModel.h"

#define kTitleFont [UIFont systemFontOfSize:14]
#define kTitleColor [UIColor colorWithHex:0x555555]
#define kContentFont kTitleFont
#define kContentColor [UIColor blackColor]
#define kTitleWidth 100
#define kRowHeight 45
#define kMargin 10

@interface TTMAppointDetailCell ()

@property (nonatomic, strong)UILabel *titleLabel;//标题
@property (nonatomic, strong)UILabel *contentLabel;//内容
@property (nonatomic, strong)UIImageView *arrowView;

@end

@implementation TTMAppointDetailCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"appoint_detail_cell";
    TTMAppointDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    
    //更新frame
    [self updateFrame];
}

- (void)updateFrame{
    self.titleLabel.frame = CGRectMake(kMargin, 0, kTitleWidth, kRowHeight);
    
    CGFloat contentX = self.titleLabel.right;
    CGFloat contentY = 0;
    CGFloat contentW = ScreenWidth - self.titleLabel.right - kMargin * 2.5;
    CGFloat contentH = kRowHeight;
    self.contentLabel.frame = CGRectMake(contentX, contentY, contentW, contentH);
}

+ (CGFloat)cellHeightWithContent:(NSString *)content{
    if (content) {
        CGFloat contentW = ScreenWidth - kTitleWidth - kMargin * 2.5;
        CGSize size = [content measureFrameWithFont:kContentFont size:CGSizeMake(contentW, MAXFLOAT)].size;
        if (size.height > kRowHeight) {
            return size.height;
        }
    }
    return kRowHeight;
}

- (void)setModel:(TTMAppointDetailCellModel *)model{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.contentLabel.textColor = model.contentColor;
    if (model.showArrow) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kTitleFont;
        _titleLabel.textColor = kTitleColor;
        
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = kContentFont;
        _contentLabel.textColor = kContentColor;
    }
    return _contentLabel;
}

@end
