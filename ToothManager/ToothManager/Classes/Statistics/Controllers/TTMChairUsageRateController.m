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
#import "Masonry.h"

@interface TTMChairUsageRateController ()<TTMStatisticsChartViewDataSource>

//@property (nonatomic, strong)TTMStatisticsChartView *chartView;
//@property (nonatomic, strong)TTMStatisticsFormView *formView;
//@property (nonatomic, strong)UIScrollView *scorllView;


@end

@implementation TTMChairUsageRateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i < 10; i++) {
//        TTMStatisticsFormModel *model = [[TTMStatisticsFormModel alloc] initWIthTitle:@"李四" content:@"12"];
//        [array addObject:model];
//    }
//    
////    [self.view addSubview:self.chartView];
//    [self.view addSubview:self.scorllView];
//    [self.scorllView addSubview:self.chartView];
//    [self.scorllView addSubview:self.formView];
//    
//    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view);
//        make.top.equalTo(self.scorllView);
//        make.right.equalTo(self.view);
//        make.bottom.equalTo(self.chartView.bottomContraints);
//    }];
//
//    [self.formView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(10);
//        make.right.equalTo(self.view).offset(-10);
//        make.top.mas_equalTo(self.chartView.mas_bottom).offset(10);
//        make.height.mas_equalTo([TTMStatisticsFormView formViewHeightWithArray:array]);
//    }];
//    self.formView.sourceArray = array;
//    
//    [self.scorllView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(55, 0, 0, 0));
//        make.bottom.mas_equalTo(self.formView.mas_bottom).offset(10);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - TTMStatisticsChartViewDataSource
- (BOOL)chartViewShowFooterView:(TTMStatisticsChartView *)chartView{
    return YES;
}

- (TTMStatisticsChartModel *)chartViewSourceArrayForChart:(TTMStatisticsChartView *)chartView{
    TTMStatisticsChartModel *model = [[TTMStatisticsChartModel alloc] init];
    NSArray *ary1 = @[@"22",@"54",@"15",@"30",@"42",@"77",@"43"];
    NSArray *ary2 = @[@"76",@"34",@"54",@"23",@"16",@"32",@"17"];
    model.axisXTitles = @[@"R1",@"R2",@"R3",@"R4",@"R5",@"R6",@"R7"];
    model.axisYDataArray = @[ary1,ary2];
    model.axisYRange = CGRangeMake(90, 0);
    model.colors = @[[UUColor green],[UUColor red],[UUColor brown],[UIColor purpleColor],[UIColor orangeColor],[UIColor blueColor]];
    
    NSMutableArray *footerArray = [NSMutableArray array];
    NSArray *titles = @[@"种植",@"拆线",@"复查",@"修复",@"洗牙"];
    for (int i = 0; i < titles.count; i++) {
        TTMStatisticsChartHeaderFooterModel *footerM = [[TTMStatisticsChartHeaderFooterModel alloc] init];
        footerM.color = model.colors[i];
        footerM.content = titles[i];
        [footerArray addObject:footerM];
    }
    model.footerSourceArray = footerArray;
    
    return model;
}


//- (TTMStatisticsChartView *)chartView{
//    if (!_chartView) {
//        _chartView = [[TTMStatisticsChartView alloc] initWithFrame:CGRectZero dataSource:self style:StatisticsChartStyleBar];
//    }
//    return _chartView;
//}
//
//- (void)exportButtonAction{
//    TTMLog(@"导出第一个");
//}
//
//#pragma mark - 表格视图
//- (TTMStatisticsFormView *)formView{
//    if (!_formView) {
//        _formView = [[TTMStatisticsFormView alloc] init];
//    }
//    return _formView;
//}
//
//#pragma mark - ScrollView
//- (UIScrollView *)scorllView{
//    if (!_scorllView) {
//        _scorllView = [[UIScrollView alloc] init];
//        _scorllView.showsVerticalScrollIndicator = YES;
//        _scorllView.bounces = NO;
//    }
//    return _scorllView;
//}


@end
