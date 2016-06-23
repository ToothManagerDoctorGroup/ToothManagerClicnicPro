//
//  TTMOrderQuantityController.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMOrderQuantityController.h"
#import "TTMStatisticsChartModel.h"
#import "TTMStatisticsChartHeaderFooterView.h"
#import "TTMStatisticsChartView.h"
#import "TTMStatisticsFormView.h"
#import "TTMStatisticsTool.h"
#import "TTMDateTool.h"
#import "Masonry.h"

@interface TTMOrderQuantityController ()<TTMStatisticsChartViewDataSource>

@property (nonatomic, strong)TTMStatisticsChartModel *model;

@end

@implementation TTMOrderQuantityController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self queryData];
}

- (void)queryData{
    __weak typeof(self) weakSelf = self;
    NSString *startTime = [TTMDateTool getMonthBeginWith:[NSDate date]];
    NSString *endTime = [TTMDateTool getMonthEndWith:[NSDate date]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TTMStatisticsTool queryDoctorReserveAmountWithBeginTime:startTime endTime:endTime complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        }else{
            //最大预约数
            CGFloat maxReserveCount = [[result valueForKeyPath:@"@max.reserveCount.integerValue"] integerValue];
            //X轴显示标题数组
            NSMutableArray *axisXTitles = [NSMutableArray array];
            NSMutableArray *axisYDataArray = [NSMutableArray array];
            NSMutableArray *formDataArray = [NSMutableArray arrayWithObject:[[TTMStatisticsFormModel alloc] initWIthTitle:@"医生" content:@"预约量（次）"]];
            for (TTMReserveAmountModel *amountM in result) {
                [axisXTitles addObject:amountM.doctorName];
                [axisYDataArray addObject:[amountM.reserveCount stringValue]];
                
                TTMStatisticsFormModel *formModel = [[TTMStatisticsFormModel alloc] initWIthTitle:amountM.doctorName content:[amountM.reserveCount stringValue]];
                [formDataArray addObject:formModel];
            }
            //创建模型数据
            TTMStatisticsChartModel *model = [[TTMStatisticsChartModel alloc] init];
            model.axisXTitles = axisXTitles;
            model.axisYDataArray = @[axisYDataArray];
            model.axisYRange = CGRangeMake(maxReserveCount, 0);
            model.colors = @[[UUColor green],[UUColor red],[UUColor brown],[UIColor purpleColor],[UIColor orangeColor],[UIColor blueColor]];
            weakSelf.model = model;
            //设置表格数据
            weakSelf.formSourceArray = formDataArray;
        }
    }];
}


#pragma mark - TTMStatisticsChartViewDataSource
- (BOOL)chartViewShowFooterView:(TTMStatisticsChartView *)chartView{
    return YES;
}

- (TTMStatisticsChartModel *)chartViewSourceArrayForChart:(TTMStatisticsChartView *)chartView{
    return self.model;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)exportButtonAction{
    TTMLog(@"导出第二个");
}

@end