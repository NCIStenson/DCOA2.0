//
//  CCityHomeVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/7/29.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCIYT_A_MAP_URL @"http://60.10.185.43:8088/gis"

#import "CCityHomeVC.h"
#import <SDCycleScrollView.h>
#import "CCityHomeCell.h"
#import "CCityMainTaskSearchVC.h"
#import "CCityMainDocSearchModel.h"
#import "CCityDocSearchVC.h"
#import "CCityNotficVC.h"
#import "CCityMainMessageVC.h"
#import "CCityMainMeetingListVC.h"
#import "CCityNewsListVC.h"
#import "CCityNewsModel.h"
#import "CCityNewsDetailVC.h"
#import "CCityAMapVC.h"
#import <GTSDK/GeTuiSdk.h>

#define CCITY_HOME_LINE_WIDTH .5f
#define CCITY_HOME_LINE_COLOR [UIColor lightGrayColor]

@interface CCityHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

static NSString* homeCollectionCellReuseId = @"homeCollectionCellReuseId";
static NSString* homeCollectionSectionHeaderReuseId = @"homeCollectionSectionHeaderReuseId";
static NSString* homeCollectionSectionFooterReuseId = @"homeCollectionSectionFooterReuseId";

@implementation CCityHomeVC {
    
    NSMutableArray*      _dataMuArr;
    NSMutableDictionary* _parameters;
    
    UILabel* _userName;
    UILabel* _userFrom;
    
    UICollectionView* _collectionView;
    
    SDCycleScrollView* _quickNewsScrollView; // 快讯
    NSArray*           _quickNewsModelArr;
    
    BOOL          _sholdHiddenNavBar;
    NSMutableArray* _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _hiddenNavBarAnimate = NO;
    _sholdHiddenNavBar = NO;
    self.title = @"首页";
    self.view.backgroundColor = CCITY_MAIN_BGCOLOR;
    [self layoutMySubViews];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self checkJurisdiction];
    
    NSString* userNameStr =  [CCitySingleton sharedInstance].userName;
    
    if (![_userName.text isEqualToString:userNameStr]) {
        
        _userName.attributedText = [self getAttributedStringWithStr:userNameStr];
    }
    
    NSString* userFromStr =  [CCitySingleton sharedInstance].deptname;
    
    if (![_userFrom.text isEqualToString:userFromStr]) {
        
           _userFrom.attributedText = [self getAttributedStringWithStr:userFromStr];
    }

    if (self.navigationController.navigationBar.hidden == NO) {

        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        [self.navigationController setNavigationBarHidden:YES animated:_hiddenNavBarAnimate];
    }
    
    if (_sholdHiddenNavBar) {   _sholdHiddenNavBar = NO;    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _hiddenNavBarAnimate = YES;
    [self configBadgeNum];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
      [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark- --- layout subviews

-(void)layoutMySubViews {
    
    _collectionView = [self collectionView];
    _collectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:_collectionView];
}

- (UICollectionView*)collectionView {
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.minimumLineSpacing      = .0f;
    flowLayout.minimumInteritemSpacing = .0f;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    flowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.width * 9/16.f + 44.f);
    flowLayout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 44.f);
    
    flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width / 3.f, self.view.bounds.size.width / 3.f - 20);
    
    UICollectionView* collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];

    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[CCityHomeCell class] forCellWithReuseIdentifier:homeCollectionCellReuseId];
    
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:homeCollectionSectionHeaderReuseId];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:homeCollectionSectionFooterReuseId];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    return collectionView;
}
//    textScrollView
-(UIView*)textScrollView {
    
    UIView* textScrollView = [UIView new];
    textScrollView.backgroundColor = [UIColor whiteColor];
    
    UIImageView* imageLabel = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_quickNews_60x60_"]];
    
    UIView* lineView = [UIView new];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    _quickNewsScrollView = [[SDCycleScrollView alloc]init];
    _quickNewsScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    _quickNewsScrollView.onlyDisplayText = YES;
    _quickNewsScrollView.titlesGroup = @[@"暂无动态"];
    _quickNewsScrollView.titleLabelTextColor = [UIColor darkGrayColor];
    _quickNewsScrollView.titleLabelTextFont = [UIFont systemFontOfSize:12];
    _quickNewsScrollView.backgroundColor = [UIColor whiteColor];
    _quickNewsScrollView.titleLabelBackgroundColor = [UIColor whiteColor];
    
    __block CCityHomeVC* blockSelf = self;
    _quickNewsScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
      
        [blockSelf pushToNewsDetail:currentIndex];
    };
    
    [self configQuickNewsData];
    
    [textScrollView addSubview:lineView];
    [textScrollView addSubview:imageLabel];
    [textScrollView addSubview:_quickNewsScrollView];
    
    [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(textScrollView).with.offset(5.f);
        make.left.equalTo(textScrollView).with.offset(10.f);
        make.bottom.equalTo(textScrollView).with.offset(-5.f);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_quickNewsScrollView).with.offset(5.f);
        make.left.equalTo(imageLabel.mas_right).with.offset(5.f);
        make.bottom.equalTo(_quickNewsScrollView).with.offset(-5.f);
        make.width.mas_equalTo(1.f);
    }];
    
    [_quickNewsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(textScrollView).with.offset(5.f);
        make.left.equalTo(lineView.mas_right).with.offset(5.f);
        make.bottom.equalTo(textScrollView).with.offset(-5.f);
        make.right.equalTo(textScrollView).with.offset(-5.f);
    }];
    
    return textScrollView;
}

