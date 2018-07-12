//
//  CCityOfficalBackLogCell.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/2.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "CCityBaseTableViewCell.h"
#import "CCityOfficalDocModel.h"

@interface CCityOfficalBackLogCell : CCityBaseTableViewCell

@property(nonatomic, strong) CCityOfficalDocModel*      model;

@property(nonatomic, assign) CCityOfficalDocContentMode myContentMode;
@property(nonatomic, strong) UIImageView* docImageView;
@property(nonatomic, strong) UILabel*     dataLabel;
@property(nonatomic, strong) UILabel*     docTitleLabel;
@property(nonatomic, strong) UILabel*     docIdLabel;
@property(nonatomic, strong) UILabel*     isReadLabel;
@property(nonatomic, strong) UILabel*     messageTypeLabel;
@property(nonatomic, strong) UIImageView* arrowImage;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier conentMode:(CCityOfficalDocContentMode)contentMode;

@end
