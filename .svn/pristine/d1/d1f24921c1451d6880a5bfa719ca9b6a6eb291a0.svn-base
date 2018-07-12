//
//  CCityMainDocSearchModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityMainDocSearchModel.h"

@implementation CCityMainDocsearchDetailModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super initWithDic:dic];
    
    if (self) {
        
        _isOpen = NO;
        
        _name   = dic[@"fgmc"];
        _time   = [self fromatTimeWithTime:dic[@"fxsj"]];
        _from   = dic[@"fxjg"];
        _info   = dic[@"info"];
        _number = dic[@"fgbh"];
        
        NSArray* children = dic[@"children"];
        
        if (children.count) {
            
            NSDictionary* accessoryDic = children[0];
            
            _accessoryName = accessoryDic[@"name"];
            _accessoryUrl  = accessoryDic[@"path"];
            _accessorySize = accessoryDic[@"size"];
        }
    }
    
    return self;
}

-(NSString*)fromatTimeWithTime:(NSString*)time {
    
    NSArray* times = [time componentsSeparatedByString:@" "];
    return times[0];
}


@end

@implementation CCityMainDocSearchModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super initWithDic:dic];
    
    if (self) {
        
        _type = dic[@"fglb"];
        _children = [NSMutableArray array];
    }
    
    return self;
}


@end
