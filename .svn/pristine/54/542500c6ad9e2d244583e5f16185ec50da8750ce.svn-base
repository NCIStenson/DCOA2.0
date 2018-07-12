//
//  CCityOfficalDocDetailCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/4.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define ADVIVIC_PLACE_HOLDER @"请给出您的意见"

#import "CCityOfficalDocDetailCell.h"

static NSString* cellReuseId = @"cellReuseId";

@implementation CCityOfficalDocDetailCell {
    
    CCityOfficalDetailSectionStyle _sectionStyle;
}

- (instancetype)initWithStyle:(CCityOfficalDetailSectionStyle) style 
{
    self = [super init];
    if (self) {
        
        _sectionStyle = style;
        [self layoutMySubViews];
    }
    return self;
}

#pragma mark- ---  setter

-(void)setModel:(CCityOfficalDocDetailModel *)model {
    _model = model;
    
    _textView.editable            = model.canEdit;

    if (model.canEdit == NO) {
        
        _textView.backgroundColor = CCITY_RGB_COLOR(232, 232, 232, 1.f);
    }
    
    if (_huiqianTableView) {    [_huiqianTableView removeFromSuperview];    }
    
    if (_model.style == CCityOfficalDetailHuiQianOpinionStyle) {
        
        [_textView removeFromSuperview];
        
        _huiqianTableView = [UITableView new];
        _huiqianTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1, .1)];
        _huiqianTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, .1, .1)];
        _huiqianTableView.delegate = self;
        _huiqianTableView.dataSource = self;
        _huiqianTableView.clipsToBounds = YES;
        _huiqianTableView.layer.cornerRadius = 5.f;
        _huiqianTableView.backgroundColor = CCITY_RGB_COLOR(251,252,253, 1.f);
        
        _huiqianTableView.estimatedRowHeight = 44.0;
        _huiqianTableView.rowHeight = UITableViewAutomaticDimension;
        _huiqianTableView.layer.borderColor = CCITY_RGB_COLOR(225, 225, 225, 1).CGColor;
        _huiqianTableView.layer.borderWidth = 1.f;
        [self.contentView addSubview:_huiqianTableView];
        
        [_huiqianTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(0.f);
            make.left.equalTo(self.contentView).with.offset(10.f);
            make.bottom.equalTo(self.contentView).with.offset(-10.f);
            make.right.equalTo(self.contentView).with.offset(-10.f);
        }];
        
    } else {
        
        if (![model.value isEqualToString:@""]) {
            
            _textView.text                = model.value;
        }
    }
}

#pragma mark- --- layout subviews
-(void)layoutMySubViews {
        
    _textView = [UITextView new];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:[UIFont systemFontSize] - 1];
    _textView.clipsToBounds = YES;
    _textView.layer.cornerRadius = 5.f;
    _textView.backgroundColor = CCITY_RGB_COLOR(251,252,253, 1.f);
    _textView.layer.borderColor = CCITY_RGB_COLOR(225, 225, 225, 1).CGColor;
    _textView.layer.borderWidth = 1.f;
    
    if (_sectionStyle == CCityOfficalDetailOpinionStyle) {
    
        _textView.attributedText = [self getAttributeStrWithText:ADVIVIC_PLACE_HOLDER];
    }
    
    [self.contentView addSubview:_textView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(0.f);
        make.left.equalTo(self.contentView).with.offset(10.f);
        make.bottom.equalTo(self.contentView).with.offset(-10.f);
        make.right.equalTo(self.contentView).with.offset(-10.f);
    }];
}

#pragma mark- --- methods

- (BOOL)checkTextWithText:(NSString*)text {
    
    if ([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        
        return NO;
    }
    
    return YES;
}

- (NSAttributedString*) getAttributeStrWithText:(NSString*)text {
    
    NSAttributedString* attStr = [[NSAttributedString alloc]initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    return attStr;
}

#pragma mark- --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _model.huiqianContentsMuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseId];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseId];
        cell.textLabel.font = [UIFont systemFontOfSize:13.f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    CCHuiQianModel* model = _model.huiqianContentsMuArr[indexPath.row];
    cell.textLabel.text = model.personName;
    cell.detailTextLabel.text =  model.opinio;
   
    return cell;
}

- (CGFloat)rowHeightWithIndex:(NSIndexPath*)indexPath {
    
    CCHuiQianModel* model = _model.huiqianContentsMuArr[indexPath.row];
    
    UILabel* label = [UILabel new];
    
    label.font = [UIFont systemFontOfSize:12.f];
    label.numberOfLines = 0;
    label.text = model.opinio;
    label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 50.f, MAXFLOAT);
    [label sizeToFit];
    
    if (label.bounds.size.height > 14.5) {
        return 44 + label.bounds.size.height - 14.5;
    } else {
        return 44.f;
    }
}

#pragma mark- --- UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"%@",NSStringFromCGRect(cell.frame));
    NSLog(@"%@",NSStringFromCGRect(cell.detailTextLabel.frame));
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [self rowHeightWithIndex:indexPath];
}

#pragma mark- --- uitextview delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewWillEditingWithCell:)]) {
        
        [self.delegate textViewWillEditingWithCell:self];
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:ADVIVIC_PLACE_HOLDER]) {
        
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewDidEndEditingWithCell:)]) {
        
        [self.delegate textViewDidEndEditingWithCell:self];
    }
    
    if (_sectionStyle == CCityOfficalDetailOpinionStyle) {
        
        if (![self checkTextWithText:textView.text]) {
            
            textView.attributedText = [self getAttributeStrWithText:ADVIVIC_PLACE_HOLDER];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(textViewTextDidChange:)]) {
        
        [self.delegate textViewTextDidChange:self];
    }
}

@end
