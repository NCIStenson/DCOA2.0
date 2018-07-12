//
//  CCityMainTaskSearchVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

typedef NS_ENUM(NSUInteger, CurrentContentModel) {
    
    CCityCurrentContentHistoryModel,
    CCityCurrentContentOpinioModel,
};

#define CCITY_MAIN_SEARCH_TASK_CACHE_FILE_NAME @"mainTaskSearchHistory"

#import "CCityMainTaskSearchVC.h"
#import "CCityNoDataCell.h"
#import "CCityMainTaskDetailSearchVC.h"
#import "CCityFileManager.h"
#import "CCityMainTaskSearchCell.h"
#import "CCityMainTaskSearchResultVC.h"
#import "CCityMainSearchTaskModel.h"
#import "CCityMainTasekSearchResultCell.h"
#import "CCityOfficalDocDetailVC.h"

@interface CCityMainTaskSearchVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@end

static NSString* ccityMainTaskSerachCellReuseId = @"ccityMainTaskSerachCellReuseId";
static NSString* ccityMainTaskSerachResultCellReuseId = @"ccityMainTaskSerachResultCellReuseId";

@implementation CCityMainTaskSearchVC {
    
    UISearchBar*    _searchBar;
    NSMutableArray* _historyArr;
    NSMutableArray* _datasArr;
    UITableView*    _tableView;
    CurrentContentModel _contentModel;
    NSInteger       _pageIndex;
    NSMutableDictionary* _parameters;
    NSString*      _detailSearchUrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _pageIndex = 1;
    _contentModel = CCityCurrentContentOpinioModel;
    _datasArr = [NSMutableArray array];
    
    if (self.searchStyle == CCityHomeCellTaskSearchStyle) {
        self.title = @"综合查询";
         _url = @"service/search/OrganizationSearch.ashx";
        _detailSearchUrl = @"service/search/AdvancedOrganizationSearch.ashx";
    } else if (self.searchStyle == CCityHomeCellOfficeSearchStyle) {
        self.title = @"本局查询";
         _url = @"service/search/DepartmentSearch.ashx";
        _detailSearchUrl = @"service/search/AdvancedDepartmentSearch.ashx";
    } else {
        self.title = @"本人查询";
          _url = @"service/search/UserSelfSearch.ashx";
        _detailSearchUrl = @"service/search/AdvancedUserSelfSearch.ashx";
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar.layer addSublayer:[self line]];

    _parameters = [@{
                     @"token"    :[CCitySingleton sharedInstance].token,
                     @"value"    :@"",
                     @"pageSize" :@20,
                     @"pageIndex":@1
                     } mutableCopy];
    
    [self layoutMySubViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self configData];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self writeData];
}

#pragma mark- --- layout

-(void)layoutMySubViews {
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [self rightBarBtn];
    
    _tableView = [self tableView];
    
    UISearchBar* searchBar = [self searchBar];
    
    [self.view addSubview:_tableView];
    [self.view addSubview:searchBar];
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(44.f);
    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(44.f, 0, 0, 0));
    }];
}

-(CAShapeLayer*)line {
    
    CAShapeLayer* line = [CAShapeLayer layer];
    line.backgroundColor = [UIColor lightGrayColor].CGColor;
    line.frame = CGRectMake(0, 44, self.view.bounds.size.width, .5f);
    return line;
}

// rightBarBtn
-(UIBarButtonItem*)rightBarBtn {
    
    UIBarButtonItem* rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"高级搜索" style:UIBarButtonItemStylePlain target:self action:@selector(detailSearch)];
    [rightBarBtn setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]} forState:UIControlStateNormal];
    return rightBarBtn;
}

//  tableView
-(UITableView*)tableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1, .1)];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1, .1)];
    [_tableView registerClass:[CCityMainTaskSearchCell class] forCellReuseIdentifier:ccityMainTaskSerachCellReuseId];
    [_tableView registerClass:[CCityMainTasekSearchResultCell class] forCellReuseIdentifier:ccityMainTaskSerachResultCellReuseId];

    _tableView.sectionFooterHeight = .1f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
   
    [self changeCurrentContentModel:CCityCurrentContentOpinioModel];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
    tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
    [_tableView addGestureRecognizer:tableViewGesture];
    return _tableView;
}

-(UIButton*)footerBtn {
    
    UIButton* footerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    footerBtn.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44.f);
    [footerBtn setTitle:@"清空历史记录" forState:UIControlStateNormal];
    footerBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [footerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [footerBtn addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
    
    return footerBtn;
}

-(UISearchBar*)searchBar {
    
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入搜索内容";
    _searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44.f);
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.backgroundImage = [[UIImage alloc]init];
    
    CAShapeLayer* layer = [self line];
    layer.backgroundColor = CCITY_RGB_COLOR(0, 0, 0, .2f).CGColor;
    layer.frame = CGRectMake(0, 43.5, self.view.bounds.size.width, .5f);

    [_searchBar.layer addSublayer:layer];
    
    return _searchBar;
}

#pragma mark- --- config datas

