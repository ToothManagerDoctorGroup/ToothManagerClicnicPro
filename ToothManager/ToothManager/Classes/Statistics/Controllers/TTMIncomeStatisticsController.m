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
        self.showFormViewHeader = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //查询收入统计
    NSString *startTime = [TTMDateTool getMonthBeginWith:[NSDate date]];
    NSString *endTime = [TTMDateTool getMonthEndWith:[NSDate date]];
    [self queryDataWithStartTime:startTime endTime:endTime];
}

#pragma mark 选择时间
- (void)selectDateWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSLog(@"执行更新操作starttime:%@--endtime:%@",startTime,endTime);
    //重新请求数据
    [self queryDataWithStartTime:startTime endTime:endTime];
}

#pragma mark - 查询收入统计
- (void)queryDataWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [TTMStatisticsTool queryIncomeWithBeginTime:startTime endTime:endTime complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        }else{
            
            NSArray *sectionArray = result;
            
            //最大预约数
            CGFloat maxIncome = [[result valueForKeyPath:@"@max.totalMoney.integerValue"] integerValue];
            
            //X轴显示标题数组
            NSMutableArray *axisXTitles = [NSMutableArray array];
            NSMutableArray *axisYDataArray = [NSMutableArray array];
            NSMutableArray *formDataArray = [NSMutableArray arrayWithObject:[[TTMStatisticsFormModel alloc] initWIthTitle:@"日期" content:@"收入（元）"]];
            
            if (sectionArray.count > 0) {
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
                TTMStatisticsFormSourceModel *formSourceModel = [[TTMStatisticsFormSourceModel alloc] init];
                formSourceModel.sourceArray = @[formDataArray];
                weakSelf.formSourceModel = formSourceModel;
            }else{
                //创建模型数据
                TTMStatisticsChartModel *model = [[TTMStatisticsChartModel alloc] init];
                model.axisXTitles = @[];
                model.axisYDataArray = @[];
                model.maxValue = 8;
                model.ySection = 8;
                model.colors = @[MainColor];
                
                weakSelf.model = model;
                //设置表格数据
                weakSelf.formSourceModel = nil;
            }
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
