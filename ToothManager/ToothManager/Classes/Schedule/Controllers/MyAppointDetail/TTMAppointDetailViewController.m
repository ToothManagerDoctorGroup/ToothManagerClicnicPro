//
//  TTMAppointDetailViewController.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMAppointDetailViewController.h"
#import "TTMAppointDetailHeaderView.h"
#import "TTMAppointTimeFooterView.h"
#import "TTMAppointDetailCell.h"
#import "TTMScheduleCellModel.h"
#import "TTMMaterialModel.h"
#import "TTMAssistModel.h"
#import "TTMAppointDetailCellModel.h"
#import "UIColor+TTMAddtion.h"
#import "TTMChargeConfirmController.h"
#import "TTMChargeDetailController.h"
#import "TTMSchedulePatientInfoViewController.h"

NSString *const kTTMAppointStateChangedNotification = @"kTTMAppointStateChangedNotification";

@interface TTMAppointDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TTMAppointTimeFooterViewDelegate>{
    UITableView *_tableView;
}

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)TTMScheduleCellModel *pageModel;
@property (nonatomic, strong)TTMAppointTimeFooterView *timeView;
@property (nonatomic, strong)TTMAppointDetailHeaderView *headerView;

@end

@implementation TTMAppointDetailViewController

#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化
    [self setUpViews];
    //加载数据
    [self queryData];
    //添加监听
    [self addNotificationObserver];
}

- (void)dealloc{
    [self removeNotificationObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addNotificationObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryData) name:kTTMAppointStateChangedNotification object:nil];
}

- (void)removeNotificationObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化
- (void)setUpViews{
    self.title = @"预约详情";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    [self.view addSubview:_tableView];
    
    _headerView = [[[NSBundle mainBundle]loadNibNamed:@"TTMAppointDetailHeaderView" owner:self options:nil] lastObject];
    _headerView.frame = CGRectMake(0, 0, ScreenWidth, 197);
    _tableView.tableHeaderView = _headerView;
    
    //添加底部视图
    _timeView = [[[NSBundle mainBundle] loadNibNamed:@"TTMAppointTimeFooterView" owner:self options:nil] lastObject];
    _timeView.delegate = self;
    _timeView.frame = CGRectMake(0, ScreenHeight - 60, ScreenWidth, 60);
    [self.view addSubview:_timeView];
}

/**
 *  开始计时
 */
- (void)startWithModel:(TTMApointmentModel *)model {
    MBProgressHUD *hud = [MBProgressHUD showLoading];
    [TTMApointmentModel startTimeWithModel:model complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            // 成功
            //            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kTTMAppointStateChangedNotification object:nil];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:kTTMAppointStateChangedNotification object:nil];
            
            TTMChargeConfirmController *confimVC = [TTMChargeConfirmController new];
            confimVC.model = model;
            [weakSelf.navigationController pushViewController:confimVC animated:YES];
        }
    }];
}

/**
 *  查询数据
 */
- (void)queryData {
    __weak __typeof(&*self) weakSelf = self;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDWithView:self.view.window text:@"加载中..."];
    [TTMScheduleCellModel queryScheduleDetailWithId:self.model.keyId complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.pageModel = result;
            [TTMScheduleCellModel queryScheduleOtherDetailWithId:weakSelf.model.keyId complete:^(id result) {
                if ([result isKindOfClass:[NSString class]]) {
                    [MBProgressHUD showToastWithText:result];
                } else {
                    TTMScheduleCellModel *otherModel = result;
                    weakSelf.pageModel.doctor_image = otherModel.doctor_image;
                    weakSelf.pageModel.doctor_name = otherModel.doctor_name;
                    weakSelf.pageModel.doctor_position = otherModel.doctor_position;
                    weakSelf.pageModel.doctor_hospital = otherModel.doctor_hospital;
                    weakSelf.pageModel.doctor_dept = otherModel.doctor_dept;
                    weakSelf.pageModel.planting_quantity = otherModel.planting_quantity;
                    weakSelf.pageModel.star_level = otherModel.star_level;
                    weakSelf.pageModel.remark = otherModel.remark;
                    
                    [weakSelf createDataSourceWithModel:weakSelf.pageModel];
                    _headerView.model = weakSelf.pageModel;
                    weakSelf.timeView.model = weakSelf.pageModel;
                    [_tableView reloadData];
                }
            }];
        }
    }];
}
#pragma mark 创建数据源
- (void)createDataSourceWithModel:(TTMScheduleCellModel *)model{
    if (self.dataList.count > 0) {
        [self.dataList removeAllObjects];
    }
    
    NSArray *titles = @[@"时间",@"患者",@"牙位",@"项目",@"时长",@"椅位",@"耗材",@"助理",@"备注",];
    NSMutableString *materialString = [NSMutableString string];
    for (TTMMaterialModel *material in model.materials) {
        if (material == model.materials[model.materials.count - 1]) {
            [materialString appendFormat:@"%@种植体%@颗", material.mat_name, material.actual_num];
        } else {
            [materialString appendFormat:@"%@种植体%@颗,", material.mat_name, material.actual_num];
        }
    }
    NSString *materialStr = [NSString stringWithString:materialString];
    
    NSMutableString *assistString = [NSMutableString string];
    for (TTMAssistModel *assist in model.assists) {
        if (assist == model.assists[model.assists.count - 1]) {
            [assistString appendFormat:@"%@%@名", assist.assist_name, assist.actual_num];
        } else {
            [assistString appendFormat:@"%@%@名,", assist.assist_name, assist.actual_num];
        }
    }
    NSString *assistStr = [NSString stringWithString:assistString];
    
    NSArray *contents = @[model.reserve_time,
                          model.patient_name,
                          [self nilStr:model.tooth_position],
                          model.reserve_type,
                          [NSString stringWithFormat:@"%@小时",model.reserve_duration],
                          model.seat_name,
                          [self nilStr:materialStr],
                          [self nilStr:assistStr],
                          [self nilStr:model.remark]];
    for (int i = 0; i < titles.count; i++) {
        TTMAppointDetailCellModel *cellModel = [[TTMAppointDetailCellModel alloc] initWithTitle:titles[i] content:contents[i]];
        if (i == 1) {
            cellModel.showArrow = YES;
            cellModel.contentColor = [UIColor colorWithHex:0x2abcc6];
        }
        [self.dataList addObject:cellModel];
    }
}

