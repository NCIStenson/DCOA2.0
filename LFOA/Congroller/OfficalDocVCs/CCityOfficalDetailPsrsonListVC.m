//
//  CCityOfficalDetailPsrsonListVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/12.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDetailPsrsonListVC.h"
#import "CCityOfficalDetailPersonListCell.h"
#import "CCityOffialSendPersonListModel.h"
#import "CCityJSONNetWorkManager.h"
#import "CCityAlterManager.h"
#import "CCitySystemVersionManager.h"

@interface CCityOfficalDetailPsrsonListVC ()<UITableViewDelegate,UITableViewDataSource>

@end

static NSString* ccityOfficalDeitalPersonListCellReuseId = @"ccityOfficalDeitalPersonListCellReuseId";

@implementation CCityOfficalDetailPsrsonListVC {
    
    NSMutableDictionary* _ids;
    NSArray*            _dataArr;
    UITableView*        _tableView;
    NSMutableArray*     _selectedArr;
    NSString*           _fkNode;
    NSInteger           _selectedSection;
    CALayer*            _lineLayer;
}

- (instancetype)initWithIds:(NSDictionary*)ids
{
    self = [super init];
    
    if (self) {
        
        _ids = [ids mutableCopy];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = CCITY_MAIN_BGCOLOR;
    self.title = @"发送给";
    
    _selectedArr = [NSMutableArray array];
    
    _lineLayer = [CALayer new];
    _lineLayer.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.5f].CGColor;
    _lineLayer.frame = CGRectMake(0, 44.f, self.view.bounds.size.width, .5f);
    [self.navigationController.navigationBar.layer addSublayer:_lineLayer];
    [self layoutMySubViews];
    [self configData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_lineLayer removeFromSuperlayer];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark- --- layoutMySubViews
-(void)layoutMySubViews {
    
    UIView* footView = [self footerView];
    UIButton* sendBtn = [self sendBtn];
    _tableView = [self tableView];
    _tableView.rowHeight = 44.f;
    [self.view addSubview:_tableView];
    [footView addSubview:sendBtn];
    [self.view addSubview:footView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(footView).with.offset(5.f);
        make.left.equalTo(footView).with.offset(10.f);
        make.bottom.equalTo(footView).with.offset(-5.f);
        make.right.equalTo(footView).with.offset(-10.f);
    }];
    
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view);
        
        if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {

            make.bottom.equalTo(self.view).with.offset(-20.f);
        } else {

            make.bottom.equalTo(self.view);
        }
        
        make.right.equalTo(self.view);
        make.height.mas_equalTo(@50.f);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(footView.mas_top);
    }];
    
}

-(UITableView*)tableView {
    
    UITableView* tableView = [UITableView new];
    [tableView registerClass:[CCityOfficalDetailPersonListCell class] forCellReuseIdentifier:ccityOfficalDeitalPersonListCellReuseId];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.sectionHeaderHeight = 44.f;
    tableView.backgroundColor = CCITY_MAIN_BGCOLOR;
    return tableView;
}

