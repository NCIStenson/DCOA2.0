//
//  CCityAlterManager.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/3.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCityAlterManager : NSObject

+(void)showSimpleTripsWithVC:(UIViewController*)viewController Str:(NSString*)title handle:(void (^)(UIAlertAction *action))handler;

+(void)showSimpleTripsWithVC:(UIViewController*)viewController Str:(NSString*)title detail:(NSString*)message;

@end
