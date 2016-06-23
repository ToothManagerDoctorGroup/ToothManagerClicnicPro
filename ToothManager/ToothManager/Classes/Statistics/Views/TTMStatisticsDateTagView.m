//
//  TTMStatisticsDateTagView.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMStatisticsDateTagView.h"
#import "TTMCustomDateView.h"
#import "Masonry.h"
#import "XLTagView.h"

@interface TTMStatisticsDateTagView ()<XLTagViewDelegate>

@property (nonatomic, strong)XLTagView *tagView;
@property (nonatomic, strong)TTMCustomDateView *dateView;

@end

@implementation TTMStatisticsDateTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - ********************* Private Method ***********************
- (void)setUp{
    [self addSubview:self.tagView];
    [self addSubview:self.dateView];
    
    [self setUpContrains];
}

#pragma mark 设置约束
- (void)setUpContrains{
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - ****************** Delegate / DataSource *********************
#pragma mark XLTagViewDelegate
- (void)tagView:(XLTagView *)tagView tagArray:(NSArray *)tagArray{
    NSInteger index = [[tagArray firstObject] integerValue];
    if (index == 3) {
        self.tagView.hidden = YES;
        self.dateView.hidden = NO;
    }
}

#pragma mark - ********************* Lazy Method ***********************
- (XLTagView *)tagView{
    if (!_tagView) {
        NSArray *tagsArray = @[@"本日",@"本周",@"本月",@"自定义"];
        XLTagFrame *frame = [[XLTagFrame alloc] init];
        frame.tagsMinPadding = 4;
        frame.tagsMargin = 10;
        frame.tagsLineSpacing = 10;
        frame.tagsArray = tagsArray;
        
        _tagView = [[XLTagView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        _tagView.clickbool = YES;
        _tagView.tagsFrame = frame;
        _tagView.borderSize = 0.5;
        _tagView.clickborderSize = 0.5;
        _tagView.clickBackgroundColor = MainColor;
        _tagView.clickTitleColor = [UIColor whiteColor];
        _tagView.selectType = XLTagViewSelectTypeSingle;
        _tagView.clickString = tagsArray[2];
        _tagView.delegate = self;
        
    }
    return _tagView;
}

- (TTMCustomDateView *)dateView{
    if (!_dateView) {
        _dateView = [[TTMCustomDateView alloc] init];
        _dateView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _dateView.buttonBlock = ^(NSString *startTime,NSString *endTime){
            weakSelf.tagView.hidden = NO;
            weakSelf.dateView.hidden = YES;
        };
    }
    return _dateView;
}

@end
