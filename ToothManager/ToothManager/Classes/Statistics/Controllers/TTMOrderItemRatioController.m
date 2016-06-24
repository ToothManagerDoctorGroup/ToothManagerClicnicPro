//
//  TTMOrderItemRatioController.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMOrderItemRatioController.h"
#import "TTMStatisticsChartView.h"
#import "TTMStatisticsChartHeaderFooterView.h"
#import "UUChart.h"
#import "TTMStatisticsChartModel.h"
#import "ZFColor.h"
#import "TTMDateTool.h"
#import "TTMStatisticsTool.h"
#import "TTMStatisticsFormView.h"

@interface TTMOrderItemRatioController ()

@property (nonatomic, strong)TTMStatisticsChartModel *model;

@end

@implementation TTMOrderItemRatioController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置视图的样式
        self.style = StatisticsChartStylePie;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //查询预约事项占比
    [self queryData];
}

#pragma mark - 查询预约事项占比
- (void)queryData{
    __weak typeof(self) weakSelf = self;
    NSString *startTime = [TTMDateTool getMonthBeginWith:[NSDate date]];
    NSString *endTime = [TTMDateTool getMonthEndWith:[NSDate date]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TTMStatisticsTool queryOrderItemRatioWithBeginTime:startTime endTime:endTime complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        }else{
            //X轴显示标题数组
            NSMutableArray *axisXTitles = [NSMutableArray array];
            NSMutableArray *axisYDataArray = [NSMutableArray array];
            NSMutableArray *randomColors = [NSMutableArray array];
            NSMutableArray *formDataArray = [NSMutableArray arrayWithObject:[[TTMStatisticsFormModel alloc] initWIthTitle:@"预约事项" content:@"占比"]];
            
            for (TTMOrderItemRatioModel *ratioModel in result) {
                [axisXTitles addObject:ratioModel.curType];
                [axisYDataArray addObject:[NSString stringWithFormat:@"%ld%%",(long)[ratioModel.proportion integerValue]]];
                
                TTMStatisticsFormModel *formModel = [[TTMStatisticsFormModel alloc] initWIthTitle:ratioModel.curType content:[NSString stringWithFormat:@"%ld%%",(long)[ratioModel.proportion integerValue]]];
                [formDataArray addObject:formModel];
            }
            
            for (int i = 0; i < axisXTitles.count; i++) {
                [randomColors addObject:ZFRandomColor];
            }
            
            //创建模型数据
            TTMStatisticsChartModel *model = [[TTMStatisticsChartModel alloc] init];
            model.axisXTitles = axisXTitles;
            model.axisYDataArray = axisYDataArray;
            model.colors = randomColors;
            
            //创建头部数据
            NSMutableArray *footerArray = [NSMutableArray array];
            for (int i = 0; i < axisXTitles.count; i++) {
                TTMStatisticsChartHeaderFooterModel *footerM = [[TTMStatisticsChartHeaderFooterModel alloc] init];
                footerM.color = randomColors[i];
                footerM.content = [NSString stringWithFormat:@"%@:%@",axisXTitles[i],axisYDataArray[i]];
                [footerArray addObject:footerM];
            }
            model.footerSourceArray = footerArray;
            
            weakSelf.model = model;
            //设置表格数据
            weakSelf.formSourceArray = formDataArray;
        }
    }];
}


- (BOOL)chartViewShowFooterView:(TTMStatisticsChartView *)chartView{
    return YES;
}

- (TTMStatisticsChartModel *)chartViewSourceArrayForChart:(TTMStatisticsChartView *)chartView{
    
    return self.model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
