//
//  CCityAMapVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/11/9.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityAMapVC.h"

@interface CCityAMapVC ()

@end

@implementation CCityAMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeDeviceOrientaiontTo:UIInterfaceOrientationLandscapeRight];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
     [self changeDeviceOrientaiontTo:UIInterfaceOrientationPortrait];
}

#pragma mark- --- method

-(void)changeDeviceOrientaiontTo:(UIInterfaceOrientation)orientation {
    
    NSArray * selectorNameCharacterArray = @[@"s",@"e",@"t",@"O",@"r",@"i",@"e",@"n",@"t",@"a",@"t",@"i",@"o",@"n",@":"];
    NSString * selectorName = [selectorNameCharacterArray componentsJoinedByString:@""];
    SEL selector = NSSelectorFromString(selectorName);
    if ([[UIDevice currentDevice] respondsToSelector:selector]) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end
