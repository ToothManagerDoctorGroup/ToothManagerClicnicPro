//
//  TTMOrderController.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/16.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMOrderController.h"
#import "TTMSegmentedView.h"
#import "TTMAppointStartViewController.h"
#import "TTMAppointEndViewController.h"
#import "NSString+TTMAddtion.h"
#import "UIButton+TTMAddtion.h"
#import "TTMPopoverView.h"
#import "TTMChairModel.h"

NSString *const TTMOrderControllerChairChangedNotification = @"TTMOrderControllerChairChangedNotification";
#define kSegmentH 40.f

@interface TTMOrderController ()<TTMSegmentedViewDelegate>

@property (nonatomic, strong)   TTMSegmentedView *segmentView;
@property (nonatomic, strong)   NSMutableArray *dataArray;
@property (nonatomic, strong)   UIView *contentView;
@property (nonatomic, strong)   UIButton *titleButton;//标题按钮

@property (nonatomic, strong) NSArray *chairArray; // 椅位数组
@property (nonatomic, strong) NSMutableArray *chairTitles; // 椅位title
@property (nonatomic, strong) TTMChairModel *currentChair; // 当前椅位

@end

@implementation TTMOrderController
#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    [self setUpSubViews];
    
    //获取椅位信息
    [self queryChairsData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
- (void)setUpSubViews{
    //设置标题栏按钮
    self.navigationItem.titleView = self.titleButton;
    
    [self.view addSubview:self.segmentView];
    [self.view addSubview:self.contentView];
}

#pragma mark 椅位按钮点击
- (void)chairButtonClick:(UIButton *)sender{
    CGPoint point = CGPointMake(sender.left + sender.width / 2,
                                sender.bottom + sender.height / 2);
    TTMPopoverView *pop = [[TTMPopoverView alloc] initWithPoint:point titles:self.chairTitles images:nil];
    __weak __typeof(&*self) weakSelf = self;
    pop.selectRowAtIndex = ^(NSInteger index){
        weakSelf.currentChair = weakSelf.chairArray[index];
        [weakSelf.titleButton setTitle:weakSelf.currentChair.seat_name forState:UIControlStateNormal];
        [weakSelf.titleButton imageOnTheRightOfTitleWithSpace:0];
    };
    [pop show];
}

#pragma mark 查询椅位信息
- (void)queryChairsData {
    __weak __typeof(&*self) weakSelf = self;
    [TTMChairModel queryChairsWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.chairArray = result;
            weakSelf.chairTitles = [NSMutableArray array];
            for (TTMChairModel *chair in weakSelf.chairArray) {
                [weakSelf.chairTitles addObject:chair.seat_name];
            }
        }
    }];
}

- (void)setCurrentChair:(TTMChairModel *)currentChair{
    _currentChair = currentChair;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TTMOrderControllerChairChangedNotification object:currentChair];
}


#pragma mark - ********************* Delegate/DataSource ********************
#pragma mark - 自定义事件
- (void)segmentedViewDidSelected:(TTMSegmentedView *)segmentedView fromIndex:(NSUInteger)from toIndex:(NSUInteger)to {
    UIViewController *fromVC = self.childViewControllers[from];
    UIViewController *toVC = self.childViewControllers[to];
    
    [fromVC.view removeFromSuperview];
    [self.contentView addSubview:toVC.view];
}

#pragma mark - ********************* Lazy Method ***********************
- (TTMSegmentedView *)segmentView{
    if (!_segmentView) {
        CGRect frame = CGRectMake(0, NavigationHeight, ScreenWidth, kSegmentH);
        _segmentView = [[TTMSegmentedView alloc] initWithFrame:frame];
        _segmentView.delegate = self;
        
        // 设置页面
        NSArray *titles = @[@"待计时", @"计时中",@"收费待确认",@"待收费"];
        NSMutableArray *controllers = [NSMutableArray array];
        int i = 0;
        for (NSString *title in titles) {
            TTMAppointStartViewController *appointmenting = [TTMAppointStartViewController new];
            appointmenting.title = title;
            appointmenting.status = i;
            [controllers addObject:appointmenting];
            [self addChildViewController:appointmenting];
            i++;
        }
        TTMAppointEndViewController *appointmented = [TTMAppointEndViewController new];
        appointmented.title = @"已完成";
        [controllers addObject:appointmented];
        [self addChildViewController:appointmented];
        
        _segmentView.segmentControllers = controllers;
        
        //获取第一个controller
        TTMAppointStartViewController *waitVc = controllers[0];
        [self.contentView addSubview:waitVc.view];
    }
    return _segmentView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        CGFloat contentHeight = ScreenHeight - NavigationHeight - kSegmentH;
        _contentView.frame = CGRectMake(0, self.segmentView.bottom, ScreenWidth, contentHeight);
    }
    return _contentView;
}

- (UIButton *)titleButton{
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(0, 0, 120, 44);
        [_titleButton setTitle:@"全部椅位" forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _titleButton.titleLabel.font = [UIFont systemFontOfSize:18];
        UIImage *image = [UIImage imageNamed:@"gtask_title_arrow"];
        [_titleButton setImage:image forState:UIControlStateNormal];
        [_titleButton imageOnTheRightOfTitleWithSpace:0];
        
        [_titleButton addTarget:self action:@selector(chairButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

@end
