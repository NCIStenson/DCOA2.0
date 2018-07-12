//
//  CCityOfficalDocDetailModel.h
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/8/7.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCHuiQianModel:NSObject

@property(nonatomic, strong)NSString* personName;
@property(nonatomic, strong)NSString* opinio;

- (instancetype)initWithPerosn:(NSString*)personName opinio:(NSString*)opinio;
@end


@interface CCityOfficalDocDetailModel : NSObject

@property(nonatomic, assign)BOOL              isOpen;
@property(nonatomic, strong)NSString*         title;
@property(nonatomic, assign)CCityOfficalDetailSectionStyle style;
@property(nonatomic, assign)CGFloat           sectionHeight;
@property(nonatomic, assign)CGSize            titleLabelSize;

@property(nonatomic, assign)BOOL              hasCell;
@property(nonatomic, assign)BOOL              canEdit;

@property(nonatomic, strong)NSString*         dataType;
@property(nonatomic, strong)NSString*         table;
@property(nonatomic, strong)NSString*         value;
@property(nonatomic, strong)NSString*         field;
@property(nonatomic, strong)NSArray*          switchContentArr;
@property(nonatomic, strong)NSMutableArray*   huiqianContentsMuArr;

- (instancetype)initWithDic:(NSDictionary*)dic;

@end