//    imageScrollView
-(SDCycleScrollView*)imageScrollView {
    
    SDCycleScrollView* imageScrollView = [[SDCycleScrollView alloc]init];
    imageScrollView.localizationImageNamesGroup = @[@"02.jpg"];
    imageScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
    
    };
    
    imageScrollView.autoScroll = NO;
    imageScrollView.infiniteLoop = NO;
    imageScrollView.showPageControl = NO;
    return imageScrollView;
}

-(UIControl*)userCenterCon {
    
    UIControl* userCenterCon = [UIControl new];
    
    UIImageView* userHeader = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_uesrcenter_userHeader"]];
    
    userHeader.layer.shadowColor = [UIColor whiteColor].CGColor;
    userHeader.layer.shadowRadius = 1.f;
    userHeader.layer.shadowOpacity = .3f;
    userHeader.layer.shadowOffset = CGSizeMake(0, 0);
    
    _userName = [self userDetailLabel];
    NSString* userNameStr = [CCitySingleton sharedInstance].userName;
    _userName.attributedText = [self getAttributedStringWithStr:userNameStr];
    
    _userFrom = [self userDetailLabel];
    NSString* userFromStr = [CCitySingleton sharedInstance].deptname;
    _userFrom.attributedText = [self getAttributedStringWithStr:userFromStr];
    
    [userCenterCon addSubview:userHeader];
    [userCenterCon addSubview:_userName];
    [userCenterCon addSubview:_userFrom];
    
    [userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(userCenterCon);
        make.left.equalTo(userCenterCon).with.offset(20.f);
        make.right.equalTo(userCenterCon).with.offset(-20.f);
        make.height.equalTo(userHeader.mas_width);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(userHeader.mas_bottom).with.offset(5.f);
        make.left.equalTo(userCenterCon);
        make.right.equalTo(userCenterCon);
        make.bottom.equalTo(_userFrom.mas_top);
    }];
    
    [_userFrom mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_userName.mas_bottom);
        make.left.equalTo(userCenterCon);
        make.right.equalTo(userCenterCon);
        make.bottom.equalTo(userCenterCon);
    }];
    
    return userCenterCon;
}