// footerView
-(UIView*)footerView {
    
    UIView* footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

// sendBtn
-(UIButton*)sendBtn {
    
    UIButton* sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [sendBtn setTitle:@"提 交" forState:UIControlStateNormal];
    sendBtn.backgroundColor = CCITY_MAIN_COLOR;
    sendBtn.clipsToBounds = YES;
    sendBtn.layer.cornerRadius = 5.f;
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    
    return sendBtn;
}

#pragma mark- --- netWork

- (void) sendAction {
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSString* userIdsStr = @"";
    
    for (int i = 0; i < _selectedArr.count; i++) {
        
        userIdsStr = [userIdsStr stringByAppendingString:_selectedArr[i]];
        
        if (i != _selectedArr.count -1) {
            
            userIdsStr = [userIdsStr stringByAppendingString:@","];
        }
    }
    
    NSMutableDictionary* parameters = [@{@"toNode"   :_fkNode,
                                         @"token"    :[CCitySingleton sharedInstance].token,
                                         @"usernames":userIdsStr,
                                 } mutableCopy];
    
    [parameters addEntriesFromDictionary:_ids];
    
    [manager POST:@"service/form/Send.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            [self sendSuccess];
        } else {
            
            [CCityAlterManager showSimpleTripsWithVC:self Str:@"发送失败" detail:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
    }];
    
}

- (void)configData {
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    for (NSString* key in _ids.allKeys) {
        
        if ([key isEqualToString:@"fk_flow"]) {
            
            [_ids setObject:_ids[@"fk_flow"] forKey:@"fkFlow"];
            [_ids removeObjectForKey:@"fk_flow"];
        }
    }
    
    [manager GET:@"service/form/GetAccepter.ashx" parameters:_ids progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSArray* datasArr = responseObject;
        NSMutableArray* muDataArr = [NSMutableArray arrayWithCapacity:datasArr.count];
        
        for (int i = 0 ; i < datasArr.count; i++) {
            
            CCityOffialSendPersonListModel* model = [[CCityOffialSendPersonListModel alloc]initWithDic:datasArr[i]];
            [muDataArr addObject:model];
        }
        
        _dataArr = [muDataArr mutableCopy];
        [_tableView reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        
        if (CCITY_DEBUG) {
            
            NSLog(@"%@",task.currentRequest.URL.absoluteString);
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark- --- metods

- (void) dismissAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendSuccess {
    
    if ([self.delegate respondsToSelector:@selector(viewControllerDismissActoin)]) {
        
        [self.delegate viewControllerDismissActoin];
    }
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)headerSectionAction:(UIControl*)headerSction {
    
    NSInteger section = headerSction.tag - 4000;
    CCityOffialSendPersonListModel* model = _dataArr[section];
    model.isOpen = !model.isOpen;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark- --- UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44.f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIControl* sectionHeader = [UIControl new];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    sectionHeader.tag = 4000 + section;
    [sectionHeader addTarget:self action:@selector(headerSectionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CCityOffialSendPersonListModel* model = _dataArr[section];
    
    UIImageView* headerImageView = [[UIImageView alloc]init];
    headerImageView.image = [UIImage imageNamed:@"ccity_offical_sendDoc_node_50x50_"];
    
    UILabel* sectionNodeLabel = [UILabel new];
    sectionNodeLabel.textColor = CCITY_MAIN_FONT_COLOR;
    sectionNodeLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    sectionNodeLabel.text = model.groupTitle;
    
    [sectionHeader addSubview:headerImageView];
    [sectionHeader addSubview:sectionNodeLabel];
    
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(sectionHeader).with.offset(11.5f);
        make.left.equalTo(sectionHeader).with.offset(10.f);
        make.bottom.equalTo(sectionHeader).with.offset(-11.5f);
        make.width.equalTo(headerImageView.mas_height);
    }];
    
    [sectionNodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(headerImageView);
        make.left.equalTo(headerImageView.mas_right).with.offset(10.f);
        make.bottom.equalTo(headerImageView);
        make.right.equalTo(sectionHeader);
    }];
    
    return sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    CCityOffialSendPersonListModel* model = _dataArr[section];

    if (model.isOpen == NO) {   return 0;   }
    
    return model.groupItmes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOffialSendPersonListModel* model = _dataArr[indexPath.section];
    
    if (!_dataArr.count) {
        
        UITableViewCell* cell = [UITableViewCell new];
        cell.textLabel.text = @"无数据";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    CCityOfficalDetailPersonListCell* cell = [tableView dequeueReusableCellWithIdentifier:ccityOfficalDeitalPersonListCellReuseId];
    
    while ([cell.contentView.subviews lastObject]) {
        
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    CCityOfficalSendPersonDetailModel* cellModel = model.groupItmes[indexPath.row];
    
    cell.model = cellModel;
    return cell;
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOfficalDetailPersonListCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    CCityOffialSendPersonListModel* model = _dataArr[indexPath.section];
    CCityOfficalSendPersonDetailModel* cellModel = model.groupItmes[indexPath.row];
    
    cellModel.isSelected = !cellModel.isSelected;
    
    [cell.checkBox setOn:cellModel.isSelected animated:NO];
    [cell.checkBox reload];
    
    if (!_fkNode) {
        
        if (cellModel.isSelected) {
            
            [_selectedArr addObject:cellModel.personId];
        }
        _fkNode = model.fkNode;
    } else {
        
        if ([_fkNode isEqualToString:model.fkNode]) {
            
            if (cellModel.isSelected) {
                [_selectedArr addObject:cellModel.personId];
            } else {
                [_selectedArr removeObject:cellModel.personId];
            }
        } else {
            
            NSMutableArray* indextPathArr = [NSMutableArray new];
            
            CCityOffialSendPersonListModel* selectedModel = _dataArr[_selectedSection];
            for (int i = 0; i < selectedModel.groupItmes.count; i++) {
                
                CCityOfficalSendPersonDetailModel* oldDetailModel = selectedModel.groupItmes[i];
                if (oldDetailModel.isSelected) {
                    
                     [indextPathArr addObject:[NSIndexPath indexPathForRow:i inSection:_selectedSection]];
                    oldDetailModel.isSelected = NO;
                }
            }
            
            [_tableView reloadRowsAtIndexPaths:indextPathArr withRowAnimation:UITableViewRowAnimationNone];
            
            [_selectedArr removeAllObjects];
            [_selectedArr addObject:cellModel.personId];
            _fkNode = model.fkNode;
        }
    }
    _selectedSection = indexPath.section;
}

@end
