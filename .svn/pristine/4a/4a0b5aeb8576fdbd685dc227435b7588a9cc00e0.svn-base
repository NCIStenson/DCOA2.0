//
//  CCityOfficalDocDetailModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDocDetailModel.h"

@implementation CCHuiQianModel

- (instancetype)initWithPerosn:(NSString*)personName opinio:(NSString*)opinio
{
    self = [super init];
    
    if (self) {
        
        _personName = personName;
        _opinio     = opinio;
    }
    
    return self;
}

@end

@implementation CCityOfficalDocDetailModel

- (instancetype)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
        _isOpen = YES;
        [self configDataWithDic:dic];
    }
    return self;
}

-(void)configDataWithDic:(NSDictionary*)dic {
        
    _dataType = dic[@"DataType"];
    _canEdit  = ![dic[@"ReadOnly"] boolValue];
    _table    = dic[@"Table"];
    
    if (dic[@"Label"] == [NSNull null]) {   _title = @"空";  }
    else    {  _title  = dic[@"Label"]; }
    
    if (dic[@"Value"] == [NSNull null]) {   _value = @"";   }
    else {  _value = dic[@"Value"]; }

    NSString* contentType = dic[@"ControlType"];
    
    if ([contentType isEqual:@"文本框"]) {
        
        if ([dic[@"MultiLine"] boolValue]) {
           
            _style = CCityOfficalDetailMutableLineTextStyle;
            if ([dic[@"TextType"] isEqual:@"意见"]) {
                
                _style = CCityOfficalDetailOpinionStyle;
            }
            
            _isOpen  = YES;
            _hasCell = YES;
        } else if (_canEdit) { _style = CCityOfficalDetailSimpleLineTextStyle; }
        
        else { _style = CCityOfficalDetailNormalStyle; }
        
    } else if ([contentType isEqual:@"日期框"]) {
        
        _style = CCityOfficalDetailDateStyle;
        NSString* dataStr = dic[@"Value"];
        _value = [[dataStr componentsSeparatedByString:@" "] firstObject];
    } else if ([contentType isEqual:@"下拉框"]) {
        
        _style = CCityOfficalDetailContentSwitchStyle;
        NSDictionary* values = dic[@"ControlDataSource"];
        _switchContentArr = values.allValues;
    } else if ([contentType isEqual:@"数据网格"]) {
        
        if ((dic[@"TextType"] != NULL) && [dic[@"TextType"] isEqualToString:@"会签"]) {
            
            _style = CCityOfficalDetailHuiQianOpinionStyle;
            _canEdit = NO;
            _hasCell = YES;
            
            NSArray* keys;
            NSArray* columnsArr = dic[@"Columns"];
            
            NSDictionary* personNameDic;
            NSDictionary* opinoDic;
            
            for (NSDictionary* huiqianDic in columnsArr) {
                
                if ([huiqianDic[@"Label"] isEqualToString:@"签字意见"]) {
                    
                    opinoDic = huiqianDic[@"Values"];
                    keys = opinoDic.allKeys;
                } else {
                    
                    personNameDic = huiqianDic[@"Values"];
                }
            }
            
            if (keys) {
                
                _huiqianContentsMuArr = [NSMutableArray arrayWithCapacity:keys.count];
            }
            
            for (NSString* key in keys) {
                
                CCHuiQianModel* huiqianModel = [[CCHuiQianModel alloc]initWithPerosn:personNameDic[key] opinio:opinoDic[key]];
                [_huiqianContentsMuArr addObject:huiqianModel];
            }
        }
    }
    
    if (!(dic[@"Field"] == [NSNull null])) {    _field = dic[@"Field"]; }
   
    _titleLabelSize = [self getTitleSizeWithStr:_title];
    _sectionHeight = [self getSectionHeightWithStr:_value];
}

- (CGSize)getTitleSizeWithStr:(NSString*)str {
    
    UILabel* label = [UILabel new];
    label.numberOfLines =0;
    label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    label.text = str;
    label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, MAXFLOAT);
    
    [label sizeToFit];
    
    if (label.frame.size.height < 34) {
        
        return CGSizeMake(label.frame.size.width, 34.f);
    }
    
    return label.frame.size;
}

-(CGFloat)getSectionHeightWithStr:(NSString*)str {
    
    if (self.style == CCityOfficalDetailOpinionStyle || self.style == CCityOfficalDetailMutableLineTextStyle || self.style == CCityOfficalDetailHuiQianOpinionStyle) { return 44.f;    }
    
    UILabel* label = [UILabel new];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]-1];
    label.text = str;
    
    if (_titleLabelSize.width < ([UIScreen mainScreen].bounds.size.width - 20)*2 / 3) {
        
        label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - _titleLabelSize.width - 20 - 20, MAXFLOAT);
         [label sizeToFit];
    } else {
        
         label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, MAXFLOAT);
         [label sizeToFit];
        
        return 25 + _titleLabelSize.height + label.frame.size.height;
    }
    
    if (label.frame.size.height > 34) {
        
        return label.frame.size.height + 10;
    }
    
    return 44;
}

@end
