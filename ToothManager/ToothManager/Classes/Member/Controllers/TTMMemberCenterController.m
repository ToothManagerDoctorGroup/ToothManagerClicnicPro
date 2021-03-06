//
//  TTMMemberCenterController.m
//  ToothManager
//

#import "TTMMemberCenterController.h"
#import "MJRefresh.h"
#import "TTMMemberCell.h"
#import "TTMSettingController.h"
#import "TTMIncomeController.h"
#import "TTMMessageController.h"
#import "TTMClinicModel.h"
#import "TTMDoctorsController.h"
#import "TTMMessageCellModel.h"
#import "TTMWithdrawController.h"
#import "TTMClinicInfoController.h"
#import "TTMAddBankCardController.h"
#import "TTMApointmentSegmentController.h"
#import "TTMAppointmentController.h"

#define kRowHeight 44.f
#define kMargin 10.f
#define kLogoW 60.f
#define kLogoH kLogoW
#define kHeaderLabelX (2 * kMargin + kLogoW)
#define kHeaderLabelW (ScreenWidth - kHeaderLabelX)
#define kHeaderLabelH 20.f
#define kHeaderViewH 100.f

#define kHospitalFontSize 17
#define kLabelFontSize 14

@interface TTMMemberCenterController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    TTMMemberCellDelegate>

@property (nonatomic, weak)   UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak)   UIView *headerView;
@property (nonatomic, weak)   UILabel *hospitalLabel; // 医院名称
@property (nonatomic, weak)   UILabel *addressLabel; // 地址
@property (nonatomic, weak)   UILabel *timeLabel; // 营业时间

@property (nonatomic, strong) TTMClinicModel *headerModel; // headerView的model
@property (nonatomic, strong) TTMClinicModel *summaryModel; // 医生数，预约数，收入的model
@property (nonatomic, strong) TTMClinicModel *bankModel; // 银行卡的model
@property (nonatomic, strong) TTMClinicModel *accountModel; // 账户的model

@property (nonatomic, assign) NSInteger notReadCount; // 未读条数
@end

@implementation TTMMemberCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员中心";
    
    [self queryHeaderData];
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tableView.header beginRefreshing];
    [self queryAllData];
}

/**
 *  懒加载数据模型
 *
 *  @return 数据
 */
