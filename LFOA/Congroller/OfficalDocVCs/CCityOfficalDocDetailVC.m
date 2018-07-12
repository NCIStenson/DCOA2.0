//
//  CCityOfficalDocDetailVC.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/3.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDocDetailVC.h"
#import "CCityOfficalDetailSectionView.h"
#import "CCityOfficalDocDetailCell.h"
#import "CCityOfficalDetailDocListView.h"
#import <UITableView+FDIndexPathHeightCache.h>
#import "CCityAlterManager.h"
#import "CCityOfficalDetailPsrsonListVC.h"
#import "CCityDatePickerVC.h"
#import "CCitySystemVersionManager.h"
#import "CCityScrollViewVC.h"
#import "CCityBackToLeftView.h"
#import <TSMessage.h>
#import "XuAlertCon.h"

@interface CCityOfficalDocDetailVC ()<CCityOfficalDocDetailDelegate,CCityOffialPersonListDelegate>

@end

static NSString* ccifyOfficlaDetailSectionReuseId  = @"ccifyOfficlaDetailSectionReuseId";

@implementation CCityOfficalDocDetailVC {
    
    CGRect        _editCellFrame;
    UIView*       _footerView;
    UIButton*     _sendBtn;
    
    CCityOfficalDetailDocListView* _fileListView;
    
    NSMutableDictionary* _valuesDic;
    NSMutableDictionary* _docId;
    
    XuAlertCon*          _alertCon;
    NSIndexPath*         _currentHuiqianCellIndexPath;
}

-(instancetype)initWithItmes:(NSArray *)items Id:(NSDictionary*)docId contentModel:(CCityOfficalDocContentMode)contentMode {
    self = [super initWithItmes:items];
    
    if (self) {
        
        _conentMode = contentMode;
        _docId      = [docId mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDataWithId:_docId];
    
    self.navigationItem.leftBarButtonItem  = [self leftBarBtnItem];
    self.navigationItem.rightBarButtonItem = [self rightBarBtnItem];
    
    if (_conentMode == CCityOfficalDocBackLogMode) {
     
        _footerView = [self footerView];
        [self.view addSubview:_footerView];
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {

                if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
            
                    make.bottom.equalTo(self.view).with.offset(-79.f);

                } else {
        
                    make.bottom.equalTo(self.view).with.offset(-49.f);
                }
        }];
        
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.tableView.mas_bottom);
            make.left.equalTo  (self.view);
            make.bottom.equalTo(self.view);
            make.right.equalTo (self.view);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    } else {
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view);
        }];
    }
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self hiddenKeyboard];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_mainStyle == CCityOfficalMainSPStyle) {
        
        self.title = @"项目详情";
    } else if (_mainStyle == CCityOfficalMainDocStyle) {
        
        self.title = @"公文详情";
    }
}

#pragma mark- --- layout Subviews

- (UIView*)footerView {
    
    UIView* footerView = [UIView new];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

- (void)updataFootViewWithContentHuiQian:(BOOL)isContentHuiQian {
    
    UIButton* saveBtn = [self getBottomBtnWithTitle:@"保 存" sel:@selector(saveAction)];
    
     _sendBtn =[self getBottomBtnWithTitle:@"发 送" sel:@selector(sendAction)];
    
    if (_isEnd) {
        [_sendBtn setTitle:@"结案" forState:UIControlStateNormal];
    }
    
    UIButton* NWBtn = [self getBottomBtnWithTitle:@"拟 文" sel:@selector(nwAction)];
    
    
    [_footerView addSubview:NWBtn];
    [_footerView addSubview:saveBtn];
    [_footerView addSubview:_sendBtn];
    
    UIButton* huiqianBtn;
    if (isContentHuiQian) {
        
        huiqianBtn = [self getBottomBtnWithTitle:@"领导意见" sel:@selector(huiqianAction)];
        [_footerView addSubview:huiqianBtn];
    }
    
    NSMutableArray* btnsArr = [@[NWBtn,saveBtn,_sendBtn] mutableCopy];
    
    if (huiqianBtn ) {  [btnsArr addObject:huiqianBtn]; }
    
    [btnsArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    
    [btnsArr mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_footerView).with.offset(5.f);
        
        if ([[CCitySystemVersionManager deviceStr] isEqualToString:@"iPhone X"]) {
            
            make.bottom.equalTo(_footerView).with.offset(-30.f);
        } else {
            
            make.bottom.equalTo(_footerView).with.offset(-10.f);
        }
    }];
}

