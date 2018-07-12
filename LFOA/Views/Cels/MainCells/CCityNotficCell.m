//
//  CCityNotficCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/13.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_SPACING 5.f

#import "CCityNotficCell.h"

@implementation CCityNotficCell

-(void)setModel:(CCityNotficModel *)model {
    _model = model;
    
    UIImageView* huarryImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_ji_20x20_"]];
    
    UIImageView* haveFilesImageView;
    
    if (model.isHeightLevel == NO) {    huarryImageView.hidden = YES;   }
    
    UILabel* fromLabel = [UILabel new];
    fromLabel.text = model.notficFromName;
    
    UILabel* timeLabel = [self detailsLabel];
    timeLabel.text = model.notficPostTime;
    
    UILabel* nameLabel = [self nameLabel];
    nameLabel.text = model.notficTitle;
    
    UILabel* contentLabel = [self detailsLabel];
    contentLabel.text = model.notficContent;
    
    [self.contentView addSubview:huarryImageView];
    [self.contentView addSubview:fromLabel];
    [self.contentView addSubview:timeLabel];
    [self.contentView addSubview:nameLabel];
    [self.contentView addSubview:contentLabel];
    
    if (model.isHaveFile) {
        haveFilesImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_accessonary_30x30_"]];
        
        [self.contentView addSubview:haveFilesImageView];
        
        [haveFilesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(timeLabel.mas_bottom).with.offset(5.f);
            make.right.equalTo(self.contentView).with.offset(-10.f);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
    }
    
    [huarryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(8.f);
        make.left.equalTo(self.contentView).with.offset(10.f);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(10.f);
        make.left.equalTo(huarryImageView.mas_right).with.offset(CCITY_SPACING);
        make.right.equalTo(timeLabel.mas_left).with.offset(-CCITY_SPACING);
        make.bottom.equalTo(nameLabel.mas_top).with.offset(-CCITY_SPACING);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(fromLabel);
        make.right.equalTo(self.contentView).with.offset(-10.f);
        make.bottom.equalTo(fromLabel);
        make.width.mas_equalTo(80.f);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(fromLabel.mas_bottom).with.offset(CCITY_SPACING);
        make.left.equalTo(fromLabel);
        make.bottom.equalTo(contentLabel.mas_top).with.offset(-CCITY_SPACING);
        
        if (haveFilesImageView) {
            
            make.right.equalTo(haveFilesImageView.mas_left).with.offset(-CCITY_SPACING);
        } else {
            
            make.right.equalTo(self.contentView).with.offset(-CCITY_SPACING);
        }
    }];
    
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(nameLabel.mas_bottom).with.offset(CCITY_SPACING);
        make.left.equalTo(fromLabel);
        make.bottom.equalTo(self.contentView).with.offset(-CCITY_SPACING);
        make.right.equalTo(self.contentView).with.offset(-10.f);
    }];
}

-(UILabel*)detailsLabel {
    
    UILabel* detailsLabel = [UILabel new];
    detailsLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    detailsLabel.font = [UIFont systemFontOfSize:13.f];
    return detailsLabel;
}

-(UILabel*)nameLabel {
    
    UILabel* detailsLabel = [UILabel new];
    detailsLabel.font = [UIFont systemFontOfSize:15.f];
    return detailsLabel;
}

@end
