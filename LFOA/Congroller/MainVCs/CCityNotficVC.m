//
//  CCityNotficVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNotficVC.h"
#import "CCityNoficDetailVC.h"
#import "CCityNotficCell.h"
#import "CCityNavBar.h"

@interface CCityNotficVC ()

@end

static NSString* cellReuseId = @"cellReuseId";

@implementation CCityNotficVC {
    
    NSInteger            _pageIndex;
    NSMutableDictionary* _parameters;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通知通告";
    
    _pageIndex = 1;
    
    _parameters = [NSMutableDictionary dictionary];
    [_parameters setObject:@20 forKey:@"pageSize"];
    [_parameters setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
    
//    self.tableView.rowHeight = 90.f;
    [self.tableView registerClass:[CCityNotficCell class] forCellReuseIdentifier:cellReuseId];

    [self configData];
}

#pragma mark- --- net work

-(void)configData {
    
    if (![self isRefreshing]) { [SVProgressHUD show];   }
    
    AFHTTPSessionManager* manger = [CCityJSONNetWorkManager sessionManager];
    
    [_parameters setObject:@(_pageIndex) forKey:@"pageIndex"];
    
    [manger POST:@"service/search/GetNoticeList.ashx" parameters:_parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSArray* results = responseObject[@"results"];
        
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing  ) {
            
            [self endRefreshing];
            [self.tableView.mj_footer resetNoMoreData];
            
            [self.datasMuArr removeAllObjects];
            
            [self addDataWithResuts:results];
            
            [self.tableView reloadData];
            
        } else if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            
            [self endRefreshing];
            
            if (!results.count) {
                _pageIndex--;
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                
                [self addDataWithResuts:results];
                
                NSMutableArray* indexPaths = [NSMutableArray arrayWithCapacity:results.count];
                [self.tableView beginUpdates];
                
                for (int i = 0; i < results.count; i++) {
                    
                    [indexPaths addObject:[NSIndexPath indexPathForRow:self.datasMuArr.count - 1 -i inSection:0]];
                }
                
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                
                [self.tableView endUpdates];
                
            }
        } else {
            
            [self addDataWithResuts:results];
            [self.tableView reloadData];
        }
        
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
            _pageIndex--;
        }
        
        [self endRefreshing];
        [SVProgressHUD dismiss];
        
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        
        NSLog(@"%@",error.description);
    }];
}

#pragma mark- --- methods

-(void)addDataWithResuts:(NSArray*)results {
    
    for (int i = 0; i < results.count; i++) {
        
        CCityNotficModel* model = [[CCityNotficModel alloc]initWithDic:results[i]];
        [self.datasMuArr addObject:model];
    }
}

-(BOOL)isRefreshing {
    
    return (self.tableView.mj_header.state == MJRefreshStateRefreshing || self.tableView.mj_footer.state == MJRefreshStateRefreshing);
}

-(void)endRefreshing {
    
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        
        [self.tableView.mj_header endRefreshing];
    }
    
    if (self.tableView.mj_footer.state == MJRefreshStateRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}

-(void)headerRefresh {
    
    _pageIndex = 1;
    [self configData];
}

-(void)footerRefresh {
    
    _pageIndex++;
    [self configData];
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.datasMuArr.count) {   return 44.f; }
    
    return 90.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.datasMuArr.count) {
        
        CCityNoDataCell* cell = [CCityNoDataCell new];
        return cell;
    }
    
    CCityNotficCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId forIndexPath:indexPath];
    
    while ([cell.contentView.subviews lastObject]) {
        
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    cell.model = self.datasMuArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityNoficDetailVC* detailVC = [[CCityNoficDetailVC alloc]initWithModel:self.datasMuArr[indexPath.row]];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
