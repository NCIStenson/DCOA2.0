
//
//  CCityOfficalDocModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/2.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDocModel.h"

@implementation CCityOfficalDocModel

- (instancetype)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
        _mainStyle = CCityOfficalMainSPStyle;
        [self configDataWithDic:dic];
    }
    return self;
}

- (void)configDataWithDic:(NSDictionary*)dic {
    
    _docId = @{@"workId" :dic[@"workid"],
               @"formId" :dic[@"formid"],
               @"fId"    :dic[@"fid"],
               @"fkNode" :dic[@"fk_node"],
               @"fk_flow":dic[@"fk_flow"],
               @"fkFlow" :dic[@"fk_flow"],
               };
    
    _isRead = [dic[@"isread"] boolValue];
    _docTitle = dic[@"projectname"];
    _docDate = [self conerDateStrWithStr:dic[@"rdt"]];
    
    if (dic[@"datet"]) {
        _surplusDays = dic[@"datet"];
    }
    
    if (dic[@"flowname"]) {
        
        _messagetype = dic[@"flowname"];
    }
    
    if (dic[@"projectno"]) {
        
        _docNumber = dic[@"projectno"];
    } else {
        
        if (dic[@"cyr"]) {
            
            _docNumber = [NSString stringWithFormat:@"传阅人：%@",dic[@"cyr"]];
        }
    }
}

-(NSString*)conerDateStrWithStr:(NSString*)dateStr {
        
    NSArray* dateArr = [dateStr componentsSeparatedByString:@" "];
    NSString* years = [dateArr firstObject];
    NSArray* yearsArr = [years componentsSeparatedByString:@"-"];
    
    dateStr = @"";
    
    for (int i = 0; i < yearsArr.count; i++) {
        
        NSString* date;
        if (i == yearsArr.count - 1) {
            
            date = yearsArr[i];
        } else {
            
            date = [NSString stringWithFormat:@"%@/",yearsArr[i]];
        }
        
        dateStr = [dateStr stringByAppendingString:date];
    }
    dateStr = [dateStr stringByAppendingString:[NSString stringWithFormat:@" %@", [dateArr lastObject]]];
    
    return dateStr;
}

@end
