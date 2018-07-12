//
//  CCityOffialSendPersonListModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/12.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOffialSendPersonListModel.h"

@implementation CCityOfficalSendPersonDetailModel

- (instancetype)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
        [self configDataWithDic:dic];
    }
    return self;
}

- (void) configDataWithDic:(NSDictionary*)dic {

    NSArray* childrenArr = dic[@"children"];
    
    NSDictionary* childrenDic = childrenArr[0];
    _personId = childrenDic[@"id"];
    _name     = childrenDic[@"text"];
}

@end


@implementation CCityOffialSendPersonListModel

- (instancetype)initWithDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
        [self configDataWithDic:dic];
    }
    return self;
}

- (void) configDataWithDic:(NSDictionary*)dic {
    
    _isOpen = YES;
    _groupTitle = dic[@"name"];
    _fkNode = [NSString stringWithFormat:@"%@",dic[@"toNode"]];
    
    NSArray* organization = dic[@"organization"];
    NSDictionary* organizDic = organization[0];
            
    NSArray* persons = organizDic[@"children"];
    
    _groupItmes = [NSMutableArray arrayWithCapacity:persons.count];
    
    for (int i = 0; i < persons.count; i++) {
        
        CCityOfficalSendPersonDetailModel* detailModel = [[CCityOfficalSendPersonDetailModel alloc]initWithDic:persons[i]];
        [_groupItmes addObject:detailModel];
    }
    
}

@end
