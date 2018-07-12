//
//  XuAlertCon.m
//  LFOA
//
//  Created by  abcxdx@sina.com on 2017/12/12.
//  Copyright © 2017年  abcxdx@sina.com. All rights reserved.
//

#import "XuAlertCon.h"
#define CC_ALERT_BG_COLOR CCITY_RGB_COLOR(249, 249, 249, 1)
#define CC_BORDER_COLOR   CCITY_RGB_COLOR(225, 225, 225, 1)
#define CC_LINE_COLOR     CCITY_RGB_COLOR(206, 206, 206, 1)
#define CC_LINE_WIDTH      .5f
#define CC_PADDING       60.f

@interface XuAlertCon ()

@end

@implementation XuAlertCon {
    
    NSString* _title;
    NSArray*  _btns;
    UIView* _alertView;
}

- (instancetype)initWithTitle:(NSString*)title btns:(NSArray*)btns
{
    self = [super init];
    if (self) {
        
        _btns = btns;
        _title = title;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3f];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    _alertView = [self alterView];
    _alertView.center = self.view.center;
    [self.view addSubview:_alertView];
    
    if (_textView) {    [_textView becomeFirstResponder];   }
}

-(UIView*)alterView {
    
    UIView* alertView = [UIView new];
    alertView.frame = CGRectMake(0, 0, 280, 220);
    alertView.backgroundColor = CC_ALERT_BG_COLOR;
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(0, 0, alertView.bounds.size.width, 50);
    titleLabel.backgroundColor = CC_ALERT_BG_COLOR;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _title;
    
    CALayer* horizLine = [self line];
    horizLine.frame = CGRectMake(0, alertView.bounds.size.height - 45.f, alertView.bounds.size.width, CC_LINE_WIDTH);
    
    for (int i = 0; i < _btns.count; i++) {
        
        UIButton* btn = _btns[i];
        [btn setTitleColor:CCITY_MAIN_COLOR forState:UIControlStateNormal];
        btn.backgroundColor = CC_ALERT_BG_COLOR;
        btn.frame = CGRectMake(i * (alertView.bounds.size.width / _btns.count), alertView.bounds.size.height - 44.f, alertView.bounds.size.width / _btns.count, 44.f);
        
        [alertView addSubview:btn];

        if (i != 0) {
            
            CALayer* verticalLine = [self line];
            verticalLine.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y - 1, CC_LINE_WIDTH, btn.frame.size.height + 1);
            [alertView.layer addSublayer:verticalLine];
        }
    }
    
    _textView = [UITextView new];
    _textView.layer.borderColor = CC_BORDER_COLOR.CGColor;
    _textView.frame = CGRectMake(18, titleLabel.bounds.size.height, alertView.bounds.size.width - 36.f, 115.f);
    _textView.layer.borderWidth = 1.f;
    
    [alertView.layer addSublayer:horizLine];
    [alertView addSubview:_textView];
    [alertView addSubview:titleLabel];
    
    alertView.layer.cornerRadius = 10.f;
    alertView.clipsToBounds = YES;
    return alertView;
}

-(CALayer*)line {
    
    CALayer* layer = [CALayer new];
    layer.backgroundColor = CC_LINE_COLOR.CGColor;
    return layer;
}


#pragma mark --- keyboard

-(void)keyboardWillChange:(NSNotification*)notfic {
    
    CGRect keyboardFrame = [notfic.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    float duration = [notfic.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    CGFloat alertViewBottom = _alertView.bounds.size.height + _alertView.frame.origin.y;
    
    if (alertViewBottom > keyboardFrame.origin.y) {
        
        [UIView animateWithDuration:duration animations:^{
            
            CGRect alertFrame = _alertView.frame;
            alertFrame.origin.y -= (alertViewBottom - keyboardFrame.origin.y);
            _alertView.frame = alertFrame;
        }];
    }
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
