//
//  TTMIncomeStatisticsController.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMIncomeStatisticsController.h"
#import "TTMStatisticsChartModel.h"
#import "TTMStatisticsChartHeaderFooterView.h"
#import "ZFColor.h"
#import "TTMDateTool.h"
#import "TTMStatisticsTool.h"
#import "TTMStatisticsFormView.h"
#import "UIColor+TTMAddtion.h"

@interface TTMIncomeStatisticsController ()

@property (nonatomic, strong)TTMStatisticsChartModel *model;

@end

@implementation TTMIncomeStatisticsController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置视图的样式
        self.style = StatisticsChartStyleLine;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //查询收入统计
    [self queryData];
}

#pragma mark - 查询收入统计
- (void)queryData{
    __weak typeof(self) weakSelf = self;
    NSString *startTime = [TTMDateTool getMonthBeginWith:[NSDate date]];
    NSString *endTime = [TTMDateTool getMonthEndWith:[NSDate date]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TTMStatisticsTool queryIncomeWithBeginTime:startTime endTime:endTime complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        }else{
            //最大预约数
            CGFloat maxIncome = [[result valueForKeyPath:@"@max.totalMoney.integerValue"] integerValue];
            
            //X轴显示标题数组
            NSMutableArray *axisXTitles = [NSMutableArray array];
            NSMutableArray *axisYDataArray = [NSMutableArray array];
            NSMutableArray *formDataArray = [NSMutableArray arrayWithObject:[[TTMStatisticsFormModel alloc] initWIthTitle:@"日期" content:@"收入（元）"]];
            for (TTMStatisticsIncomeModel *model in result) {
                NSString *titleStr = [model.curDate componentsSeparatedByString:@" "][0];
                NSString *contentStr = [NSString stringWithFormat:@"%ld",(long)[model.totalMoney integerValue]];
                [axisXTitles addObject:titleStr];
                [axisYDataArray addObject:contentStr];
                
                TTMStatisticsFormModel *formModel = [[TTMStatisticsFormModel alloc] initWIthTitle:titleStr content:contentStr];
                [formDataArray addObject:formModel];
            }
            
            //创建模型数据
            TTMStatisticsChartModel *model = [[TTMStatisticsChartModel alloc] init];
            model.axisXTitles = axisXTitles;
            model.axisYDataArray = axisYDataArray;
            model.maxValue = maxIncome;
            model.ySection = 8;
            model.colors = @[MainColor];
            
            weakSelf.model = model;
            //设置表格数据
            weakSelf.formSourceArray = formDataArray;
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (TTMStatisticsChartModel *)chartViewSourceArrayForChart:(TTMStatisticsChartView *)chartView{
    
    return self.model;
}

@end