- (NSArray *)dataArray {
    NSString *balanceContent = [NSString stringWithFormat:@"%@", @(self.accountModel.paid)];
    TTMMemberCellModel *balanceModel = [[TTMMemberCellModel alloc] initWithTitle:@"账户余额:"
                                                                         content:balanceContent
                                                                     buttonTitle:@"提现"
                                                                     contenColor:[UIColor redColor]
                                                                      messageNum:0
                                                                      accessType:TTMMemberCellModelAccessTypeButton];
    balanceModel.controllerClass = [TTMWithdrawController class];
    
    NSString *bankContent = self.bankModel.bank_card;
    if (bankContent.length >= 11) {
        bankContent = [bankContent stringByReplacingCharactersInRange:NSMakeRange(5, 10) withString:@"********"];
    }
    TTMMemberCellModel *bankNoModel = [[TTMMemberCellModel alloc] initWithTitle:@"我的银行卡:"
                                                                        content:bankContent
                                                                    buttonTitle:self.bankModel.keyId ? @"修改" : @"添加"
                                                                    contenColor:nil
                                                                     messageNum:0
                                                                     accessType:TTMMemberCellModelAccessTypeButton];
//    if (self.bankModel.keyId) { // 有值，表示有卡
        bankNoModel.controllerClass = [TTMAddBankCardController class];
//    }
    
    NSString *doctorContent = [NSString stringWithFormat:@"%@人", @(self.summaryModel.doctor_count)];
    TTMMemberCellModel *doctorsModel = [[TTMMemberCellModel alloc] initWithTitle:@"我的医生:"
                                                                         content:doctorContent
                                                                     buttonTitle:nil
                                                                     contenColor:nil
                                                                      messageNum:0
                                                                      accessType:TTMMemberCellModelAccessTypeArrow];
    doctorsModel.controllerClass = [TTMDoctorsController class];
    
    NSString *appointContent = [NSString stringWithFormat:@"%@次", @(self.summaryModel.appoint_count)];
    TTMMemberCellModel *appointmentModel = [[TTMMemberCellModel alloc] initWithTitle:@"我的预约:"
                                                                             content:appointContent
                                                                         buttonTitle:nil
                                                                         contenColor:nil
                                                                          messageNum:0
                                                                          accessType:TTMMemberCellModelAccessTypeArrow];
    appointmentModel.controllerClass = [TTMApointmentSegmentController class];
    
    NSString *incomContent = [NSString stringWithFormat:@"%@",
                              @(self.accountModel.paid + self.accountModel.unpaid)];
    TTMMemberCellModel *incomeModel = [[TTMMemberCellModel alloc] initWithTitle:@"我的收入:"
                                                                        content:incomContent
                                                                    buttonTitle:nil
                                                                    contenColor:nil
                                                                     messageNum:0
                                                                     accessType:TTMMemberCellModelAccessTypeArrow];
    incomeModel.controllerClass = [TTMIncomeController class];
    
    TTMMemberCellModel *messageModel = [[TTMMemberCellModel alloc] initWithTitle:@"我的消息"
                                                                        content:nil
                                                                    buttonTitle:nil
                                                                    contenColor:nil
                                                                      messageNum:self.notReadCount
                                                                     accessType:TTMMemberCellModelAccessTypeArrow];
    messageModel.controllerClass = [TTMMessageController class];
    TTMMemberCellModel *settingModel = [[TTMMemberCellModel alloc] initWithTitle:@"设置"
                                                                        content:nil
                                                                    buttonTitle:nil
                                                                    contenColor:nil
                                                                     messageNum:0
                                                                     accessType:TTMMemberCellModelAccessTypeArrow];
    settingModel.controllerClass = [TTMSettingController class];
    
    NSArray *section1 = @[balanceModel, bankNoModel];
    NSArray *section2 = @[incomeModel];
    NSArray *section3 = @[settingModel];
    _dataArray = @[section1, section2, section3];

    return _dataArray;
}
/**
 *  加载table头视图
 */
- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = MainColor;
    self.headerView = headerView;
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    [headerView addSubview:logoImageView];
    
    UILabel *hospitalLabel = [[UILabel alloc] init];
    hospitalLabel.textColor = [UIColor whiteColor];
    hospitalLabel.adjustsFontSizeToFitWidth = YES;
    hospitalLabel.font = [UIFont systemFontOfSize:kHospitalFontSize];
    [headerView addSubview:hospitalLabel];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.adjustsFontSizeToFitWidth = YES;
    addressLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    [headerView addSubview:addressLabel];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.font = [UIFont systemFontOfSize:kLabelFontSize];
    [headerView addSubview:timeLabel];
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setBackgroundImage:[UIImage imageNamed:@"gtask_hand_button_bg"] forState:UIControlStateNormal];
    editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    editButton.tag = 1;
    [editButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:editButton];
    
    [logoImageView sd_setImageWithURL:[NSURL URLWithString:self.headerModel.clinic_img]
                     placeholderImage:[UIImage imageNamed:@"clinic_head_placeholder"]];
    hospitalLabel.text = self.headerModel.clinic_name;
    addressLabel.text = [NSString stringWithFormat:@"诊所地址：%@", self.headerModel.clinic_location];
    timeLabel.text = [NSString stringWithFormat:@"营业时间：%@", self.headerModel.business_hours];
    
    headerView.frame = CGRectMake(0, 0, ScreenWidth, kHeaderViewH);
    logoImageView.frame = CGRectMake(kMargin, 2 * kMargin, kLogoW, kLogoH);
    [logoImageView circleImageViewWithCornRaduis:kLogoH / 2];
    
    hospitalLabel.frame = CGRectMake(kHeaderLabelX, 2 * kMargin, kHeaderLabelW, kHeaderLabelH);
    addressLabel.frame = CGRectMake(kHeaderLabelX, hospitalLabel.bottom, kHeaderLabelW, kHeaderLabelH);
    timeLabel.frame = CGRectMake(kHeaderLabelX, addressLabel.bottom, kHeaderLabelW, kHeaderLabelH);
    CGFloat buttonW = 50.f;
    CGFloat buttonH = 30.f;
    CGFloat buttonY = 60.f;
    editButton.frame = CGRectMake(ScreenWidth - kMargin - buttonW, buttonY, buttonW, buttonH);
    self.tableView.tableHeaderView = headerView;
}
/**
 *  加载tableview
 */
