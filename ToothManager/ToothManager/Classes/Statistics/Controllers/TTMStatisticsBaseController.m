//
//  TTMStatisticsBaseController.m
//  ToothManager
//
//  Created by Argo Zhang on 16/6/20.
//  Copyright © 2016年 roger. All rights reserved.
//

#import "TTMStatisticsBaseController.h"
#import "TTMStatisticsDateTagView.h"
#import "TTMStatisticsChartView.h"
#import "TTMStatisticsFormView.h"
#import "TTMStatisticsChartModel.h"
#import "TTMStatisticsChartHeaderFooterView.h"
#import "Masonry.h"

#define kTagViewHeight 55
#define kExportButtonWidth 28
#define kExportButtonHeight kExportButtonWidth
#define kMargin 10

@interface TTMStatisticsBaseController ()

@property (nonatomic, strong)TTMStatisticsDateTagView *tagView;//标签视图
@property (nonatomic, strong)TTMStatisticsFormView *formView;//表格视图
@property (nonatomic, strong)TTMStatisticsChartView *chartView;//图表视图
@property (nonatomic, strong)UIScrollView *scorllView;  //滑动父视图
@property (nonatomic, strong)UIButton *exportButton;    //导出按钮

@end

@implementation TTMStatisticsBaseController


- (void)viewDidLoad {
    [super viewDidLoad];
    if (iOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //初始化
    [self setUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - ********************* Private Method ***********************
#pragma mark 初始化
- (void)setUp{
    
    [self.view addSubview:self.tagView];
    [self.view addSubview:self.scorllView];
    [self.scorllView addSubview:self.chartView];
    [self.scorllView addSubview:self.formView];
//    [self.view addSubview:self.exportButton];
    
    [self setUpContrains];
}
#pragma mark - 设置约束
- (void)setUpContrains{
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, kTagViewHeight));
    }];
    
//    [self.exportButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view).offset(-kMargin);
//        make.bottom.equalTo(self.view).offset(-kMargin);
//        make.size.mas_equalTo(CGSizeMake(kExportButtonWidth, kExportButtonHeight));
//    }];
    
    [self updateContraints];
}
#pragma mark 更新约束
- (void)updateContraints{
    if (self.chartView.bottomContraints) {
        [self.chartView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.top.equalTo(self.scorllView);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.chartView.bottomContraints);
        }];
    }
    if (self.formSourceModel && self.formSourceModel.sourceArray.count > 0) {
        [self.formView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.top.mas_equalTo(self.chartView.mas_bottom).offset(10);
            make.height.mas_equalTo([TTMStatisticsFormView formViewHeightWithArray:self.formSourceModel.sourceArray[0] showHeader:self.showFormViewHeader]);
        }];
        
        [self.scorllView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(55, 0, 0, 0));
            make.bottom.mas_equalTo(self.formView.mas_bottom).offset(10);
        }];
        
    }else{
        [self.scorllView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(55, 0, 0, 0));
        }];
    }
}

- (void)setFormSourceModel:(TTMStatisticsFormSourceModel *)formSourceModel{
    _formSourceModel = formSourceModel;
    
    [self.chartView reloadData];
    [self updateContraints];
    self.formView.sourceModel = formSourceModel;
}

#pragma mark - ********************* Delegate / DataSource ********************
#pragma mark - TTMStatisticsChartViewDataSource
- (TTMStatisticsChartModel *)chartViewSourceArrayForChart:(TTMStatisticsChartView *)chartView{
    return nil;
}

#pragma mark - ********************* Lazy Method ***********************
#pragma mark 日期标签视图
- (TTMStatisticsDateTagView *)tagView{
    if (!_tagView) {
        __weak typeof(self) weakSelf = self;
        _tagView = [[TTMStatisticsDateTagView alloc] init];
        _tagView.dateSelectBlock = ^(NSString *startTime,NSString *endTime){
            [weakSelf selectDateWithStartTime:startTime endTime:endTime];
        };
    }
    return _tagView;
}

#pragma mark 日期选择方法
- (void)selectDateWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
}

#pragma mark 导出按钮
- (UIButton *)exportButton{
    if (!_exportButton) {
        _exportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exportButton setTitle:@"导出" forState:UIControlStateNormal];
        [_exportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _exportButton.titleLabel.font = [UIFont systemFontOfSize:10];
        _exportButton.frame = CGRectMake(0, 0, kExportButtonWidth, kExportButtonHeight);
        _exportButton.backgroundColor = MainColor;
        _exportButton.layer.cornerRadius = kExportButtonWidth / 2;
        _exportButton.layer.masksToBounds = YES;
        [_exportButton addTarget:self action:@selector(exportButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exportButton;
}

#pragma mark 导出
- (void)exportButtonAction{
}

#pragma mark 图表视图
- (TTMStatisticsChartView *)chartView{
    if (!_chartView) {
        _chartView = [[TTMStatisticsChartView alloc] initWithFrame:CGRectZero dataSource:self style:self.style];
    }
    return _chartView;
}

#pragma mark 表格视图
- (TTMStatisticsFormView *)formView{
    if (!_formView) {
        _formView = [[TTMStatisticsFormView alloc] initWithFrame:CGRectZero showHeader:self.showFormViewHeader];
    }
    return _formView;
}

#pragma mark - ScrollView
- (UIScrollView *)scorllView{
    if (!_scorllView) {
        _scorllView = [[UIScrollView alloc] init];
        _scorllView.showsVerticalScrollIndicator = YES;
        _scorllView.bounces = NO;
    }
    return _scorllView;
}

@end