- (void)configData {
    
    CCityFileManager* fileManager = [[CCityFileManager alloc]init];
    
    _historyArr = [NSMutableArray arrayWithContentsOfFile:[fileManager getCacheDirFileWithFileName:CCITY_MAIN_SEARCH_TASK_CACHE_FILE_NAME]];
}

-(void)configOpinioData {
    
    _parameters[@"pageIndex"] = @(_pageIndex);
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
//    NSURLSessionDataTask* task =
    [manager POST:_url parameters:_parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* datas = responseObject[@"results"];
        
        if (datas == NULL) {    return; }
        
        if (_tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            if (datas.count == 0) {
                
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                _pageIndex--;
                return;
            }
            [_tableView.mj_footer endRefreshing];
        } else {
            
            if (_tableView.mj_header.state == MJRefreshStateRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            
            if (_datasArr.count) {
            
                [_datasArr removeAllObjects];
            }
        }
        
        for (int i = 0; i < datas.count; i++) {
            
            CCityMainSearchTaskModel* model = [[CCityMainSearchTaskModel alloc]initWithDic:datas[i]];
            [_datasArr addObject:model];
        }
        
        if (_contentModel == CCityCurrentContentOpinioModel) {
            
            if (_pageIndex >1) {
                
                NSMutableArray* indexArr = [NSMutableArray arrayWithCapacity:datas.count];
                
                for (int i = 0; i < datas.count; i++) {
                    
                    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(_datasArr.count - i - 1) inSection:0];
                    [indexArr addObject:indexPath];
                }
                
                [_tableView beginUpdates];
                
                [_tableView insertRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationFade];
                
                [_tableView endUpdates];
                
                if (datas.count * 75 <  _tableView.bounds.size.height) {
                    
                    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_datasArr.count - 2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                } else {
                    
                     [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_datasArr.count - datas.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
              
            } else {
                
                [_tableView reloadData];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (_tableView.mj_header.state == MJRefreshStateRefreshing) {
            
            [_tableView.mj_header endRefreshing];
        }
        
        if (_tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            [_tableView.mj_header endRefreshing];
        }
        
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [SVProgressHUD dismissWithDelay:2];
        
    }];
}

-(void)searchActionWithStr:(NSString*)searchStr {
    
    [SVProgressHUD show];
    
   NSDictionary* paramters = @{
                  @"token"    :[CCitySingleton sharedInstance].token,
                  @"value"    :searchStr,
                  @"pageSize" :@20,
                  @"pageIndex":@1
                  };
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    [manager POST:_url parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
//        NSLog(@"%@",task.currentRequest.URL.absoluteString);
//        NSLog(@"%@",responseObject);
        
        NSArray* datas = responseObject[@"results"];
        NSMutableArray* resultArr = [NSMutableArray array];
        if (!datas.count) {
            
            [CCityAlterManager showSimpleTripsWithVC:self Str:@"结果为空" detail:nil];
        } else {
            
            for (int i = 0; i < datas.count; i++) {
                
                CCityMainSearchTaskModel* model = [[CCityMainSearchTaskModel alloc]initWithDic:datas[i]];
                [resultArr addObject:model];
            }
        }
        
        CCityMainTaskSearchResultVC* resultVC = [[CCityMainTaskSearchResultVC alloc]initDatas:resultArr url:_url parameters:paramters];
        [self.navigationController pushViewController:resultVC animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        NSLog(@"%@",error);
    }];
}

#pragma mark- --- methods

-(void)changeCurrentContentModel:(CurrentContentModel)contentModel {
    
    _contentModel = contentModel;
    if (contentModel == CCityCurrentContentHistoryModel) {
        
        _tableView.tableFooterView = [self footerBtn];
        if (_tableView.mj_header) {
            
            if (_tableView.mj_header.state != MJRefreshStateIdle) {
                [_tableView.mj_header endRefreshing];
            }
            _tableView.mj_header = nil;
        }
        
        if (_tableView.mj_footer) {
            
            if (_tableView.mj_footer.state != MJRefreshStateIdle) {
                [_tableView.mj_footer endRefreshing];
            }
            _tableView.mj_footer = nil;
        }
      
        [_tableView reloadData];
    } else {
        
        if (!_tableView.mj_header) {
            _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
        }
        if (!_tableView.mj_footer) {
            _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
        }
        [self configOpinioData];
    }
}

-(void)headerRefreshAction {
    
    if (_pageIndex != 1) {
        _pageIndex = 1;
    }
        [self configOpinioData];
    
}

-(void)footerRefreshAction {
    
    _pageIndex++;
    [self configOpinioData];
}

- (void)tableViewTouchInSide {
    
    [self hiddenKeyboard];
}

-(BOOL)writeData {
    
    CCityFileManager* fileManager = [[CCityFileManager alloc]init];
    NSString* cachePath = [fileManager getCacheDirFileWithFileName:CCITY_MAIN_SEARCH_TASK_CACHE_FILE_NAME];
    NSMutableArray* arr = [NSMutableArray arrayWithContentsOfFile:cachePath];
    
    if ([arr isEqualToArray:_historyArr]) {
        
        return YES;
    } else {
        
        return [_historyArr writeToFile:cachePath atomically:YES];
    }
}

-(void)hiddenKeyboard {
    
    if ([_searchBar isFirstResponder]) {
        
        [_searchBar resignFirstResponder];
    }
}

//    clearHistory
-(void)clearHistory {
    
    if (_historyArr) {
        
        [_historyArr removeAllObjects];
        [_tableView reloadData];
    }
    [self hiddenKeyboard];
}

- (void)detailSearch {
    
    CCityMainTaskDetailSearchVC* detailVC = [[CCityMainTaskDetailSearchVC alloc]init];
    detailVC.url = _detailSearchUrl;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(NSString*)deleteSpaceWithStr:(NSString*)str {
    
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark- --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_contentModel == CCityCurrentContentHistoryModel) {
        
        return _historyArr.count?_historyArr.count:1;
    } else {
        
        return _datasArr.count?_datasArr.count:1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_contentModel == CCityCurrentContentHistoryModel) {
        return 30.f;
    } else {
       return 0.f;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_contentModel == CCityCurrentContentHistoryModel) {
        
        UILabel* label = [UILabel new];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.firstLineHeadIndent = 15.f;
        label.attributedText = [[NSAttributedString alloc]initWithString:@"历史记录" attributes:@{ NSParagraphStyleAttributeName  : paragraphStyle,
            NSForegroundColorAttributeName : [UIColor blackColor],
//          NSFontAttributeName            : font,
            }];
        
        label.backgroundColor = CCITY_RGB_COLOR(247, 247, 247, 1.f);
        return label;
    } else {
        return [UIView new];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_contentModel == CCityCurrentContentHistoryModel) {
        
        if (!_historyArr.count) {
            
            CCityNoDataCell* cell = [[CCityNoDataCell alloc]init];
            
            return cell;
        } else {
            
            CCityMainTaskSearchCell* cell = [tableView dequeueReusableCellWithIdentifier:ccityMainTaskSerachCellReuseId];
            
            cell.deleteSelf = ^(CCityMainTaskSearchCell *cell) {
              
                [_historyArr removeObjectAtIndex:indexPath.row];

                if (_historyArr.count >=1) {
                    
                    [tableView beginUpdates];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [tableView endUpdates];
                } else {
                    
                    [_tableView reloadData];
                }
               
            };
            cell.textLabel.text = _historyArr[indexPath.row];
            return cell;
        }
        
    } else {
        
        if (!_datasArr.count) {
            
            CCityNoDataCell* cell = [[CCityNoDataCell alloc]init];
            return cell;
        } else {
           
            CCityMainTasekSearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:ccityMainTaskSerachResultCellReuseId];
            while ([cell.contentView.subviews lastObject]) {
                [[cell.contentView.subviews lastObject] removeFromSuperview];
            }
            cell.model = _datasArr[indexPath.row];
            return cell;
        }
    }
}

#pragma mark- --- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_contentModel == CCityCurrentContentHistoryModel) {
        
        return 44.f;
    } else {
        return 75.f;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [self hiddenKeyboard];
    
    if (_contentModel == CCityCurrentContentHistoryModel) {
        
        if (!_historyArr.count) {   return; }

        if ([_searchBar.text isEqualToString:_historyArr[indexPath.row]]) {
            
            _searchBar.text = _historyArr[indexPath.row];
        }
        
        [self searchActionWithStr:_historyArr[indexPath.row]];
    } else {
        
        if (!_datasArr.count) { return; }
        
        CCityMainSearchTaskModel* model = _datasArr[indexPath.row];
        
        NSDictionary* ids = @{
                              @"workId" :model.workId,
                              @"fkNode" :model.fkNode,
                              @"formId" :model.formId,
                              @"fk_flow":model.fkFlow,
                              };
        
        CCityOfficalDocDetailVC* docDetailVC = [[CCityOfficalDocDetailVC alloc]initWithItmes:@[@"表单信息", @"材料清单"] Id:ids contentModel:CCityOfficalDocHaveDoneMode];
        
        docDetailVC.mainStyle = CCityOfficalMainDocStyle;
        
        [self.navigationController pushViewController:docDetailVC animated:YES];
    }
}

#pragma mark- --- searchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString* sarchStr = [self deleteSpaceWithStr:searchBar.text];
    
    if (sarchStr.length > 0) {
        
        if (!_historyArr.count) {
            _historyArr = [NSMutableArray array];
        }
        
        if (![_historyArr containsObject:sarchStr]) {

//            [_tableView beginUpdates];
            
            [_historyArr insertObject:sarchStr atIndex:0];
            
            [_tableView reloadData];
//            [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]withRowAnimation:UITableViewRowAnimationAutomatic];
            
//            [_tableView endUpdates];
        }
        
        [self searchActionWithStr:sarchStr];
    }
    
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    searchBar.showsCancelButton = YES;
    [self changeCurrentContentModel:CCityCurrentContentHistoryModel];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    searchBar.showsCancelButton = NO;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self hiddenKeyboard];
}

@end