-(UILabel*)userDetailLabel {
    
    UILabel* userDetailLabel = [UILabel new];
    userDetailLabel.font = [UIFont systemFontOfSize:12.f];
    userDetailLabel.textColor = [UIColor whiteColor];
    userDetailLabel.textAlignment = NSTextAlignmentCenter;
    userDetailLabel.shadowOffset = CGSizeMake(1.f, 1.f);
    return userDetailLabel;
}

-(NSAttributedString*)getAttributedStringWithStr:(NSString*)str {
    
    NSShadow* shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = 2.f;
    shadow.shadowOffset = CGSizeMake(0, 0);
    shadow.shadowColor = [UIColor blackColor];
    
    NSAttributedString* attributedStr = [[NSAttributedString alloc]initWithString:str attributes:@{NSShadowAttributeName:shadow}];
    return attributedStr;
}

#pragma mark- --- methods

- (void)checkJurisdiction {
    
    NSMutableArray* titles = [@[@"公文办理", @"消息提示", @"通知通告", @"新闻浏览"] mutableCopy];
    NSArray* jurisdictionArr = [CCitySingleton sharedInstance].jurisdictionArr;
    
    if (jurisdictionArr != NULL) {
        
        if ([jurisdictionArr containsObject:@"本人查询"]) {
            [titles addObject:@"本人查询"];
        }
        
        if ([jurisdictionArr containsObject:@"本局查询"]) {
            [titles addObject:@"本局查询"];
        }
        
        if ([jurisdictionArr containsObject:@"综合查询"]) {
            [titles addObject:@"综合查询"];
        }
    }
    
    if (![_titles isEqualToArray:titles]) {
        
        _titles = [titles mutableCopy];
        [self configData:_titles];
    }
}

-(void)pushToNewsDetail:(NSInteger)index {
    
    if (!_quickNewsModelArr.count) {
        
        return;
    }
    
    CCityNewsDetailVC* newsDetail = [[CCityNewsDetailVC alloc]initWithModel:_quickNewsModelArr[index]];
    [self.navigationController pushViewController:newsDetail animated:YES];
}

- (void)userCenterAction {
    
    self.tabBarController.selectedIndex = 2;
}

-(void)searchWithStyle:(CCityHomeCellStyle)searchStyle {
    
    CCityMainTaskSearchVC* searchVC = [[CCityMainTaskSearchVC alloc]init];
    searchVC.searchStyle = searchStyle;
     [self pushToVC:searchVC hiddenNavBar:NO];
}

#pragma mark- --- netWork

- (void)configData:(NSArray*)titles {
    
    _dataMuArr = [NSMutableArray arrayWithCapacity:titles.count];
    
    for (int i = 0 ; i < titles.count; i++) {
        
        CCityHomeModel* model = [CCityHomeModel new];
        model.title = titles[i];
        
        if ([model.title isEqualToString:@"公文办理"]) {
            
            model.imageName = @"homeCell0_200x200_";
            model.cellStyle = CCityHomeCellDocStyle;
        } else if ([model.title isEqualToString:@"消息提示"]) {
            
            model.imageName = @"homeCell2_200x200_";
            model.cellStyle = CCityHomeCellMessageStyle;
        } else if ([model.title isEqualToString:@"通知通告"]) {
            
            model.imageName = @"homeCell3_200x200_";
            model.cellStyle = CCityHomeCellNotStyle;
        } else if ([model.title isEqualToString:@"新闻浏览"]) {
            
            model.imageName = @"homeCell4_200x200_";
            model.cellStyle = CCityHomeCellNewsStyle;
        } else if ([model.title isEqualToString:@"综合查询"]) {
            
            model.imageName = @"homeCell6_200x200_";
            model.cellStyle = CCityHomeCellTaskSearchStyle;
        } else if ([model.title isEqualToString:@"一张图"]) {
            
            model.imageName = [NSString stringWithFormat:@"homeCell8_200x200_"];
            model.cellStyle = CCityHomeCellAMapStyle;
        } else if ([model.title isEqualToString:@"本人查询"]) {
            
            model.imageName = @"homeCell6_200x200_";
            model.cellStyle = CCityHomeCellPersonSearchStyle;
        } else if ([model.title isEqualToString:@"本局查询"]) {
            
            model.imageName = @"homeCell6_200x200_";
            model.cellStyle = CCityHomeCellOfficeSearchStyle;
        }
        
        [_dataMuArr addObject:model];
    }
    
    [_collectionView reloadData];
}

