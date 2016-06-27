//
//  THCTabBarViewController.m
//  THCFramework
//

#import "TTMTabBarController.h"
#import "TTMTabBar.h"
#import "TTMTabBarItemModel.h"
#import "TTMNavigationController.h"
#import "TTMChairUsageRateController.h"
#import "TTMOrderQuantityController.h"
#import "TTMOrderItemRatioController.h"
#import "TTMIncomeStatisticsController.h"
#import "TTMOrderIncrementController.h"
#import <WMPageController/WMPageController.h>

@interface TTMTabBarController () <TTMTabBarDelegate>

@property (nonatomic, weak) TTMTabBar *thcTabBar;
@property (nonatomic, strong) NSArray *tabBarDatas;

@end

@implementation TTMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 先添加TabBar
    [self setupTabBar];

    // 再添加controller
    [self setupChildControllers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:[UIControl class]]) {
            [view removeFromSuperview];
        }
    }
}

- (NSArray *)tabBarDatas {
    if (!_tabBarDatas) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TabBarDatas.plist" ofType:nil];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            TTMTabBarItemModel *tabBarItemModel = [TTMTabBarItemModel tabBarItemModelWithDic:dic];
            [tempArray addObject:tabBarItemModel];
        }
        _tabBarDatas = [tempArray copy];
    }
    return _tabBarDatas;
}

/**
 *  添加TabBar
 */
- (void)setupTabBar {
    TTMTabBar *thcTabBar = [[TTMTabBar alloc] init];
    thcTabBar.frame = self.tabBar.bounds;
    thcTabBar.delegate = self;
    [self.tabBar addSubview:thcTabBar];
    self.thcTabBar = thcTabBar;
}

/**
 *  添加ChildController
 */
- (void)setupChildControllers {
    for (TTMTabBarItemModel *tabBarItemModel in self.tabBarDatas) {
        [self addChildViewControllerWithTabBarItemModel:tabBarItemModel];
    }
}

- (void)addChildViewControllerWithTabBarItemModel:(TTMTabBarItemModel *)tabBarItemModel {
    UIViewController *controller = nil;
    if ([tabBarItemModel.tabBarController isEqualToString:@"WMPageController"]) {
        controller = [self p_defaultController];
    }else{
        controller = [[NSClassFromString(tabBarItemModel.tabBarController) alloc] init];
    }
    controller.title = tabBarItemModel.tabBarTitle;
    controller.tabBarItem.image = [UIImage imageNamed:tabBarItemModel.tabBarImageName];
    controller.tabBarItem.selectedImage = [UIImage imageNamed:tabBarItemModel.tabBarSelectedImageName];
    
    TTMNavigationController *navigationController = [[TTMNavigationController alloc]
                                                     initWithRootViewController:controller];
    [self addChildViewController:navigationController];

    [self.thcTabBar addButtonWithTabBarItem:controller.tabBarItem];
}

#pragma mark - THCTabBarDelegate
- (void)tabBar:(TTMTabBar *)tabBar fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    self.selectedIndex = toIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 创建统计视图控制器
//创建控制器
- (WMPageController *)p_defaultController {
    NSArray *viewControllers = @[[TTMChairUsageRateController class],[TTMOrderQuantityController class],[TTMOrderItemRatioController class],[TTMIncomeStatisticsController class],[TTMOrderIncrementController class]];
    NSArray *titles = @[@"椅位使用率",@"诊所预约量",@"预约事项占比",@"收入统计",@"预约增量"];
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.pageAnimatable = NO;
    pageVC.menuItemWidth = (ScreenWidth - 40) / 3;
    pageVC.postNotification = YES;
    pageVC.bounces = NO;
    pageVC.menuViewStyle = WMMenuViewStyleLine;
    pageVC.menuBGColor = [UIColor whiteColor];
    pageVC.titleSizeSelected = 14;
    pageVC.titleSizeNormal = 14;
    pageVC.titleColorSelected = MainColor;
    pageVC.menuHeight = 44;
    pageVC.cachePolicy = WMPageControllerPreloadPolicyNeighbour;
    return pageVC;
}

@end
