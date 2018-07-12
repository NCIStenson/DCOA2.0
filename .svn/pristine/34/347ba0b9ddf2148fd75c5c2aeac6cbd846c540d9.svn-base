

//
//  CCityOfficalDetailPersonListCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/12.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityOfficalDetailPersonListCell.h"

@implementation CCityOfficalDetailPersonListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = CCITY_MAIN_BGCOLOR;
    }
    return self;
}

-(void)setModel:(CCityOfficalSendPersonDetailModel *)model {
    _model = model;
    
    _checkBox = [self myCheckBox];
    _checkBox.on = model.isSelected;
    UIImageView* imageView = [self personImageView];
    
    UILabel* personLabel = [self personNameLabel];
    
    personLabel.backgroundColor = CCITY_MAIN_BGCOLOR;
    personLabel.font = [UIFont systemFontOfSize:CCITY_MAIN_FONT_SIZE];
    personLabel.textColor = CCITY_MAIN_FONT_COLOR;
    personLabel.text = model.name;
    
    [self.contentView addSubview:_checkBox];
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:personLabel];
    
    [_checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(12.f);
        make.left.equalTo(self.contentView).with.offset(30.f);
        make.bottom.equalTo(self.contentView).with.offset(-12.f);
        make.width.equalTo(_checkBox.mas_height);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(10.f);
        make.left.equalTo(_checkBox.mas_right).with.offset(5.f);
        make.bottom.equalTo(self.contentView).with.offset(-10.f);
        make.width.equalTo(imageView.mas_height);
    }];
    
    [personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).with.offset(5.f);
        make.bottom.equalTo(imageView);
        make.right.equalTo(self.contentView).with.offset(5.f);
    }];
}

-(UIImageView*)personImageView {
    
    UIImageView * personImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ccity_offical_sendDoc_addPerson_50x50_"]];
    return personImageView;
}

-(UILabel*)personNameLabel {
    
    UILabel* personNameLabel = [UILabel new];
    return personNameLabel;
}

-(BEMCheckBox*)myCheckBox {
    
    BEMCheckBox* checkBox = [[BEMCheckBox alloc]init];
    checkBox.boxType = BEMBoxTypeSquare;
    checkBox.onTintColor = CCITY_MAIN_COLOR;
    checkBox.onCheckColor = CCITY_MAIN_COLOR;
    checkBox.userInteractionEnabled = NO;
    return  checkBox;
}

@end
