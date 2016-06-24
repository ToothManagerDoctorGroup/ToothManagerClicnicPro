//
//  TTMChairUsageRateController.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMChairUsageRateController.h"
#import "TTMStatisticsChartView.h"
#import "TTMStatisticsChartModel.h"
#import "TTMStatisticsChartHeaderFooterView.h"
#import "XLTagView.h"
#import "TTMStatisticsFormView.h"
#import "ZFColor.h"
#import "Masonry.h"
#import "TTMStatisticsTool.h"
#import "TTMDateTool.h"

@interface TTMChairUsageRateController ()<TTMStatisticsChartViewDataSource>

@property (nonatomic, strong)TTMStatisticsChartModel *model;

@end

@implementation TTMChairUsageRateController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置视图的样式
        self.style = StatisticsChartStyleBar;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //请求椅位使用率数据
    [self queryData];
}

#pragma mark 请求椅位使用率数据
- (void)queryData{
    __weak typeof(self) weakSelf = self;
    NSString *startTime = [TTMDateTool getMonthBeginWith:[NSDate date]];
    NSString *endTime = [TTMDateTool getMonthEndWith:[NSDate date]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TTMStatisticsTool queryChairUsageRateWithBeginTime:startTime endTime:endTime complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        }else{
            //X轴显示标题数组(获取所有的椅位名称)
            NSMutableArray *chairNames = [NSMutableArray array];
            NSMutableArray *axisXTitles = [NSMutableArray array];
            NSMutableArray *axisYDataArray = [NSMutableArray array];
            NSMutableArray *randomColors = [NSMutableArray array];
            NSMutableArray *formDataArray = [NSMutableArray arrayWithObject:[[TTMStatisticsFormModel alloc] initWIthTitle:@"日期" content:@"椅位使用率"]];
            NSArray *sectionArray = result;
            for (int i = 0; i < sectionArray.count; i++) {
                NSArray *rows = sectionArray[i];
                for (int j = 0; j < rows.count; j++) {
                    TTMChairUsageRateModel *chairModel = rows[j];
                    
                    //设置椅位名称
                    if (i == 0) {
                        [chairNames addObject:chairModel.seatName];
                    }
                    //设置X轴数据
                    if (j == 0) {
                        NSString *xTitle = [chairModel.curDate componentsSeparatedByString:@" "][0];
                        [axisXTitles addObject:xTitle];
                        
                        TTMStatisticsFormModel *formModel = [[TTMStatisticsFormModel alloc] initWIthTitle:xTitle content:[NSString stringWithFormat:@"%.2f",[chairModel.curRate floatValue]]];
                        [formDataArray addObject:formModel];
                    }
                }
            }
            
            for (int i = 0; i < chairNames.count; i++) {
                [randomColors addObject:ZFRandomColor];
            }
            
            //创建Y轴数据
            for (int i = 0; i < chairNames.count; i++) {
                NSMutableArray *tempArr = [NSMutableArray array];
                for (int j = 0; j < sectionArray.count; j++) {
                    //设置y轴数据
                    NSArray *subArray = sectionArray[j];
                    TTMChairUsageRateModel *model = subArray[i];
                    [tempArr addObject:[NSString stringWithFormat:@"%.2f",[model.curRate floatValue]]];
                }
                [axisYDataArray addObject:tempArr];
            }
            
            //创建模型数据
            TTMStatisticsChartModel *model = [[TTMStatisticsChartModel alloc] init];
            model.axisXTitles = axisXTitles;
            model.axisYDataArray = axisYDataArray;
            model.maxValue = 100;
            model.ySection = 8;
            model.colors = randomColors;
            
            //创建头部数据
            NSMutableArray *headerArray = [NSMutableArray array];
            for (int i = 0; i < chairNames.count; i++) {
                TTMStatisticsChartHeaderFooterModel *footerM = [[TTMStatisticsChartHeaderFooterModel alloc] init];
                footerM.color = model.colors[i];
                footerM.content = chairNames[i];
                [headerArray addObject:footerM];
            }
            model.headerSourceArray = headerArray;
            weakSelf.model = model;
            //设置表格数据
            weakSelf.formSourceArray = formDataArray;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - TTMStatisticsChartViewDataSource
- (BOOL)chartViewShowHeaderView:(TTMStatisticsChartView *)chartView{
    return YES;
}

- (TTMStatisticsChartModel *)chartViewSourceArrayForChart:(TTMStatisticsChartView *)chartView{
    
    return self.model;
}


@end
