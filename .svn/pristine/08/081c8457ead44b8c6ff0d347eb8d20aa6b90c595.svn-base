//
//  CCityOfficalDocDetailCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/4.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

@class CCityOfficalDocDetailCell;

@protocol CCityOfficalDocDetailDelegate <NSObject>

-(void)textViewWillEditingWithCell:(CCityOfficalDocDetailCell*)cell;
-(void)textViewDidEndEditingWithCell:(CCityOfficalDocDetailCell*)cell;
-(void)textViewTextDidChange:(CCityOfficalDocDetailCell*)cell;

@end

#import <UIKit/UIKit.h>
#import "CCityOfficalDocDetailModel.h"

@interface CCityOfficalDocDetailCell : UITableViewCell<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITextView* textView;
@property(nonatomic, strong)CCityOfficalDocDetailModel* model;
@property(nonatomic, strong)UITableView* huiqianTableView;
@property(nonatomic, weak)id<CCityOfficalDocDetailDelegate> delegate;

- (instancetype)initWithStyle:(CCityOfficalDetailSectionStyle) style;

@end
