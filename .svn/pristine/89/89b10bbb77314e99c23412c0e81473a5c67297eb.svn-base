//
//  CCityNewsListCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/22.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityNewsListCell.h"

@implementation CCityNewsListCell

-(void)setModel:(CCityNewsModel *)model {
    _model = model;
    
    UILabel* titleLabel = [self titleLabel];
    titleLabel.text = model.title;
    
    UILabel* typeLabel = [self titleLabel];
    typeLabel.textColor = CCITY_MAIN_COLOR;
    typeLabel.text = [NSString stringWithFormat:@"[%@]", model.type];
    
    UILabel* timeLabel = [self detailLabel];
    timeLabel.text = model.time;
    
    UILabel* briefLabel = [self detailLabel];
    briefLabel.text = model.brief;
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:typeLabel];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:briefLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(5.f);
        make.left.equalTo(self.contentView).with.offset(10.0f);
        make.right.equalTo(self.contentView).with.offset(-5.0f);
        make.bottom.equalTo(typeLabel.mas_top).with.offset(-5.f);
    }];
    
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(titleLabel.mas_bottom).with.offset(5.f);
        make.left.equalTo(titleLabel);
        make.right.equalTo(timeLabel.mas_left).with.offset(5.f);
        make.bottom.equalTo(briefLabel.mas_top).with.offset(-5.f);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(typeLabel);
        make.bottom.equalTo(typeLabel);
        make.right.equalTo(titleLabel);
        make.width.mas_equalTo(95.f);
    }];
    
    [briefLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(typeLabel.mas_bottom).with.offset(5.f);
        make.left.equalTo(titleLabel);
        make.bottom.equalTo(self.contentView).with.offset(-5.f);
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