-(UIButton*)getBottomBtnWithTitle:(NSString*)title sel:(SEL)sel {
    
    UIButton* bottomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    bottomBtn.backgroundColor = CCITY_MAIN_COLOR;
    [bottomBtn setTitle:title forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bottomBtn.clipsToBounds = YES;
    bottomBtn.layer.cornerRadius = 5.f;
    [bottomBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return bottomBtn;
}

// left nav btn
-(UIBarButtonItem*)leftBarBtnItem {
    
    CCityBackToLeftView* backArrow = [CCityBackToLeftView new];
    
    UIControl* backCon = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 60.f, 44.f)];
    [backCon addTarget:self
                action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backCon addSubview:backArrow];
    
    UIBarButtonItem* leftBarBtnItem = [[UIBarButtonItem alloc]initWithCustomView:backCon];
    
    return leftBarBtnItem;
}

// right nav btn
-(UIBarButtonItem*)rightBarBtnItem {
    
    UIBarButtonItem* rightBarBtnItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ccity_nav_menu_30x30_"] style:UIBarButtonItemStylePlain target:self action:@selector(menuAction)];
    
    rightBarBtnItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    return rightBarBtnItem;
}

-(CCityOfficalDetailDocListView*) fileListView {
    
    CCityOfficalDetailDocListView* listView = [[CCityOfficalDetailDocListView alloc]initWithUrl:@"service/form/GetMaterialList.ashx" andIds:_docId];
    
    listView.backgroundColor = [UIColor whiteColor];
    
    return listView;
}

#pragma mark- --- methods

// content mode changed
-(void)segmentedConValueChanged:(CCitySegmentedControl *)segCon {
    
    _footerView.hidden = segCon.selectedIndex;
    
    if (segCon.selectedIndex == 0) {
        
        [self.view bringSubviewToFront:self.tableView];
        
        if (_footerView) {
            [self.view bringSubviewToFront:_footerView];
        }
        
    } else {
        
        if (!_fileListView) {
            
            _fileListView = [self fileListView];
            
            __block CCityOfficalDocDetailVC* blockSelf = self;
            
            _fileListView.pushToFileViewerVC = ^(UIViewController *fileViewerVC) {
              
                [blockSelf pushTo:fileViewerVC];
            };
            
            [self.view addSubview:_fileListView];
            
            [_fileListView mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.top.equalTo(self.tableView);
                make.left.equalTo(self.tableView);
                make.right.equalTo(self.tableView);
                make.bottom.equalTo(self.view);
            }];
            [self.view bringSubviewToFront:_fileListView];

        } else {
            
            [self.view bringSubviewToFront:_fileListView];
        }
    }
}

// back action
- (void)backAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

