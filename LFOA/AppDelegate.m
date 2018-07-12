//
//  AppDelegate.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/28.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define kGtAppId      @"bFwIukIMie65qvpfCD8Qo"
#define kGtAppKey     @"duMe8z3InC6jB7BJkhmvY1"
#define kGtAppSecret  @"Xa3S5XNy1LAjSj0aakgGm"

#import "AppDelegate.h"
#import "CCityRootViewController.h"
#import "CCityBaseNavController.h"
#import "CCityTabBarController.h"

#import "CCitySecurity.h"
#import "CCitySingleton.h"
#import "CCityJSONNetWorkManager.h"
#import "CCityNoficManager.h"
#import <TSMessage.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [self setNavBar];
    
    //若由远程通知启动
//    NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    /*
    if ([CCitySecurity isAutoLogin]) {
        
        if ([CCitySecurity getSession]) {   [self autoLogInWithNotfic:remoteNotification];   }
    } else {
        
        CCityLogInVC* logInVC = [[CCityLogInVC alloc] init];
        logInVC.notificDic = remoteNotification;
        self.window.rootViewController = logInVC;
    }
    */
//    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
//    [self registerRemoteNotfication];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterGeTuiClientId) name:CCITY_SET_TOKEN_KEY object:nil];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        if (![CCitySecurity IsShowNotific]) {
//
//            [CCitySecurity setIsShowNotific:@"YES"];
//        }
//    });
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
   // 验证token 可用性
    if ([CCitySingleton sharedInstance].isLogIn) {
        
        AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
        
        [manager POST:@"service/Login.ashx" parameters:@{@"token":[CCitySecurity getSession], @"iOS":@"true"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if ([responseObject[@"status"] isEqualToString:@"failed"]) {
                
                [CCitySingleton sharedInstance].isLogIn = NO;
                UIViewController* currentVC = [[CCitySingleton sharedInstance] getCurrentVisibleVC];
                
                if ([currentVC isKindOfClass:[CCityLogInVC class]]) {
                    
                    return;
                } else {
                    
                    [CCityAlterManager showSimpleTripsWithVC:currentVC Str:@"登陆过期，请重新登陆" handle:^(UIAlertAction *action) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                           
                            [[CCitySingleton sharedInstance] showLogInVCWithPresentedVC:currentVC];
                        });
                    }];
                }
            } else {
                
                if (responseObject[@"tokenstr"] == [NSNull null]) { return; }
                
                [CCitySingleton sharedInstance].token = responseObject[@"tokenstr"];
                [CCitySecurity saveSessionWith:responseObject[@"tokenstr"]];
            }
            
            if (CCITY_DEBUG) {
                //NSLog(@"%@",responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
            if (error) {    NSLog(@"%@",error); }
        }];
    }
}

#pragma mark- --- notfics

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {
    
    if (CCITY_DEBUG) {
        
        NSLog(@"register notfic failed : %@",error);
    }
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString* token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (CCITY_DEBUG) {
        
        NSLog(@"\n>>>[DeviceToken Success]:%@\n\n",token);
    }
    
    [GeTuiSdk registerDeviceToken:token];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    if (CCITY_DEBUG) {
        
        NSLog(@"\n\n -- inActive:%ld", (long)application.applicationState);
    }

    if (application.applicationState == UIApplicationStateInactive) {
        
        [CCityNoficManager reciveNotficWithDic:userInfo];
    }

    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark- --- GeTui delegate
-(void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    
    //个推SDK已注册，返回clientId
    if (CCITY_DEBUG) {
        
        NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    }
    
    if ([CCitySingleton sharedInstance].isLogIn) {
        
        [self RegisterGeTuiClientId];
    }
}

/** SDK收到透传消息回调 */
/*
-(void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    
    //收到个推消息
    NSString* payloadMsg = nil;
    
    if (payloadData) {
        
        payloadMsg = [[NSString alloc]initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg :%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}
*/

#pragma mark- --- methods

- (void)RegisterGeTuiClientId {
    
    if (![GeTuiSdk clientId]) { return; }
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    [manager GET:@"service/message/push/BindUserDevice.ashx" parameters:@{@"token":[CCitySingleton sharedInstance].token, @"clientId":[GeTuiSdk clientId], @"iOS":@"true"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (CCITY_DEBUG) {  NSLog(@"%@", responseObject);   }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
}

-(void)registerRemoteNotfication {
    
    if(CCITY_SYSTEM_VERSION >= 10.0) {
        
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (!error) {
                
                NSLog(@"reuqest authorization succeeded");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings* seetings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:seetings];
    }
}

//  autoLogIn
- (void)autoLogInWithNotfic:(NSDictionary*)notificDic {
    
    [SVProgressHUD showWithStatus:@"登陆验证中..."];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        
        dispatch_group_enter(group);
        
        [manager POST:@"service/Login.ashx" parameters:@{@"token":[CCitySecurity getSession], @"iOS":@"true"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [SVProgressHUD dismiss];
            
            if ([responseObject[@"status"] isEqualToString:@"success"]) {
                
                [CCitySecurity saveSessionWith:responseObject[@"tokenstr"]];
                [CCitySingleton sharedInstance].token = responseObject[@"tokenstr"];
                [CCitySingleton sharedInstance].userName = [CCitySecurity userName];
                [CCitySingleton sharedInstance].deptname = responseObject[@"deptname"];
                [CCitySingleton sharedInstance].occupation = responseObject[@"occupation"];
                [CCitySingleton sharedInstance].organization = responseObject[@"organization"];
                [CCitySingleton sharedInstance].phoneNum = responseObject[@"mobilePhone"];
                
                if (![[CCitySecurity deptName] isEqualToString:responseObject[@"deptName"]]) {
                    
                    [CCitySecurity setDeptName:@"deptName"];
                }
                
                if (responseObject[@"privilege"] != [NSNull null]) {
                    [CCitySingleton sharedInstance].jurisdictionArr = responseObject[@"privilege"];
                }
                [CCitySingleton sharedInstance].isLogIn = YES;
            }
            
            if (CCITY_DEBUG) {  NSLog(@"%@--%@", [CCitySecurity getSession],responseObject);    }
            
            dispatch_group_leave(group);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD dismiss];
            NSLog(@"%@",error.description);
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if ([CCitySingleton sharedInstance].isLogIn) {
            
            CCityTabBarController* tabBarVC = [[CCityTabBarController alloc] init];
            tabBarVC.notificDic = notificDic;
            self.window.rootViewController = tabBarVC;
        } else {
            
            CCityLogInVC* logInVC = [CCityLogInVC new];
            logInVC.notificDic = notificDic;
            self.window.rootViewController = [CCityLogInVC new];
        }
    });
}

- (void)setNavBar {

    [UINavigationBar appearance].tintColor = CCITY_MAIN_COLOR;
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].backgroundColor = [UIColor whiteColor];
    [UINavigationBar appearance].shadowImage = [UIImage new];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [UINavigationBar appearance].barTintColor = [UIColor whiteColor];
}

@end
