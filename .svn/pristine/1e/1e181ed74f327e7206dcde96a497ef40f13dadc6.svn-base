//
//  CCityMainMeetingCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/21.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_MEETING_CELL_PADDING 5.f

#import "CCityMainMeetingCell.h"

@implementation CCityMainMeetingCell

-(void)setModel:(CCityMainMeetingListModel *)model {
    _model = model;
    
    UILabel* titleLabel = [self titleLabel];
    titleLabel.text = model.meetingTitle;
    
    UILabel* numLabel = [self detailLabel];
    numLabel.text = model.meetingNum;
    
    UILabel* timeLabel = [self detailLabel];
    timeLabel.text = model.meetingTime;
    
    UILabel* placeLabel = [self detailLabel];
    placeLabel.text = model.meetingPlace;
    
    UIImageView* accessoryImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_accessonary_30x30_"]];
    
    if (model.hasFile == NO) {
        
        accessoryImageView.hidden = YES;
    }
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:numLabel];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:accessoryImageView];
    [self.contentView addSubview:placeLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.contentView).with.offset(CCITY_MEETING_CELL_PADDING);
        make.left.equalTo(self.contentView).with.offset(2*CCITY_MEETING_CELL_PADDING);
        make.bottom.equalTo(numLabel.mas_top).with.offset(-5.f);
        make.right.equalTo(self.contentView).with.offset(-CCITY_MEETING_CELL_PADDING);
    }];
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(titleLabel.mas_bottom).with.offset(CCITY_MEETING_CELL_PADDING);
        make.left.equalTo(titleLabel);
        make.right.equalTo(timeLabel.mas_left).with.offset(-CCITY_MEETING_CELL_PADDING);
        make.bottom.equalTo(placeLabel.mas_top).with.offset(-CCITY_MEETING_CELL_PADDING);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(numLabel);
        make.left.equalTo(numLabel.mas_right).with.offset(CCITY_MEETING_CELL_PADDING);
        make.bottom.equalTo(numLabel);
        make.right.equalTo(accessoryImageView.mas_left).with.offset(-CCITY_MEETING_CELL_PADDING);
        make.width.mas_equalTo(120.f);
    }];
    
    [accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(titleLabel.mas_bottom);
        make.right.equalTo(titleLabel);
        make.bottom.equalTo(timeLabel);
        make.width.equalTo(accessoryImageView.mas_height);
    }];
    
    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(numLabel.mas_bottom).with.offset(CCITY_MEETING_CELL_PADDING);
        make.left.equalTo(titleLabel);
        make.bottom.equalTo(self.contentView).with.offset(-CCITY_MEETING_CELL_PADDING);
        make.right.equalTo(titleLabel);
    }];
    
}

-(UILabel*)titleLabel {
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    
    return titleLabel;
}

-(UILabel*)detailLabel {
    
    UILabel* detailLabel = [UILabel new];
    detailLabel.font = [UIFont systemFontOfSize:13.f];
    detailLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    
    return detailLabel;
}

@end