// menu action
- (void) menuAction {
    
    CCityOfficalDetailMenuVC* menuVC = [[CCityOfficalDetailMenuVC alloc]initWithStyle:_mainStyle];
    menuVC.contentMode = _conentMode;
    menuVC.ids = _docId;
    menuVC.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    
    menuVC.pushToNextVC = ^(UIViewController *viewController) {
        
        [self.navigationController pushViewController:viewController animated:YES];
    };
    
    menuVC.pushToRoot = ^{
      
        if (self.sendActionSuccessed) {
            self.sendActionSuccessed(_indexPath);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    self.navigationController.definesPresentationContext = YES;
    
    menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self.navigationController presentViewController:menuVC animated:NO completion:nil];
}

// push to vc 
-(void)pushTo:(UIViewController*)vc {
    
    [self.navigationController pushViewController:vc animated:YES];
}

// sectionview clicked
- (void) sectionViewClicked:(CCityOfficalDetailSectionView*)sectionView {
    
    CCityOfficalDocDetailModel* model = self.dataArr[sectionView.sectionNum];
   
    [self.view endEditing:YES];
    
    if (sectionView.imageView) {
        
        model.isOpen = !model.isOpen;
        model.hasCell = model.isOpen;
        
        [self.tableView beginUpdates];
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionView.sectionNum] withRowAnimation:UITableViewRowAnimationFade];

        [self.tableView endUpdates];
    
    } else {
        
        if (model.canEdit == NO) {  return; }
        
        if (model.style == CCityOfficalDetailDateStyle) {
            
            [self showDatePickerVCWithIndex:sectionView.sectionNum];
        } else if (model.style == CCityOfficalDetailSimpleLineTextStyle) {
            
            [self showInputVCWithModel:model andIndex:sectionView.sectionNum];
        } else if (model.style == CCityOfficalDetailContentSwitchStyle) {
            
            [self showSwitchVCWithModel:model index:sectionView.sectionNum];
        }
    }
}

// show input vc
- (void)showInputVCWithModel:(CCityOfficalDocDetailModel*)model andIndex:(NSInteger)index {
    
    NSString* title = [NSString stringWithFormat:@"修改%@",model.title];
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       
        textField.text = model.value;
    }];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField* inputTF = alertController.textFields[0];
        [self saveMethodWithIndex:index andText:inputTF.text];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

