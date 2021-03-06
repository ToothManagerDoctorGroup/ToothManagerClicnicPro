//
//  TTMIncomeController.m
//  ToothManager
//

#import "TTMIncomeController.h"
#import "TTMIncomeCell.h"
#import "TTMIncomeModel.h"
#import "MJRefresh.h"
#import "TTMClinicModel.h"
#import "TTMIncomDetailController.h"
#import "TTMScheduleCellModel.h"
#import "TTMChargeDetailController.h"

#define kMargin 10.f
#define kTitleFontSize 14
#define kContenFontSize 17
#define kIncomeContenColor MainColor
#define kStayIncomeContenColor RGBColor(249, 0, 62)
#define kHeaderViewH 80.f
#define kSectionH 30.f

@interface TTMIncomeController ()<
    UITableViewDelegate,
    UITableViewDataSource,
    TTMIncomeCellDelegate>

@property (nonatomic, weak)   UITableView *tableView;
@property (nonatomic, strong) NSArray *sections; // 分组 , 存放nsdictionary ，key:(title,data)
@property (nonatomic, strong) NSArray *dataArray; // 废弃

@property (nonatomic, weak)   UILabel *incomeLabel; // 收入金额
@property (nonatomic, weak)   UILabel *stayIncomeLabel; // 待收金额
@property (nonatomic, strong) TTMClinicModel *accountModel; // 账户信息
@end

@implementation TTMIncomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收入";
    [self setupTableView];
    [self setupHeaderView];
    
    [self queryAccountData];
    [self queryData];
}

/**
 *  加载tableviewHeader
 */
- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel *incomeTitleLabel = [[UILabel alloc] init];
    incomeTitleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    incomeTitleLabel.textAlignment = NSTextAlignmentCenter;
    incomeTitleLabel.text = @"待收金额";
    [headerView addSubview:incomeTitleLabel];
    
    UILabel *stayIncomeTitleLabel = [[UILabel alloc] init];
    stayIncomeTitleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    stayIncomeTitleLabel.textAlignment = NSTextAlignmentCenter;
    stayIncomeTitleLabel.text = @"已收金额";
    [headerView addSubview:stayIncomeTitleLabel];
    
    UILabel *incomeLabel = [[UILabel alloc] init];
    incomeLabel.font = [UIFont boldSystemFontOfSize:kContenFontSize];
    incomeLabel.textColor = kStayIncomeContenColor;
    incomeLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:incomeLabel];
    self.incomeLabel = incomeLabel;
    
    UILabel *stayIncomeLabel = [[UILabel alloc] init];
    stayIncomeLabel.font = [UIFont boldSystemFontOfSize:kContenFontSize];
    stayIncomeLabel.textColor = kIncomeContenColor;
    stayIncomeLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:stayIncomeLabel];
    self.stayIncomeLabel = stayIncomeLabel;
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TableViewCellSeparatorColor;
    [headerView addSubview:separatorView];
    
    CGFloat kLabelW = ScreenWidth / 2;
    CGFloat kLabelH = 25.f;
    
    headerView.frame = CGRectMake(0, 0, ScreenWidth, kHeaderViewH);
    incomeLabel.frame = CGRectMake(0, 2 * kMargin, kLabelW, kLabelH);
    incomeTitleLabel.frame = CGRectMake(0, incomeLabel.bottom, kLabelW, kLabelH);
    stayIncomeLabel.frame = CGRectMake(kLabelW, 2 * kMargin, kLabelW, kLabelH);
    stayIncomeTitleLabel.frame = CGRectMake(kLabelW, stayIncomeLabel.bottom, kLabelW, kLabelH);
    separatorView.frame = CGRectMake(kLabelW - TableViewCellSeparatorHeight, kMargin,
                                     TableViewCellSeparatorHeight, kHeaderViewH - 2 * kMargin);
    
    UIView *bgView = [[UIView alloc] init];
    [bgView addSubview:headerView];
    bgView.frame = CGRectMake(0, 0, ScreenWidth, kHeaderViewH + 2 * kMargin);
    
    self.tableView.tableHeaderView = bgView;
}
/**
 *  加载tableview
 */
