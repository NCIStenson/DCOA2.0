//
//  CCityMainMeetingListModel.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/21.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityMainMeetingListModel.h"

@implementation CCityMainMeetingListModel

-(instancetype)initWithDic:(NSDictionary *)dic {
    self = [super initWithDic:dic];
    
    if (self) {
        
        _meetingTitle    = dic[@"hymc"];
        _meetingTime     = dic[@"hysj"];
        _meetingNum      = dic[@"hybh"];
        _meetingPlace    = dic[@"hydd"];
        _meetingType     = dic[@"hylx"];
        _meetingMembers  = dic[@"hyry"];
        _meetingSponsor  = dic[@"zzbm"];
        _sponsoredUnit   = dic[@"zzdw"];
        _meetingRecorder = dic[@"jlr"];
        _meetingCJYR     = dic[@"cjyr"];
        _meetingChecker  = dic [@"kqr"];
        _compere         = dic[@"hyzcr"];
        _content         = dic[@"hynr"];
        _accessoryFiles  = dic[@"children"];
        
        _hasFile         = _accessoryFiles.count;
    }
    
    return self;
}

@end
