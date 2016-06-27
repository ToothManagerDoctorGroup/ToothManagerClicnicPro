//
//  AppDelegate.m
//  ToothManager
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "TTMTabBarController.h"
#import "TTMUserGuideController.h"
#import "NSUserDefaults+TTMAddtion.h"
#import "TTMLoginController.h"
#import "TTMNavigationController.h"
#import "UMFeedback.h"
#import "UMessage.h"
#import "JPUSHService.h"
#import "TTMRemoteNotificationManager.h"

#define kUMengAppKey @"5594d14b67e58e3ef9003aad"
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

static NSString *jPushAppKey = @"69a247d9b1b15f5553a94e84";
static NSString *jPushChannel = @"App Store";
static BOOL isProduction = FALSE;


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    application.statusBarHidden = NO;
    
    __weak __typeof(&*self)weakSelf = self;
    [NSUserDefaults launchControllerWithMainControllerBlock:^{ // 主要操作
        TTMUser *user = [TTMUser unArchiveUser];
        if (user.username && user.password) {
            weakSelf.window.rootViewController = [[TTMTabBarController alloc] init];
        } else {
            TTMLoginController *loginVC = [[TTMLoginController alloc] init];
            TTMNavigationController *nav = [[TTMNavigationController alloc] initWithRootViewController:loginVC];
            weakSelf.window.rootViewController = nav;
        }
    } launchControllerBlock:^{
        TTMUserGuideController *guideController = [[TTMUserGuideController alloc] init];
        guideController.images = @[@"guide_lead1", @"guide_lead2", @"guide_lead3"];
        guideController.showIndicator = YES;
        
        TTMLoginController *loginVC = [[TTMLoginController alloc] init];
        TTMNavigationController *nav = [[TTMNavigationController alloc] initWithRootViewController:loginVC];
        // 过后的第一个页面
        guideController.forwardController = nav;
        weakSelf.window.rootViewController = guideController;
    } isShowNewFeatures:YES];
    
    [self.window makeKeyAndVisible];
    [self setupKeyBoardManager];

#ifdef __IPHONE_8_0
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                         |UIRemoteNotificationTypeSound
                                                                                         |UIRemoteNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#else
    //register to receive notifications
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    
    [UMFeedback setAppkey:kUMengAppKey];
//    [UMessage startWithAppkey:kUMengAppKey launchOptions:launchOptions];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:jPushAppKey
                          channel:jPushChannel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    [self setupUMessage];
    return YES;
}

- (void)setupKeyBoardManager {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
}

- (void)setupUMessage {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
//        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
//        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//         |UIRemoteNotificationTypeSound
//         |UIRemoteNotificationTypeAlert];
        
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    }
#else
    //register remoteNotification types (iOS 8.0以下)
//     [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
//     |UIRemoteNotificationTypeSound
//     |UIRemoteNotificationTypeAlert];
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil];
    
#endif
    //for log
//    [UMessage setLogEnabled:YES];
}

#ifdef __IPHONE_8_0
//ios8需要调用内容
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]) {
    }
    else if ([identifier isEqualToString:@"answerAction"]) {
    }
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    if (deviceToken) { // 缓存deviceToken
        NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                           stringByReplacingOccurrencesOfString: @" " withString: @""];
        //将registrationID保存到本地
        if ([JPUSHService registrationID] && [JPUSHService registrationID].length > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:[JPUSHService registrationID] forKey:@"deviceToken"];
        }
//        [UMessage registerDeviceToken:deviceToken];
        
        TTMLog(@"registerId:%@",[JPUSHService registrationID]);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
//    [UMessage didReceiveRemoteNotification:userInfo];
     [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        [[TTMRemoteNotificationManager shareInstance] didReceiveRemoteNotification:userInfo];
    }else{
        //跳转到消息页面
        
    }
    
    // IOS 7 Support Required
    [UIApplication sharedApplication].applicationIconBadgeNumber  =  0;
//    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

@end