- (void)setupTableView {
    CGFloat tableHeight = ScreenHeight;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableHeight)
                                                          style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *sectionDict = self.sections[section];
    NSArray *sectionArray = sectionDict[@"data"];
    return sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kSectionH)];
    yearLabel.backgroundColor = [UIColor clearColor];
    yearLabel.textAlignment = NSTextAlignmentCenter;
    yearLabel.font = [UIFont systemFontOfSize:15];
    NSDictionary *sectionDict = self.sections[section];
    yearLabel.text = sectionDict[@"title"];
    return yearLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *sectionDict = self.sections[indexPath.section];
    NSArray *sectionArray = sectionDict[@"data"];
    TTMIncomeCellModel *model = sectionArray[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTMIncomeCell *cell = [ TTMIncomeCell cellWithTableView:tableView];
    cell.delegate = self;
    NSDictionary *sectionDict = self.sections[indexPath.section];
    NSArray *sectionArray = sectionDict[@"data"];
    TTMIncomeCellModel *model = sectionArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/**
 *  点击行事件，进入详情
 *
 *  @param cell        cell
 *  @param incomeModel 预约model
 */
- (void)incomeCell:(TTMIncomeCell *)cell incomModel:(TTMIncomeModel *)incomeModel {
//    TTMIncomDetailController *detailVC = [[TTMIncomDetailController alloc] init];
//    TTMScheduleCellModel *cellModel = [[TTMScheduleCellModel alloc] init];
//    cellModel.appoint_id = incomeModel.appoint_id;
//    detailVC.model = cellModel;
//    [self.navigationController pushViewController:detailVC animated:YES];
    
    TTMChargeDetailController *incomeVC = [TTMChargeDetailController new];
    TTMApointmentModel *model = [TTMApointmentModel new];
    model.KeyId = [incomeModel.appoint_id integerValue];
    incomeVC.model =  model;
    [self.navigationController pushViewController:incomeVC animated:YES];
}

/**
 *  查询收入数据
 */
- (void)queryData {
    __weak __typeof(&*self) weakSelf = self;
    [TTMIncomeCellModel queryIncomeListWithComplete:^(id result) {
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        } else {
            weakSelf.sections = [weakSelf sortArrayByYear:result];
            [weakSelf.tableView reloadData];
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
            weakSelf.stayIncomeLabel.text = [NSString stringWithFormat:@"￥%@", @(weakSelf.accountModel.paid)];
            weakSelf.incomeLabel.text = [NSString stringWithFormat:@"￥%@", @(weakSelf.accountModel.unpaid)];
        }
    }];
}

/**
 *  按年分组排序
 *
 *  @param array 返回的结果数组
 *
 *  @return TTMIncomeCellModel 数组
 */
- (NSArray *)sortArrayByYear:(NSArray *)array {
    NSMutableArray *yearArray = [NSMutableArray array];
    NSDate *lastDate = nil; // 上一次date
    
    for (NSUInteger i = 0; i < array.count; i ++) {
        TTMIncomeModel *incomeModel = array[i];
        incomeModel.person = [NSString stringWithFormat:@"%@付款", incomeModel.doctor_name];
        incomeModel.time = incomeModel.datetime;
        incomeModel.mony = [NSString stringWithFormat:@"%@元", @(incomeModel.money)];
        incomeModel.state = incomeModel.status;
        NSDate *dateTime = [incomeModel.datetime dateValue];
        
        if ([dateTime fs_year] != [lastDate fs_year]) { // 与前一条数据的年份不相同
            NSMutableArray *monthArray = [NSMutableArray array];
            [monthArray addObject:incomeModel];
            [yearArray addObject:monthArray];
        } else { // 相同则继续添加
            NSMutableArray *monthArray = [yearArray lastObject];
            [monthArray addObject:incomeModel];
        }
        lastDate = [dateTime copy];
    }
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSMutableArray *yearsMonth in yearArray) {
        NSArray *monthArray = [self sortArrayByMonth:yearsMonth]; // 得到月份数组
        TTMIncomeCellModel *cellModel = monthArray[0];
        NSDictionary *dict = @{@"title": [cellModel.year stringByAppendingString:@"年"],
                               @"data": monthArray};
        [tempArray addObject:dict];
    }
    return tempArray;
}

/**
 *  按月分组排序
 *
 *  @param array 返回的结果数组
 *
 *  @return TTMIncomeCellModel 数组
 */
- (NSArray *)sortArrayByMonth:(NSArray *)array {
    NSMutableArray *mutArray = [NSMutableArray array];
    NSDate *lastDate = nil;
    
    for (NSUInteger i = 0; i < array.count; i ++) {
        TTMIncomeModel *incomeModel = array[i];
        NSDate *dateTime = [incomeModel.datetime dateValue];
        
        if ([dateTime fs_month] != [lastDate fs_month]) { // 与前一条数据的月份不相同
            TTMIncomeCellModel *incomeCellModel = [[TTMIncomeCellModel alloc] init];
            incomeCellModel.month = [NSString stringWithFormat:@"%@", @([dateTime fs_month])];
            incomeCellModel.year = [NSString stringWithFormat:@"%@", @([dateTime fs_year])];
            [incomeCellModel.infoList addObject:incomeModel];
            [mutArray addObject:incomeCellModel];
        } else {
            TTMIncomeCellModel *incomeCellModel = [mutArray lastObject];
            [incomeCellModel.infoList addObject:incomeModel];
        }
        lastDate = [dateTime copy];
    }
    return mutArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
