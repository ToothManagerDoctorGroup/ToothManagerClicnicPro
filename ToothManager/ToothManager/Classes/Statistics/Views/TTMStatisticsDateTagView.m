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
#import "NSString+TTMAddtion.h"
#import "TTMDateTool.h"

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

    //获取当前选中的时间
    NSString *startTime = nil;
    NSString *endTime = nil;
    switch (index) {
        case 0:
        {
            //今日
            NSString *curDateStr = [TTMDateTool stringWithDateNoTime:[NSDate date]];
            startTime = curDateStr;
            endTime = curDateStr;
            if (self.dateSelectBlock) {
                self.dateSelectBlock(startTime,endTime);
            }
        }
            
            break;
        case 1:
        {
            //本周
            startTime = [TTMDateTool stringWithDateNoTime:[TTMDateTool getMondayDateWithCurrentDate:[NSDate date]]];
            endTime = [TTMDateTool stringWithDateNoTime:[TTMDateTool getSundayDateWithCurrentDate:[NSDate date]]];
            if (self.dateSelectBlock) {
                self.dateSelectBlock(startTime,endTime);
            }
        }
            break;
        case 2:
        {
            //本月
            startTime = [TTMDateTool getMonthBeginWith:[NSDate date]];
            endTime = [TTMDateTool getMonthEndWith:[NSDate date]];
            if (self.dateSelectBlock) {
                self.dateSelectBlock(startTime,endTime);
            }
        }
            break;
        default:
            self.tagView.hidden = YES;
            self.dateView.hidden = NO;
            break;
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
            
            //判断开始时间和结束时间是否有值
            if ([NSString isEmpty:startTime] && [NSString isEmpty:endTime]) {
                weakSelf.tagView.hidden = NO;
                weakSelf.dateView.hidden = YES;
            }else if ([NSString isEmpty:startTime] && ![NSString isEmpty:endTime]) {
                [MBProgressHUD showToastWithText:@"请输入开始时间"];
            }else if (![NSString isEmpty:startTime] && [NSString isEmpty:endTime]) {
                [MBProgressHUD showToastWithText:@"请输入结束时间"];
            }else{
                //比较两个时间大小
                NSComparisonResult result = [TTMDateTool compareStartDateStr:startTime endDateStr:endTime];
                if (result == NSOrderedDescending) {
                    [MBProgressHUD showToastWithText:@"开始时间不能大于结束时间"];
                    return;
                }
                
                //比较两个时间之间的差值，必须在一个月之内
                NSTimeInterval differ = [TTMDateTool getTimeDifferenceBetweenStart:startTime end:endTime];
                if (differ / (60 * 60 * 24) > 31) {
                    [MBProgressHUD showToastWithText:@"时间段必须在一个月之内"];
                    return;
                }
                
                //调用block
                if (weakSelf.dateSelectBlock) {
                    weakSelf.dateSelectBlock(startTime,endTime);
                }
                weakSelf.tagView.hidden = NO;
                weakSelf.dateView.hidden = YES;
            }
            
        };
    }
    return _dateView;
}

@end
