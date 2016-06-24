//
//  TTMAppointStartViewController.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/17.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMAppointStartViewController.h"
#import "TTMApointmentingCell.h"
#import "TTMChargeDetailController.h"
#import "TTMChargeConfirmController.h"
#import "TTMOrderController.h"
#import "TTMChargeConfirmController.h"
#import "TTMChairModel.h"
#import "TTMScheduleDetailController.h"
#import "TTMScheduleCellModel.h"
#import "TTMOrderTool.h"
#import "TTMAppointDetailViewController.h"

#define kMargin 10.f
#define kSectionH 30.f
#define kSegumentH 40.f
#define kPageSize 10

NSString *const kTTMAppointStartViewControllerChangedNotification = @"kTTMAppointStartViewControllerChangedNotification";

@interface TTMAppointStartViewController ()<UITableViewDelegate,UITableViewDataSource,TTMApointmentingCellDelegate>

@property (nonatomic, weak)     UITableView *tableView;
@property (nonatomic, strong)   NSArray *dataArray; // 展示的数组
@property (nonatomic, copy)     NSArray *allDataArray; // 所有数组

@property (nonatomic, strong)   TTMOrderQueryModel *queryModel;
@property (nonatomic, assign)   int pageIndex;

@end

@implementation TTMAppointStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sortByNotification:)
                                                 name:TTMOrderControllerChairChangedNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //查询数据
    if (self.currentChair) {
        self.queryModel.seatId = self.currentChair.seat_id;
    }else{
        self.queryModel.seatId = @"";
    }
    [self queryWithQueryModel:self.queryModel];
}
/**
 *  加载tableview
 */
- (void)setupTableView {
    CGFloat tableHeight = ScreenHeight - kSegumentH - NavigationHeight - TabbarHeight - kMargin / 2;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 + kMargin,
                                                                           ScreenWidth, tableHeight)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    __weak typeof(self) weakSelf = self;
    [tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf queryWithQueryModel:weakSelf.queryModel];
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMAppointmentingCellModel *model = self.dataArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMApointmentingCell *cell = [TTMApointmentingCell cellWithTableView:tableView];
    if (self.dataArray.count > 0) {
        cell.model = self.dataArray[indexPath.row];
        cell.delegate = self;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - TTMApointmentingCellDelegate
- (void)apointmentingCell:(TTMApointmentingCell *)apointmentingCell model:(TTMApointmentModel *)model {
    if (model.status == TTMApointmentStatusNotStart) { // 开始计时
        __weak __typeof(&*self) weakSelf = self;
        CYAlertView * alert = [[CYAlertView alloc] initWithTitle:@"确定要开始计时"
                                                         message:nil
                                                    clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                                                        if (buttonIndex == 1) {
                                                            [weakSelf startWithModel:model];
                                                            //发送通知
                                                            
                                                        }
                                                    }
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
        [alert show];
    } else if (model.status == TTMApointmentStatusStarting) { // 结束计时
        __weak __typeof(&*self) weakSelf = self;
        CYAlertView * alert = [[CYAlertView alloc] initWithTitle:@"确定要结束计时"
                                                         message:nil
                                                    clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                                                        if (buttonIndex == 1) {
                                                            [weakSelf endWithModel:model];
                                                        }
                                                    }
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
        [alert show];
    } else if (model.status == TTMApointmentStatusWaitPay) { // 等待付款
        TTMChargeDetailController *chargeVC = [TTMChargeDetailController new];
        chargeVC.model = model;
        [self.navigationController pushViewController:chargeVC animated:YES];
    } else if ( model.status == TTMApointmentStatusEnded) { // 收费确认
        TTMChargeConfirmController *confirmVC = [TTMChargeConfirmController new];
        confirmVC.model = model;
        [self.navigationController pushViewController:confirmVC animated:YES];
    }
}

- (void)apointmentingCell:(TTMApointmentingCell *)apointmentingCell clickedLineWithModel:(TTMApointmentModel *)model {
    TTMScheduleCellModel *temp = [[TTMScheduleCellModel alloc] init];
    temp.keyId = model.KeyId;
    
    TTMAppointDetailViewController *detailVC = [[TTMAppointDetailViewController alloc] init];
    detailVC.model = temp;
    [self.navigationController pushViewController:detailVC animated:YES];
}

/**
 *  开始计时
 */
- (void)startWithModel:(TTMApointmentModel *)model {
    __weak __typeof(&*self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showLoading];
    [TTMApointmentModel startTimeWithModel:model complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            // 成功
            [weakSelf queryWithQueryModel:weakSelf.queryModel];
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kTTMAppointStartViewControllerChangedNotification object:@(TTMApointmentStatusStarting)];
        }
    }];
}