// show datePickerVC
- (void) showDatePickerVCWithIndex:(NSInteger)index {
    
    CCityDatePickerVC* dataPicker = [[CCityDatePickerVC alloc]initWithDate:nil];
    
    dataPicker.slelectAction = ^(NSString *date) {
      
        [self saveMethodWithIndex:index andText:date];
           [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    [self presentViewController:dataPicker animated:YES completion:nil];
}

// show switch vc
-(void)showSwitchVCWithModel:(CCityOfficalDocDetailModel*)model index:(NSInteger)index {
    
    UIAlertController* switchVC = [UIAlertController alertControllerWithTitle:model.title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < model.switchContentArr.count; i++) {
        
        UIAlertAction* action = [UIAlertAction actionWithTitle:model.switchContentArr[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self saveMethodWithIndex:index andText:action.title];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
        }];
        
        [switchVC addAction:action];
        
        if (i == model.switchContentArr.count -1) {
            
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [switchVC addAction:cancelAction];
        }
    }
    
    [self presentViewController:switchVC animated:YES completion:nil];
}

// 拟文
-(void) nwAction {
    
    [SVProgressHUD show];
    AFHTTPSessionManager* mananger = [CCityJSONNetWorkManager sessionManager];
    [mananger GET:@"service/form/GetWordFile.ashx" parameters:_docId progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        if (responseObject[@"urlpath"]) {
            
            NSArray* urlPathes = responseObject[@"urlpath"];
            CCityScrollViewVC* wordViewer = [[CCityScrollViewVC alloc]initWithURLs:urlPathes];
            wordViewer.title = @"拟文";
            [self.navigationController pushViewController:wordViewer animated:YES];
        } else {
            
            [SVProgressHUD showErrorWithStatus:@"服务器错误"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
        if (CCITY_DEBUG) {  NSLog(@"%@",error); }
    }];
}

// send
- (void) sendAction {
    
    if (_isEnd) {
        
        [SVProgressHUD show];
        
        AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
        
        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:_docId];
        
        [dic setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
        
        [manager POST:@"service/form/End.ashx" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [SVProgressHUD dismiss];
            
            if ([responseObject[@"status"] isEqual:@"success"]) {
                
                if (self.sendActionSuccessed) {
                    
                    self.sendActionSuccessed(_indexPath);
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                
                [self showIsEndFailedAlertVCWithTip:@"结案失败"];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD dismiss];
            
            [self showIsEndFailedAlertVCWithTip:error.localizedDescription];
        }];
    } else {
        
        CCityOfficalDetailPsrsonListVC* listVC = [[CCityOfficalDetailPsrsonListVC alloc]initWithIds:_docId];
        listVC.delegate = self;
        [self pushTo:listVC];
    }
}

-(void)huiqianAction {
    
    UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.tag = 20001;
    [cancelBtn addTarget:self action:@selector(huiqianBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.tag = 20002;
    [sendBtn addTarget:self action:@selector(huiqianBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray* btnArr = @[cancelBtn, sendBtn];
    
    _alertCon = [[XuAlertCon alloc]initWithTitle:@"领导意见" btns:btnArr];
    _alertCon.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:_alertCon animated:NO completion:nil];
}

-(void)showIsEndFailedAlertVCWithTip:(NSString*)tip {
    
    UIAlertController* alertCon = [UIAlertController alertControllerWithTitle:@"提示" message:tip preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction* reTryAction = [UIAlertAction actionWithTitle:@"重试" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        [self sendAction];
    }];
    
    [alertCon addAction:cancelAction];
    [alertCon addAction:reTryAction];
    
    [self presentViewController:alertCon animated:YES completion:nil];
}

- (void) saveMethodWithIndex:(NSInteger)index andText:(NSString*)text {
    
     if (!_valuesDic) {  _valuesDic = [NSMutableDictionary dictionary];  }
    
    CCityOfficalDocDetailModel* model = self.dataArr[index];
    
    // 根据 model 的table 值 去 _valuesDic 查找 对应table
    NSMutableDictionary* talbeDic = _valuesDic[model.table];
    
    // 如果table 不存在，创建table，并把tale 保存到 _valuesDic 中
    if (!talbeDic) {
        
        talbeDic = [NSMutableDictionary dictionary];
        [_valuesDic setObject:talbeDic forKey:model.table];
    }
    
    if (model.style == CCityOfficalDetailDateStyle) {
        
        NSArray* timesArr = [text componentsSeparatedByString:@"-"];
        model.value = [NSString stringWithFormat:@"%@/%@/%@",timesArr[0],timesArr[1],timesArr[2]];
    } else {
        
        model.value = text;
    }
    
    NSDictionary* valusDic = @{
                               @"@dataType"     :model.dataType,
                               @"#cdata-section":text
                               };
    
    // 保存到table中，因为table 是指针，所以同步会保存到 _valuesDic 中
    [talbeDic setObject:valusDic forKey:model.field];
}

- (void)checkVisibleWithView:(CCityOfficalDetailSectionView*)view {
    
    CGRect viewFrame = view.frame;
    viewFrame.size.height = viewFrame.size.height + 100.f;
    
    if (!CGRectIntersectsRect(self.view.frame, view.frame)) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:view.sectionNum] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)hiddenKeyboard {
    
    [self.view endEditing:YES];
}

#pragma mark- --- network

-(void)huiqianBtnAction:(UIButton*)btn {
    
    NSURLSessionDataTask* dataTask;
    
    if (btn.tag == 20001) {
        
        [_alertCon dismissViewControllerAnimated:YES completion:^{
           
            if (dataTask) { [dataTask cancel];  }
        }];
        
        [SVProgressHUD dismiss];
    } else {

        if (_alertCon.textView.text.length <= 0) {

            [SVProgressHUD showErrorWithStatus:@"内容为空"];
            [SVProgressHUD dismissWithDelay:1.5f];
            return;
        }
    
        [SVProgressHUD show];

        AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
        NSDictionary* parameters = @{
                                     @"token"  :[CCitySingleton sharedInstance].token,
                                     @"workId" :_docId[@"workId"],
                                     @"fkNode" :_docId[@"fkNode"],
                                     @"content":_alertCon.textView.text
                                     };
        
        dataTask = [manager GET:@"service/form/SignOpinion.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [SVProgressHUD dismiss];

            if ([responseObject[@"status"] isEqualToString:@"failed"]) {
                
                [SVProgressHUD showErrorWithStatus:@"发送失败"];
                [SVProgressHUD dismissWithDelay:1.5f];
            } else {
                
                [_alertCon dismissViewControllerAnimated:NO completion:^{
                    
                      [TSMessage showNotificationWithTitle:@"发送成功" type:TSMessageNotificationTypeSuccess];
                }];
                
                CCityOfficalDocDetailModel* detailModel = self.dataArr[_currentHuiqianCellIndexPath.section];
                CCityOfficalDocDetailCell* cell = [self.tableView cellForRowAtIndexPath:_currentHuiqianCellIndexPath];
                
                for (int i = 0; i < detailModel.huiqianContentsMuArr.count; i++) {
                    
                    CCHuiQianModel* model = detailModel.huiqianContentsMuArr[i];
                    if ([model.personName isEqualToString:[CCitySingleton sharedInstance].userName]) {
                        model.opinio = _alertCon.textView.text;
                        
                        [cell.huiqianTableView beginUpdates];
                        [cell.huiqianTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        [cell.huiqianTableView endUpdates];
                        [cell.huiqianTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                        return;
                    }
                }
                CCHuiQianModel* model = [[CCHuiQianModel alloc]initWithPerosn:[CCitySingleton sharedInstance].userName opinio:_alertCon.textView.text];
                
                [detailModel.huiqianContentsMuArr addObject:model];
                
                [cell.huiqianTableView beginUpdates];
                [cell.huiqianTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:detailModel.huiqianContentsMuArr.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [cell.huiqianTableView endUpdates];
                [cell.huiqianTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:detailModel.huiqianContentsMuArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [SVProgressHUD dismiss];

            if (CCITY_DEBUG) {  NSLog(@"%@",error); }

            if (error.code != -999) {
                
                 [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                 [SVProgressHUD dismissWithDelay:1.5f];
            }
        }];
    }
}

// save
- (void) saveAction {
    
    if (!_valuesDic) {
        
        [SVProgressHUD showInfoWithStatus:@"数据未改变，无需保存"];
        return;
    }
    
    [SVProgressHUD show];
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    
    NSDictionary* datasDic = [NSDictionary dictionaryWithObject:_valuesDic forKey:@"root"];
    NSData* valuseData = [NSJSONSerialization dataWithJSONObject:datasDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString* valuesStr = [[NSString alloc]initWithData:valuseData encoding:NSUTF8StringEncoding];
    [parameters addEntriesFromDictionary:_docId];
    [parameters setObject:valuesStr forKey:@"formSaveStr"];
    [parameters setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:@"service/form/Save.ashx" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        if ([responseObject[@"status"] isEqual:@"success"]) {
            
            [CCityAlterManager showSimpleTripsWithVC:self Str:@"保存成功" detail:nil];
        }
        
        if (CCITY_DEBUG) {
            
            NSLog(@"%@",responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [CCityAlterManager showSimpleTripsWithVC:self Str:error.localizedDescription detail:nil];
        
        NSLog(@"%@",error);
    }];
}

- (void)configDataWithId:(NSDictionary*)docId {
    
    [SVProgressHUD show];
    
    AFHTTPSessionManager* manager = [CCityJSONNetWorkManager sessionManager];
    NSMutableDictionary* parameters = [docId mutableCopy];
    [parameters setObject:[CCitySingleton sharedInstance].token forKey:@"token"];
    
    if (!_url) {    _url =@"service/form/FormDetail.ashx";  }
    
    [manager GET:_url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",task.currentRequest.URL.absoluteString);
        
        [SVProgressHUD dismiss];

        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            NSLog(@"%@",responseObject);
            
        } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            if (_conentMode == CCityOfficalDocBackLogMode) {
                
                if (responseObject[@"isEnd"] != NULL) {
                    
                    self.isEnd = [responseObject[@"isEnd"] boolValue];
                }
            }

            
            if ([responseObject[@"status"] isEqualToString:@"failed"]) {
                
                [CCityAlterManager showSimpleTripsWithVC:self Str:@"数据获取失败" detail:nil];
                return;
            }
            
            if (!_docId[@"fk_flow"]) {
                _docId[@"fk_flow"] = responseObject[@"fkFlow"];
            }
            
            if (!_docId[@"workId"]) {
                _docId[@"workId"] = responseObject[@"workId"];
            }
            
            if (!_docId[@"fId"]) {
                 _docId[@"fId"] = responseObject[@"fid"];
            }
            if (!_docId[@"fkNode"]) {
                _docId[@"fkNode"] = responseObject[@"fkNode"];
            }
            
            NSArray*   resultArr = responseObject[@"form"];
            
            if (!self.dataArr) {
                
                self.dataArr = [NSMutableArray arrayWithCapacity:resultArr.count];
            }
            
            BOOL isContentHuiQian = NO;
            
            for (int i = 0 ; i < resultArr.count; i++) {
                
                CCityOfficalDocDetailModel* model = [[CCityOfficalDocDetailModel alloc]initWithDic:resultArr[i]];
                
                if (_conentMode != CCityOfficalDocBackLogMode) {
                    
                    if (model.canEdit) {    model.canEdit = NO; }
                } else {
                    
                    if (model.style == CCityOfficalDetailHuiQianOpinionStyle) {
                        isContentHuiQian = YES;
                        _currentHuiqianCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                    }
                }
                
                [self.dataArr addObject:model];
            }
            
             [self updataFootViewWithContentHuiQian:isContentHuiQian];
        } else {
            
            [CCityAlterManager showSimpleTripsWithVC:self Str:@"提示" detail:@"服务器返回数据格式不合法，无法解析"];
            return;
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        NSLog(@"%@",error);
    }];
}

-(void)sendOpinio {
    
    AFHTTPSessionManager* mananger = [CCityJSONNetWorkManager sessionManager];
    
    [mananger POST:@"ervice/form/ReplyOpinion.ashx" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [TSMessage showNotificationWithTitle:error.localizedDescription type:TSMessageNotificationTypeError];
        
        NSLog(@"%@",error);
    }];
}

#pragma mark- --- keyboard notfic

// keyboard will show
- (void)keyboardWillShow:(NSNotification*)notification {
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, keyboardFrame.size.height, 0);
    
    CGRect visibleFrame = _editCellFrame;
    visibleFrame.origin.y = visibleFrame.origin.y - 50;
    [self.tableView scrollRectToVisible:visibleFrame animated:NO];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top, 0, 0, 0);
}

#pragma mark- --- UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    CCityOfficalDocDetailModel* model = self.dataArr[section];
    
    if (model.style == CCityOfficalDetailNormalStyle) {
        
        return model.sectionHeight;
    }
    
    return 44.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CCityOfficalDocDetailModel* model = self.dataArr[section];

    CCityOfficalDetailSectionView* sectionView = [[CCityOfficalDetailSectionView alloc]initWithStyle:model.style];
    
    sectionView.sectionNum = section;
    [sectionView addTarget:self action:@selector(sectionViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    sectionView.backgroundColor = [UIColor whiteColor];
    sectionView.model = model;
    
    return sectionView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    CCityOfficalDocDetailModel* model = self.dataArr[section];
    
    if (model.hasCell) {    return 1;   }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCityOfficalDocDetailModel* model = self.dataArr[indexPath.section];
    CCityOfficalDocDetailCell* cell   = [[CCityOfficalDocDetailCell alloc]initWithStyle:model.style];
    
    cell.model    = model;
    
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark- --- personListVC delegate
-(void)viewControllerDismissActoin {
    
    if (self.sendActionSuccessed) {
        
        self.sendActionSuccessed(_indexPath);
    }
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.dataArr.count) {  return; }
    
    [self hiddenKeyboard];
}

#pragma mark- --- tableViewCell delegate

-(void)textViewWillEditingWithCell:(CCityOfficalDocDetailCell*)cell {
 
    _editCellFrame = cell.frame;
}

-(void)textViewTextDidChange:(CCityOfficalDocDetailCell *)cell {
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    CCityOfficalDocDetailModel* model = self.dataArr[indexPath.section];
    model.value = cell.textView.text;
}

// 文本编辑结束时 调用
-(void)textViewDidEndEditingWithCell:(CCityOfficalDocDetailCell*)cell {
    
//    得到编辑的 cell
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    _editCellFrame = CGRectZero;
    [self saveMethodWithIndex:indexPath.section andText:cell.textView.text];
}

@end
