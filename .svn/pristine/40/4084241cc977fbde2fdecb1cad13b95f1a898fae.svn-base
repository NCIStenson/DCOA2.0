
//
//  CCityMainTasekSearchResultCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/9/11.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define CCITY_X_PADDING 5.f
#define CCITY_IMAGE_PADDING 7.f
#define CCITY_IMAGE_SIZE CGSizeMake(32.f, 32.f)
#import "CCityMainTasekSearchResultCell.h"

@implementation CCityMainTasekSearchResultCell {
    
    UILabel* _proNameLabel;
    UILabel* _proNumLabel;
    UILabel* _proTypeLabel;
    UILabel* _registeTimeLabel;
}

-(void)setModel:(CCityMainSearchTaskModel *)model {

    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_main_task_search_result_50x50_"]];
    
    _proNameLabel = [self myTitleLabel];
    
    _proNumLabel = [self myDetailLabel];
    
    _proTypeLabel = [self myDetailLabel];
    
    _registeTimeLabel = [self myDetailLabel];
    
    _proNameLabel.text = model.proName;
    _proTypeLabel.text = model.proType;
    _proNumLabel.text = model.proNum;
    _registeTimeLabel.text = model.registeTime;
    
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:_proNameLabel];
    [self.contentView addSubview:_proNumLabel];
    [self.contentView addSubview:_proTypeLabel];
    [self.contentView addSubview:_registeTimeLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).with.offset(CCITY_IMAGE_PADDING);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CCITY_IMAGE_SIZE);
    }];
    
    [_proNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(5.f);
        make.left.equalTo(imageView.mas_right).with.offset(CCITY_X_PADDING);
        make.right.equalTo(self.contentView).with.offset(-CCITY_X_PADDING);
        make.bottom.equalTo(_proNumLabel.mas_top).with.offset(-5.f);
    }];
    
    [_proNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_proNameLabel.mas_bottom).with.offset(CCITY_X_PADDING);
        make.left.equalTo(_proNameLabel);
        make.right.equalTo(_registeTimeLabel.mas_left).with.offset(-CCITY_X_PADDING);
        make.bottom.equalTo(_proTypeLabel.mas_top).with.offset(-5.f);
    }];
    
    [_proTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_proNumLabel.mas_bottom).with.offset(5.f);
        make.left.equalTo(_proNameLabel);
        make.bottom.equalTo(self.contentView).with.offset(-5.f);
        make.right.equalTo(_proNameLabel);
    }];
    
    [_registeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_proNumLabel);
//        make.left.equalTo(_proNumLabel.mas_right).with.offset(CCITY_X_PADDING);
        make.bottom.equalTo(_proNumLabel);
        make.right.equalTo(self.contentView).with.offset(-CCITY_X_PADDING);
        make.width.mas_equalTo(80.f);
    }];
}

-(UILabel*)myTitleLabel {
    
    UILabel* myTitleLabel = [[UILabel alloc]init];
    myTitleLabel.numberOfLines = 1;
    myTitleLabel.font = [UIFont systemFontOfSize:15.f];
    myTitleLabel.textColor = CCITY_MAIN_FONT_COLOR;
    return myTitleLabel;
}

-(UILabel*)myDetailLabel {
    
    UILabel* myDetailLabel = [[UILabel alloc]init];
    myDetailLabel.numberOfLines = 1;
    myDetailLabel.textColor = CCITY_GRAY_TEXTCOLOR;
    myDetailLabel.font = [UIFont systemFontOfSize:13.f];
    return myDetailLabel;
}

-(CGFloat)getHeightWithModel:(CCityMainSearchTaskModel* )model {
    
    CGFloat height = 15.f;
    
    UILabel* label = [self myTitleLabel];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width - self.indentationWidth - 30;
    CGFloat titleWith = (screenWidth - CCITY_IMAGE_SIZE.width - CCITY_IMAGE_PADDING - 2*CCITY_X_PADDING)/2;
    
    label.text = model.proName;
    label.frame = CGRectMake(0, 0, titleWith, MAXFLOAT);
    CGFloat proNameHeight = [self getlabelHeightWithLabel:label];
    
    label.text = model.proNum;
    label.frame = CGRectMake(0, 0, titleWith, MAXFLOAT);
    CGFloat proNumHeight = [self getlabelHeightWithLabel:label];
    
    label = [self myDetailLabel];
    label.text = model.proType;
    label.frame = CGRectMake(0, 0, screenWidth - CCITY_IMAGE_SIZE.width - CCITY_IMAGE_PADDING - 80.f - 3* CCITY_X_PADDING, MAXFLOAT);
    CGFloat proTypeHeiht = [self getlabelHeightWithLabel:label];
    
    if (proNumHeight > proNameHeight) {
        
        height+= proNumHeight;
    } else {
        
        height += proNameHeight;
    }
    
    height += proTypeHeiht;
    return height;
}

-(CGFloat)getlabelHeightWithLabel:(UILabel*)label{
    
    [label sizeToFit];
    return label.frame.size.height;
}

@end
