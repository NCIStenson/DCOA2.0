//
//  CCityOfficalBackLogCell.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/2.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#define OFFICAL_BACKLOG_CELL_PADDING       5.f
#define OFFICAL_BACKLOG_CELL_IMAGE_PADDING 7.f

#import "CCityOfficalBackLogCell.h"

@implementation CCityOfficalBackLogCell 

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier conentMode:(CCityOfficalDocContentMode)contentMode {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _myContentMode = contentMode;
        [self layoutMySubviews];
    }
    return self;
}

-(void)setModel:(CCityOfficalDocModel *)model {
    _model = model;
    
    _docTitleLabel.text = model.docTitle;
    _docIdLabel.text    = model.docNumber;
    _dataLabel.text     = model.docDate;
    _messageTypeLabel.text = model.messagetype;
    
    if (_myContentMode == CCityOfficalDocBackLogMode) {
        
        if (_model.isRead) {
            
            if (_isReadLabel.textColor != [UIColor grayColor]) {
                
                _isReadLabel.textColor = [UIColor grayColor];
                _isReadLabel.text = @"[已阅]";
            }
        } else {
            
            if (_isReadLabel.textColor != CCITY_MAIN_COLOR) {
                
                _isReadLabel.textColor = CCITY_MAIN_COLOR;
                _isReadLabel.text = @"[未阅]";
            }
        }
    }
}

-(void)layoutMySubviews {

    _docImageView = [[UIImageView alloc]init];
    
    _arrowImage = [UIImageView new];
    _arrowImage.tintColor = CCITY_GRAY_TEXTCOLOR;
    _arrowImage.image = [UIImage imageNamed:@"ccity_arrow_toRight_44x44_"];
    
    _docTitleLabel = [UILabel new];
    _docTitleLabel.font = [UIFont systemFontOfSize:15.f];
    _docTitleLabel.textColor = CCITY_MAIN_FONT_COLOR;
    
    _docIdLabel = [self detailLabel];
   
    _dataLabel = [self detailLabel];
    _dataLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_arrowImage];
    [self.contentView addSubview:_docImageView];
    [self.contentView addSubview:_docTitleLabel];
    [self.contentView addSubview:_docIdLabel];
    [self.contentView addSubview:_dataLabel];
    
    [_docImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(2*OFFICAL_BACKLOG_CELL_IMAGE_PADDING);
        make.left.equalTo(self.contentView).with.offset(OFFICAL_BACKLOG_CELL_IMAGE_PADDING);
        make.size.mas_equalTo(CGSizeMake(32.f, 32.f));
    }];
    
    [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-10.f);
        make.width.equalTo(_arrowImage.mas_height);
        make.height.mas_equalTo(15.f);
    }];
    
    [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_arrowImage.mas_left).with.offset(- 2*OFFICAL_BACKLOG_CELL_PADDING);
        make.bottom.equalTo(self.contentView).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
        make.size.mas_equalTo(CGSizeMake(130, 20.f));
    }];
    
    [_docIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(_docTitleLabel.mas_bottom).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
        make.left.equalTo(_docTitleLabel);
        make.bottom.equalTo(self.contentView).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
        make.right.equalTo(_dataLabel.mas_left).with.offset(-5.f);
    }];
        
    if (_myContentMode == CCityOfficalDocBackLogMode) {
            
            _messageTypeLabel = [self detailLabel];
            [self.contentView addSubview:_messageTypeLabel];
            [_dataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(_arrowImage.mas_left).with.offset(- 2*OFFICAL_BACKLOG_CELL_PADDING);
                make.bottom.equalTo(self.contentView).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
                make.width.mas_equalTo(130.f);
                make.height.mas_equalTo(15.f);
            }];
            
            [_docIdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_docTitleLabel.mas_bottom).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
                make.left.equalTo(_docTitleLabel);
                 make.bottom.equalTo(_messageTypeLabel.mas_top).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
                make.right.equalTo(_dataLabel.mas_left).with.offset(-5.f);
            }];
            
            [_messageTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_docIdLabel.mas_bottom).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
                make.left.equalTo(_docIdLabel);
                make.right.equalTo(_dataLabel.mas_left);
                make.bottom.equalTo(self.contentView).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
            }];
        }
    
    if (_myContentMode != CCityOfficalDocBackLogMode) {
        
        [_docTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
            make.left.equalTo(_docImageView.mas_right).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
            make.right.equalTo(_dataLabel.mas_right);
            make.bottom.equalTo(_docIdLabel.mas_top).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
            make.height.equalTo(_docIdLabel);
        }];
    }
    
    switch (_myContentMode) {
            
        case CCityOfficalDocBackLogMode:
            
            _docImageView.image = [UIImage imageNamed:@"ccity_offical_doc_backlog_44x44_"];
            
            [self addIsReadLabel];
            break;
            
        case CCityOfficalDocHaveDoneMode:
            
            _docImageView.image = [UIImage imageNamed:@"ccity_offical_doc_haveDone_44x44_"];
            break;
        case CCityOfficalDocReciveReadMode:
            
            _docImageView.image = [UIImage imageNamed:@"ccity_offical_doc_reciveRead_44x44_"];
            break;
        default:
            break;
    }
}

-(void)addIsReadLabel {
    
    _isReadLabel = [UILabel new];
    _isReadLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:_isReadLabel];

    [_isReadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_docTitleLabel);
        make.left.equalTo(_docTitleLabel.mas_right).with.offset(5.f);
        make.bottom.equalTo(_docTitleLabel);
        make.right.equalTo(_dataLabel);
        make.width.mas_greaterThanOrEqualTo(38.f);
    }];
    
    [_docTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
        make.left.equalTo(_docImageView.mas_right).with.offset(OFFICAL_BACKLOG_CELL_PADDING);
        make.right.equalTo(_isReadLabel.mas_left).with.offset(-5.f);
        make.bottom.equalTo(_docIdLabel.mas_top).with.offset(-OFFICAL_BACKLOG_CELL_PADDING);
        make.height.equalTo(_docIdLabel);
    }];
}

-(UILabel*)detailLabel {
    
    UILabel* detailLabel = [UILabel new];
    detailLabel.font = [UIFont systemFontOfSize:13.f];
    return detailLabel;
}

#pragma mark- --- methods

-(NSAttributedString*)formatterSurplusStr:(NSString*)str {
    
    if (str.length > 1) {
       str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([str containsString:@"超期"]) {
        
        str = [str stringByAppendingString:@"天"];
         return [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    } else {
        
       str = [NSString stringWithFormat:@"还剩%@天",str];
        
        if ([str integerValue] <= 2) {
            
            return [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:CCITY_RGB_COLOR(255, 224, 76, 1.f)}];
        } else {
            
            return [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor greenColor]}];
        }
    }
}

@end
