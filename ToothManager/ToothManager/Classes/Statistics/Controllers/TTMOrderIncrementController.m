//
//  TTMOrderIncrementController.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMOrderIncrementController.h"
#import "TTMStatisticsChartModel.h"
#import "TTMStatisticsChartHeaderFooterView.h"

@interface TTMOrderIncrementController ()

@end

@implementation TTMOrderIncrementController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)chartViewShowHeaderView:(TTMStatisticsChartView *)chartView{
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
    model.headerSourceArray = footerArray;
    
    return model;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
