//
//  TTMSchedulePatientInfoViewController.m
//  ToothManager
//
//  Created by Argo Zhang on 16/5/21.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMSchedulePatientInfoViewController.h"
#import "TTMPatientImageCell.h"
#import "TTMPatientModel.h"
#import "TTMPatientTool.h"
#import "TTMDoctorTool.h"
#import "TTMScheduleCellModel.h"
#import "TTMAppointPatientModel.h"
#import "UIColor+TTMAddtion.h"

@interface TTMSchedulePatientInfoViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}

@property (nonatomic, strong)TTMAppointPatientModel *curPatientModel;
@property (nonatomic, strong)NSMutableArray *checkImages;
@property (nonatomic, strong)NSMutableArray *ctImages;

@end

@implementation TTMSchedulePatientInfoViewController
#pragma mark - ********************* Life Method ***********************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化子视图
    [self setUpViews];
    //请求数据
    [self queryPatientData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化
- (void)setUpViews{
    self.title = @"患者信息";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = [UIColor colorWithHex:0xf4f4f4];
    
    if ([UIDevice currentDevice].systemVersion.intValue >= 8) {
        for (UIView *currentView in _tableView.subviews) {
            if ([currentView isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)currentView).delaysContentTouches = NO;
                break;
            }
        }
    }
    
    [self.view addSubview:_tableView];
}

#pragma mark - 请求患者详细信息
- (void)queryPatientData{
    MBProgressHUD *hud = [MBProgressHUD showHUDWithView:self.view.window text:@"正在加载..."];
    [TTMDoctorTool getAppointmentDetailWithReserveId:[@(self.model.keyId) stringValue]patientId:self.model.patient_id success:^(TTMResponseModel *respond) {
        [hud hide:YES];
        if (respond.code == 200) {
            TTMAppointPatientModel *patientModel = [TTMAppointPatientModel objectWithKeyValues:respond.result];
            self.curPatientModel = patientModel;
            //设置数据源
            [self setUpDataSource];
        }
    } failure:^(NSError *error) {
        [hud hide:YES];
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

#pragma mark 设置数据源
- (void)setUpDataSource{
    for (TTMAppointImageModel *imageModel in self.curPatientModel.files) {
        if ([imageModel.file_type isEqualToString:@"checklist"]) {
            [self.checkImages addObject:imageModel];
        }else{
            [self.ctImages addObject:imageModel];
        }
    }
    //刷新数据
    [_tableView reloadData];
}

#pragma mark - ********************* Delegate/DataSource **********************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return [TTMPatientImageCell cellHeightWithImageList:@[]];
    }else if(indexPath.section == 1){
        return [TTMPatientImageCell cellHeightWithImageList:self.checkImages];
    }else {
        return [TTMPatientImageCell cellHeightWithImageList:self.ctImages];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TTMPatientImageCell *cell = [TTMPatientImageCell cellWithTableView:tableView];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //姓名
            cell.titleLabel.text = @"姓名";
            cell.contentLabel.text = self.curPatientModel.patientName;
            cell.imageList = @[];
        }else if (indexPath.row == 1){
            //性别
            cell.titleLabel.text = @"性别";
            NSString *gender;
            if ([self.curPatientModel.patientGender isEqualToString:@"0"]) {
                gender = @"女";
            }else if ([self.curPatientModel.patientGender isEqualToString:@"1"]){
                gender = @"男";
            }else{
                gender = @"未知";
            }
            cell.contentLabel.text = gender;
            cell.imageList = @[];
            
        }else if (indexPath.row == 2){
            //年龄
            cell.titleLabel.text = @"年龄";
            cell.contentLabel.text = [self.curPatientModel.patientAge stringValue];
            cell.imageList = @[];
        }
    }else if (indexPath.section == 1){
        //术前检查单
        cell.titleLabel.text = @"术前检查单";
        cell.contentLabel.text = @"";
        cell.imageList = self.checkImages;
    }else {
        //患者CT片
        cell.titleLabel.text = @"患者CT片";
        cell.contentLabel.text = @"";
        cell.imageList = self.ctImages;
    }
    return cell;
}

#pragma mark - ********************* Lazy Method ***********************
- (NSMutableArray *)checkImages{
    if (!_checkImages) {
        _checkImages = [NSMutableArray array];
    }
    return _checkImages;
}

- (NSMutableArray *)ctImages{
    if (!_ctImages) {
        _ctImages = [NSMutableArray array];
    }
    return _ctImages;
}

@end
