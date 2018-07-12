//
//  CCityOfficalFileViewerVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/14.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalFileViewerVC.h"
#import "CCityBackToLeftView.h"

@interface CCityOfficalFileViewerVC ()

@end

@implementation CCityOfficalFileViewerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // backToLeft
    CCityBackToLeftView* backArrow = [CCityBackToLeftView new];
    UIControl* backCon = [UIControl new];
    backCon.frame = CGRectMake(0, 0, 60.f, 44.f);
    [backCon addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [backCon addSubview:backArrow];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc]initWithCustomView:backCon];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void) popAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
