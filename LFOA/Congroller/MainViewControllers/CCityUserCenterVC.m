//
//  CCityUserCenterVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/29.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_USERCRNTER_BGCOLOR CCITY_RGB_COLOR(244, 245, 250, 1)
#define CCITY_USERCRNTER_PADDING 3.f;

#import "CCityUserCenterVC.h"
#import "CCityUserCenterCell.h"
#import "CCityJSONNetWorkManager.h"
#import "CCityUserInfoVC.h"

#import "CCitySecurity.h"
#import "CCitySingleton.h"
#import "CCityChangePassWorldVC.h"
#import "CCityUserReportVC.h"

@interface CCityUserCenterVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CCityUserCenterVC {
    
    UITableView* _tableView;
    UILabel*     _nameLabel;
    UILabel* _positionlabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = CCITY_USERCRNTER_BGCOLOR;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self layoutMySubViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self upDatas];
}

#pragma mark- --- layoutSubViews 

-(void)layoutMySubViews {
    
    _tableView = [[UITableView alloc]init];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = CCITY_USERCRNTER_BGCOLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 44.f;
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame = CGRectMake(0, 3.f, tableViewFrame.size.width, tableViewFrame.size.height - 3.f - 50.f - 64 - 50.f);
    _tableView.frame = tableViewFrame;
    
    UIControl* tableHeaderView = [self tableHeaderView];
    [tableHeaderView addTarget:self action:@selector(headViewAction) forControlEvents:UIControlEventTouchUpInside];
    tableHeaderView.frame = CGRectMake(0, 0, _tableView.bounds.size.width, 80.f);
    
    _tableView.tableHeaderView =tableHeaderView;
    
    UIView* logoutView = [self logoutView];
    
    [self.view addSubview:logoutView];
    [self.view addSubview:_tableView];
    
    [logoutView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_tableView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@50.f);
    }];
}

- (UIView*)logoutView {
    
    UIView* logoutView = [UIView new];
    
    UIButton* logoutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [logoutBtn setTitle:@"退   出" forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    logoutBtn.layer.cornerRadius = 5.f;
    logoutBtn.clipsToBounds = YES;
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [logoutBtn setBackgroundColor:CCITY_MAIN_COLOR];
    
    [logoutView addSubview:logoutBtn];
    
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(logoutView).with.offset(5.f);
        make.left.equalTo(logoutView).with.offset(10.f);
        make.bottom.equalTo(logoutView).with.offset(-5.f);
        make.right.equalTo(logoutView).with.offset(-10.f);
    }];
    
    return logoutView;
}

// header View
-(UIControl*)tableHeaderView {
    
    UIControl* headerView = [UIControl new];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIButton* headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBtn setImage:[UIImage imageNamed:@"ccity_uesrcenter_userHeader"] forState:UIControlStateNormal];
    headerBtn.layer.cornerRadius = 25.f;
    
    headerBtn.clipsToBounds = YES;
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.font = [UIFont systemFontOfSize:15.f];
    _nameLabel.textColor = CCITY_MAIN_FONT_COLOR;
    
    if ([CCitySingleton sharedInstance].userName) {
        
        _nameLabel.text = [CCitySingleton sharedInstance].userName;
    } else {
        
        _nameLabel.text = @"姓名";
    }
    
    _positionlabel = [UILabel new];
    _positionlabel.textColor = [UIColor grayColor];
    _positionlabel.font = [UIFont systemFontOfSize:13.f];
    _positionlabel.text = @"职位";
    
    UIImageView* cerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_userCenter_cer_44x44_"]];
    [headerView addSubview:headerBtn];
    [headerView addSubview:_nameLabel];
    [headerView addSubview:_positionlabel];
    [headerView addSubview:cerImageView];
    
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(headerView).with.offset(15.f);
        make.left.equalTo(headerView).with.offset(20.f);
        make.bottom.equalTo(headerView).with.offset(-15.f);
        make.width.equalTo(headerBtn.mas_height);
    }];
    
    [cerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(headerView).with.offset(20.f);
        make.right.equalTo(headerView).with.offset(-31.f);
        make.height.mas_equalTo(25.f);
        make.width.mas_equalTo(25.f);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(headerView).with.offset(20.f);
        make.left.equalTo(headerBtn.mas_right).with.offset(5.f);
        make.right.equalTo(cerImageView).with.offset(-5.f);
        make.height.equalTo(_positionlabel);
    }];
    
    [_positionlabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(headerView).with.offset(-20.f);
        make.left.equalTo(_nameLabel);
        make.right.equalTo(_nameLabel);
        make.height.equalTo(_nameLabel);
    }];
    
    return headerView;
}

#pragma mark- --- methods

-(void)headViewAction {
    
    CCityUserInfoVC* userInfo = [[CCityUserInfoVC alloc]init];
    userInfo.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userInfo animated:YES];
}

- (void)upDatas {
    
    if (![_nameLabel.text isEqualToString:[CCitySingleton sharedInstance].userName]) {
        
        _nameLabel.text = [CCitySingleton sharedInstance].userName;
    }
    
    if (![_positionlabel.text isEqualToString: [CCitySingleton sharedInstance].deptname]) {
        
        _positionlabel.text = [CCitySingleton sharedInstance].deptname;
    }
}

- (void)logOut {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    [manager POST:@"service/Logout.ashx" parameters:@{@"token":[CCitySecurity getSession]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"--登出-成功：%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"--登出-请求失败：%@", error.description);
    }];
    
    [CCitySecurity saveSessionWith:@"logout"];
    [CCitySingleton sharedInstance].isLogIn = NO;
    [[CCitySingleton sharedInstance] showLogInVCWithPresentedVC:self];
}

-(void)changePassWord {
    
    CCityChangePassWorldVC* changePassWorldVC = [[CCityChangePassWorldVC alloc]init];
    changePassWorldVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changePassWorldVC animated:YES];
}

-(void)userReport {
    
    CCityUserReportVC* userReportVC = [CCityUserReportVC new];
    userReportVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userReportVC animated:YES];
}

#pragma mark- --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityUserCenterCell* cell;
    
    switch (indexPath.row) {
            
        case 0:
            
             cell = [[CCityUserCenterCell alloc]initWithImageName:@"ccity_userCenter_lock" title:@"修改密码" showArrow:YES];
            break;
        case 1:
            
              cell = [[CCityUserCenterCell alloc]initWithImageName:@"ccity_userCenter_setting_50x50_" title:@"用户反馈" showArrow:YES];
            break;

        default:
            break;
    }
    
    cell.backgroundColor = CCITY_USERCRNTER_BGCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0:         // 修改密码
            
            [self changePassWord];
            break;
        case 1:         // 用户反馈
            
            [self userReport];
            break;
        case 2:         // 注销
            
            break;
        case 3:
            
            break;
        default:
            break;
    }
}

@end