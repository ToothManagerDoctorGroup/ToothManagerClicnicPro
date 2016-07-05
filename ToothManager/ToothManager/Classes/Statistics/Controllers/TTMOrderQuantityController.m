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
#import "ZFColor.h"

@interface TTMOrderQuantityController ()<TTMStatisticsChartViewDataSource>

@property (nonatomic, strong)TTMStatisticsChartModel *model;

@end

@implementation TTMOrderQuantityController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //设置视图的样式
        self.style = StatisticsChartStyleBar;
        self.showFormViewHeader = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //请求椅位使用率数据
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

- (void)queryDataWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TTMStatisticsTool queryDoctorReserveAmountWithBeginTime:startTime endTime:endTime complete:^(id result) {
        [hud hide:YES];
        if ([result isKindOfClass:[NSString class]]) {
            [MBProgressHUD showToastWithText:result];
        }else{
            NSArray *sectionArray = result;
            //最大预约数
            CGFloat maxReserveCount = [[result valueForKeyPath:@"@max.reserveCount.integerValue"] integerValue];
            //X轴显示标题数组
            NSMutableArray *axisXTitles = [NSMutableArray array];
            NSMutableArray *axisYDataArray = [NSMutableArray array];
            NSMutableArray *formDataArray = [NSMutableArray arrayWithObject:[[TTMStatisticsFormModel alloc] initWIthTitle:@"医生" content:@"预约量（次）"]];
            
            if (sectionArray.count > 0) {
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
                model.maxValue = maxReserveCount > 8 ? maxReserveCount : 8;
                model.ySection = 8;
                model.colors = @[MainColor];
                model.unit = @"数量";
                weakSelf.model = model;
                //设置表格数据
                TTMStatisticsFormSourceModel *formSourceModel = [[TTMStatisticsFormSourceModel alloc] init];
                formSourceModel.sourceArray = @[formDataArray];
                weakSelf.formSourceModel = formSourceModel;
            }else{
                //创建模型数据
                TTMStatisticsChartModel *model = [[TTMStatisticsChartModel alloc] init];
                model.axisXTitles = @[];
                model.axisYDataArray = @[axisYDataArray];
                model.maxValue = 8;
                model.ySection = 8;
                model.unit = @"数量";
                model.colors = @[MainColor];
                weakSelf.model = model;
                
                //设置表格数据
                weakSelf.formSourceModel = nil;
            }
        }
    }];
}


#pragma mark - TTMStatisticsChartViewDataSource
- (TTMStatisticsChartModel *)chartViewSourceArrayForChart:(TTMStatisticsChartView *)chartView{
    return self.model;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)exportButtonAction{
}

@end
