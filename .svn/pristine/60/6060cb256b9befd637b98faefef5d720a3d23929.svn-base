//
//  CCityOfficalDocDetailVC.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/3.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseTableViewVC.h"
#import "CCityOfficalDetailMenuVC.h"

@interface CCityOfficalDocDetailVC : CCityBaseTableViewVC

@property(nonatomic, copy)void (^sendActionSuccessed)(NSIndexPath* indexPath);

@property(nonatomic, assign)CCityOfficalMainStyle      mainStyle;
@property(nonatomic, assign)CCityOfficalDocContentMode conentMode;
@property(nonatomic, strong)NSIndexPath*               indexPath;

@property(nonatomic, strong)NSString* url;
@property(nonatomic, assign)BOOL      isEnd;

@property(nonatomic, copy)void(^reloadData)(void);

-(instancetype)initWithItmes:(NSArray *)items Id:(NSDictionary*)docId contentModel:(CCityOfficalDocContentMode)contentMode;

@end