/**
 *  结束计时
 */
- (void)endWithModel:(TTMApointmentModel *)model {
    __weak __typeof(&*self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showLoading];
    [TTMApointmentModel endTimeWithModel:model complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            TTMChargeConfirmController *confimVC = [TTMChargeConfirmController new];
            confimVC.model = model;
            [weakSelf.navigationController pushViewController:confimVC animated:YES];
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kTTMAppointStartViewControllerChangedNotification object:@(TTMApointmentStatusEnded)];
        }
    }];
}

/**
 *  查询预约列表
 *
 *  @param queryModel 查询model
 */
- (void)queryWithQueryModel:(TTMOrderQueryModel *)queryModel {
    __weak __typeof(&*self) weakSelf = self;
    [TTMOrderTool queryAppointmentListWithQueryModel:queryModel complete:^(id result) {
        if ([weakSelf.tableView.header isRefreshing]) {
            [weakSelf.tableView.header endRefreshing];
        }
        if([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            
            self.allDataArray = result; // 原始的所有数据
            weakSelf.dataArray = [weakSelf sortArrayByDay:result];
            [weakSelf.tableView reloadData];
        }
    }];
}

/**
 *  按天排序
 *
 *  @param array 数组
 *
 *  @return 数组
 */
- (NSArray *)sortArrayByDay:(NSArray *)array {
    NSMutableArray *mutArray = [NSMutableArray array];
    NSDate *lastDate = nil;
    
    for (NSUInteger i = 0; i < array.count; i ++) {
        TTMApointmentModel *appointmentModel = array[i];
        NSDate *dateTime = [appointmentModel.appoint_time dateValue]; // 这一条数据的时间
        
        if (![dateTime fs_isEqualToDateForDay:lastDate]) { // 与前一条数据的天不相同
            TTMAppointmentingCellModel *appointmentCellModel = [[TTMAppointmentingCellModel alloc] init];
            appointmentCellModel.day = [dateTime fs_stringWithFormat:@"yyyy年MM月dd日"];
            [appointmentCellModel.infoList addObject:appointmentModel];
            [mutArray addObject:appointmentCellModel];
        } else { // 相同则继续添加
            TTMAppointmentingCellModel *appointmentCellModel = [mutArray lastObject];
            [appointmentCellModel.infoList addObject:appointmentModel];
        }
        lastDate = [dateTime copy];
    }
    return mutArray;
}


/**
 *  通知根据椅位排序
 *
 *  @param notification 通知信息
 */
- (void)sortByNotification:(NSNotification *)notification {
    TTMChairModel *chairModel = notification.object;
    self.currentChair = chairModel;
    
    if (self.currentChair) {
        self.queryModel.seatId = self.currentChair.seat_id;
    }else{
        self.queryModel.seatId = @"";
    }
    [self queryWithQueryModel:self.queryModel];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Lazy Method ***********************
- (TTMOrderQueryModel *)queryModel{
    if (!_queryModel) {
        _queryModel = [[TTMOrderQueryModel alloc] initWithReserveStatus:[@(self.status) stringValue] seatId:@"" pageIndex:self.pageIndex pageSize:kPageSize];
    }
    return _queryModel;
}


@end