- (void)setupTableView {
    CGFloat tableHeight = ScreenHeight;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableHeight)
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = kRowHeight;
    tableView.delaysContentTouches = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak __typeof(&*self) weakSelf = self;
    [tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf queryAllData];
    }];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma maek - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2 * kMargin;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMMemberCell *cell = [TTMMemberCell cellWithTableView:tableView];
    cell.delegate = self;
    if (self.dataArray.count > 0) {
        TTMMemberCellModel *model = self.dataArray[indexPath.section][indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTMMemberCellModel *model = self.dataArray[indexPath.section][indexPath.row];
    [self jumpWithModel:model];
}

#pragma mark - 事件

/**
 *  点击cell右边按钮
 *
 *  @param cell  cell description
 *  @param model model description
 */
- (void)memberCell:(TTMMemberCell *)cell clickedModel:(TTMMemberCellModel *)model {
    [self jumpWithModel:model];
}

/**
 *  页面跳转逻辑
 *
 *  @param model cell的model
 */
- (void)jumpWithModel:(TTMMemberCellModel *)model {
    if (model.controllerClass) {
        if ([model.controllerClass isSubclassOfClass:[TTMWithdrawController class]]) { // 提现,判断是否有银行卡
            if (self.bankModel.keyId) { // 有银行卡信息
                TTMWithdrawController *controller = [TTMWithdrawController new];
                controller.bankModel = self.bankModel;
                controller.accountModel = self.accountModel;
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                [MBProgressHUD showToastWithText:@"请先添加银行卡"];
            }
        } else if ([model.controllerClass isSubclassOfClass:[TTMAddBankCardController class]]) { // 添加银行卡
            TTMAddBankCardController *controller = [[[model.controllerClass class] alloc] init];
            if ([model.buttonTitle isEqualToString:@"添加"]) {
                controller.type = TTMAddBankCardControllerTypeAdd;
            } else {
                controller.type = TTMAddBankCardControllerTypeUpdate;
                controller.bankModel = self.bankModel;
            }
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [self.navigationController pushViewController:[[[model.controllerClass class] alloc] init] animated:YES];
        }
    }
}

- (void)buttonAction:(UIButton *)button {
    if (button.tag == 1) { // 编辑 点击事件
        TTMClinicInfoController *clinicInfoVC = [TTMClinicInfoController new];
        [self.navigationController pushViewController:clinicInfoVC animated:YES];
    }
}

#pragma mark - 网络请求

/**
 *  查询header，诊所信息
 */
- (void)queryHeaderData {
    __weak __typeof(&*self) weakSelf = self;
    [TTMClinicModel queryClinicDetailWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.headerModel = result;
            [weakSelf setupHeaderView];
        }
    }];
}

/**
 *  查询账户信息
 */
- (void)queryAccountData {
    __weak __typeof(&*self) weakSelf = self;
    [TTMClinicModel queryClinicAccountWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.accountModel = result;
            [weakSelf.tableView reloadData];
        }
    }];
}

/**
 *  查询银行卡信息
 */
- (void)queryBankData {
    __weak __typeof(&*self) weakSelf = self;
    [TTMClinicModel queryClinicBankWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.bankModel = result;
            [weakSelf.tableView reloadData];
        }
    }];
}

/**
 *  查询汇总信息
 */
- (void)querySummaryData {
    __weak __typeof(&*self) weakSelf = self;
    [TTMClinicModel queryClinicSummaryWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.summaryModel = result;
            [weakSelf.tableView reloadData];
        }
    }];
}

/**
 *  查询未读条数
 */
- (void)queryNotReadCount {
    __weak __typeof(&*self) weakSelf = self;
    [TTMMessageCellModel queryNotReadCountWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.notReadCount = [result integerValue];
            [weakSelf.tableView reloadData];
        }
    }];
}

/**
 *  查询所有数据
 */
- (void)queryAllData {
    [self queryHeaderData];
    [self queryAccountData];
    [self queryBankData];
    [self querySummaryData];
    [self queryNotReadCount];
    [self.tableView.header endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