-(void)configBadgeNum {
    
    NSArray* badgeUrls = @[@"service/search/GetNotRead.ashx",@"service/message/GetNumOfUnreadMessages.ashx"];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSDictionary* parameters = @{@"token":[CCitySingleton sharedInstance].token};
    
    for (int i = 0; i < badgeUrls.count; i++) {
        
        [manager GET:badgeUrls[i] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger bageNum = 0;
            
            // 公文 审批
            if ([task.currentRequest.URL.absoluteString containsString:@"service/search/GetNotRead.ashx"]) {
  
                bageNum = [responseObject[@"documentNum"] integerValue];
                [self refreshBadgeNumWithIndex:0 badgeNum:bageNum];
//                bageNum = [responseObject[@"projectNum"] integerValue];
//                [self refreshBadgeNumWithIndex:1 badgeNum:bageNum];
            }
            
            // 消息
            if ([task.currentRequest.URL.absoluteString containsString:@"service/message/GetNumOfUnreadMessages.ashx"]) {
                
            bageNum = [responseObject[@"total"] integerValue];
            [self refreshBadgeNumWithIndex:1 badgeNum:bageNum];
                
                if ( [UIApplication sharedApplication].applicationIconBadgeNumber != bageNum) {
                    
                    [UIApplication sharedApplication].applicationIconBadgeNumber = bageNum;
                    [GeTuiSdk setBadge:bageNum];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@",error.description);
        }];
    }
}

-(void)configQuickNewsData {
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    [manager GET:@"service/search/GetNewsList.ashx" parameters:@{@"pageIndex":@"1", @"pageSize":@"5"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* results = responseObject[@"results"];
        NSMutableArray* resultsDataArr = [NSMutableArray arrayWithCapacity:results.count];
        NSMutableArray* titlesGruop = [NSMutableArray arrayWithCapacity:results.count];
        
        for (int i = 0; i < results.count; i++) {
            
            CCityNewsModel* model = [[CCityNewsModel alloc]initWithDic:results[i]];
            [titlesGruop addObject:model.title];
            [resultsDataArr addObject:model];
        }
        
        _quickNewsModelArr = [resultsDataArr mutableCopy];
        
        if (titlesGruop.count) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _quickNewsScrollView.titlesGroup = titlesGruop;
                _quickNewsScrollView.autoScroll = YES;
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];
}

#pragma mark- --- methods

-(void)pushToVC:(UIViewController*)vc hiddenNavBar:(BOOL)isHidden {
    
    vc.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)docSearch {
    
    CCityDocSearchVC* searchResultVC = [[CCityDocSearchVC alloc]initDatas:nil url:nil parameters:nil];
    
    [self pushToVC:searchResultVC hiddenNavBar:NO];
}

-(void)aMapAction {
    
    _hiddenNavBarAnimate = NO;
    CCityAMapVC* aMapView = [[CCityAMapVC alloc]initWithUrl:CCIYT_A_MAP_URL title:@"一张图"];
    aMapView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aMapView animated:NO];
}

-(void)refreshBadgeNumWithIndex:(NSInteger)index badgeNum:(NSInteger)badgeNum {
    
    if (badgeNum <= 0) {    return; }
    
    CCityHomeModel* model = _dataMuArr[index];
    
    if (model.badgeNum != badgeNum) {
        
        model.badgeNum = badgeNum;
        [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    }
}

#pragma mark- --- collectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataMuArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityHomeCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeCollectionCellReuseId forIndexPath:indexPath];
    
    while ([cell.contentView.subviews lastObject]) {
        
        [[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    if (indexPath.row%3 == 0) {
    
        cell.posintion = CCityHomeCellPositionLeft;
    } else if (indexPath.row%3 == 1) {
        
        cell.posintion = CCityHomeCellPositionCenter;
    } else {
        
        cell.posintion = CCityHomeCellPositionRight;
    }
    
    cell.model = _dataMuArr[indexPath.row];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView*  reuseView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:homeCollectionSectionHeaderReuseId forIndexPath:indexPath];
        UIView* textScrollView =[self textScrollView];
        SDCycleScrollView* imageScrollView = [self imageScrollView];
        
        UIControl* userCenterCon = [self userCenterCon];
        [userCenterCon addTarget:self action:@selector(userCenterAction) forControlEvents:UIControlEventTouchUpInside];
        
        [imageScrollView addSubview:userCenterCon];
        [reuseView addSubview:textScrollView];
        [reuseView addSubview:imageScrollView];
        
        [userCenterCon mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerX.equalTo(imageScrollView);
            make.centerY.equalTo(imageScrollView).with.offset(20.f);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        [textScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(reuseView);
            make.bottom.equalTo(reuseView);
            make.right.equalTo(reuseView);
            make.height.mas_equalTo(44.f);
        }];
        
        [imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(reuseView).with.offset(-[UIApplication sharedApplication].statusBarFrame.size.height);
            make.left.equalTo(reuseView);
            make.bottom.equalTo(textScrollView.mas_top);
            make.right.equalTo(reuseView);
        }];
        
    } else if (kind == UICollectionElementKindSectionFooter) {
        
        reuseView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:homeCollectionSectionFooterReuseId forIndexPath:indexPath];
        
        UIView* bottomView = [UIView new];
        bottomView.backgroundColor = [UIColor whiteColor];
        reuseView.backgroundColor = [UIColor lightGrayColor];
        [reuseView addSubview:bottomView];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(reuseView).with.insets(UIEdgeInsetsMake(CCITY_HOME_LINE_WIDTH, 0, 0, 0));
        }];
    }
    
    reuseView.backgroundColor = CCITY_HOME_LINE_COLOR;
    
    return reuseView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityHomeModel* model = _dataMuArr[indexPath.row];
    model.badgeNum = 0;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    switch (model.cellStyle) {
            
        case CCityHomeCellDocStyle:
            
            self.tabBarController.selectedIndex = 1;
            break;
        case CCityHomeCellSPStyle:
            
            self.tabBarController.selectedIndex = 2;
            break;
        case CCityHomeCellMessageStyle:
            
            [self pushToVC:[[CCityMainMessageVC alloc]init] hiddenNavBar:NO];
            break;
        case CCityHomeCellNotStyle:
            
            [self pushToVC:[[CCityNotficVC alloc]init] hiddenNavBar:NO];
            break;
        case CCityHomeCellNewsStyle:
            
            [self pushToVC:[[CCityNewsListVC alloc]init] hiddenNavBar:NO];
            break;
        case CCityHomecellMettingManagerStyle:
            
            [self pushToVC:[[CCityMainMeetingListVC alloc] init] hiddenNavBar:NO];
            break;
            // search
        case CCityHomeCellTaskSearchStyle:
        case CCityHomeCellOfficeSearchStyle:
        case CCityHomeCellPersonSearchStyle:
            
            [self searchWithStyle:model.cellStyle];
            break;
        case CCityHomeCellDocSearchStyle:
            
            self.navigationController.navigationBar.hidden = NO;
            [self docSearch];
            break;
        case CCityHomeCellAMapStyle:
            
            [self aMapAction];
            break;
       
        default:
            break;
    }
}

@end
