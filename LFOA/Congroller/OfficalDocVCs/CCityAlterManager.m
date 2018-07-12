
//
//  CCityAlterManager.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/3.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityAlterManager.h"

@implementation CCityAlterManager

+ (void) showSimpleTripsWithVC:(UIViewController*)viewController Str:(NSString*)title handle:(void (^)(UIAlertAction *action))handler {
    
    UIAlertController* alterController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler];
    
    [alterController addAction:okAction];
    
    if (!viewController) {
        
        viewController = [[CCitySingleton sharedInstance] getCurrentVisibleVC];
    }
    
    [viewController presentViewController:alterController animated:YES completion:nil];
}

+(void)showSimpleTripsWithVC:(UIViewController*)viewController Str:(NSString*)title detail:(NSString*)message {
    
    UIAlertController* alterController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    
    [alterController addAction:okAction];
    
    if (!viewController) {
        
        viewController = [[CCitySingleton sharedInstance] getCurrentVisibleVC];
    }
    
    [viewController presentViewController:alterController animated:YES completion:nil];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        if (alterController) {
//            [alterController dismissViewControllerAnimated:YES completion:nil];
//        }
//    });
}

@end