#pragma mark - ********************* Delegate / DataSource *********************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTMAppointDetailCellModel *model = self.dataList[indexPath.row];
    return [TTMAppointDetailCell cellHeightWithContent:model.content];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TTMAppointDetailCellModel *model = self.dataList[indexPath.row];
    TTMAppointDetailCell *cell = [TTMAppointDetailCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        TTMSchedulePatientInfoViewController *detailVc = [[TTMSchedulePatientInfoViewController alloc] init];
        detailVc.model = self.pageModel;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

#pragma mark TTMAppointTimeFooterViewDelegate
- (void)appointTimeFooterView:(TTMAppointTimeFooterView *)footerView didClickTimeButton:(UIButton *)button{
    TTMScheduleCellModel *model = self.pageModel;
    if (model.reserve_status == TTMApointmentStatusNotStart) { // 开始计时
        __weak __typeof(&*self) weakSelf = self;
        CYAlertView * alert = [[CYAlertView alloc] initWithTitle:@"确定要开始计时"
                                                         message:nil
                                                    clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                                                        if (buttonIndex == 1) {
                                                            TTMApointmentModel *submitModel = [[TTMApointmentModel alloc] init];
                                                            submitModel.KeyId = model.keyId;
                                                            [weakSelf startWithModel:submitModel];
                                                        }
                                                    }
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
        [alert show];
    } else if (model.reserve_status == TTMApointmentStatusStarting) { // 结束计时
        __weak __typeof(&*self) weakSelf = self;
        CYAlertView * alert = [[CYAlertView alloc] initWithTitle:@"确定要结束计时"
                                                         message:nil
                                                    clickedBlock:^(CYAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                                                        if (buttonIndex == 1) {
                                                            TTMApointmentModel *submitModel = [[TTMApointmentModel alloc] init];
                                                            submitModel.KeyId = model.keyId;
                                                            [weakSelf endWithModel:submitModel];
                                                        }
                                                    }
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
        [alert show];
    } else if (model.reserve_status == TTMApointmentStatusWaitPay) { // 等待付款
        TTMChargeDetailController *chargeVC = [TTMChargeDetailController new];
        TTMApointmentModel *submitModel = [[TTMApointmentModel alloc] init];
        submitModel.KeyId = model.keyId;
        chargeVC.model = submitModel;
        [self.navigationController pushViewController:chargeVC animated:YES];
    } else if ( model.reserve_status == TTMApointmentStatusEnded) { // 收费确认
        TTMChargeConfirmController *confirmVC = [TTMChargeConfirmController new];
        TTMApointmentModel *submitModel = [[TTMApointmentModel alloc] init];
        submitModel.KeyId = model.keyId;
        confirmVC.model = submitModel;
        [self.navigationController pushViewController:confirmVC animated:YES];
    }
}

#pragma mark - ********************* Lazy Method ***********************
- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSString *)nilStr:(NSString *)str{
    if (str == nil) {
        return @"";
    }
    return str;
}

@end
