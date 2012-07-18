//
//  CMNavigationBar.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-5.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "CMNavigationBar.h"

#define MAX_EXTENDBUTTON_COUNT         3
#define BACK_BUTTON_X                  5
#define RIGHT_BUTTON_X_OFFSET          5
#define TITLE_HAS_BACK_BUTTON_X_OFFSET 10       //有返回按钮时title相对与返回按钮的位移
#define TITLE_X_OFFSET                 12       //没有返回按钮时title相对于返回按钮的位移
#define BUTTON_X_OFFSET                11
#define BUTTONS_SPACE_WIDTH            21

@implementation CMNavigationBar
@synthesize backgroundImgView = _backgroundImgView;
@synthesize backBtn = _backBtn;
@synthesize titleLabel = _titleLabel;
@synthesize title = _title;
@synthesize rightBtn = _rightBtn;
@synthesize extendBtns = _extendBtns;
@synthesize maxExtendButtonCount = _maxExtendButtonCount;
@synthesize backButtonEnable = _backButtonEnable;
@synthesize rightButtonEnable = _rightButtonEnable;

- (void)dealloc
{
    [_backgroundImgView release];
    [_backBtn release];
    [_titleLabel release];
    [_rightBtn release];
    [_extendBtns release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //0.0背景
//        UIImage *backgroundImg = [CMResManager middleStretchableImageWithKey:@"navigationbar_background"];
//        UIImageView *backgroundImgView = [[UIImageView alloc] initWithImage:backgroundImg];
        UIImageView *backgroundImgView = [[UIImageView alloc] init];
        backgroundImgView.frame = CGRectMake(0, 0, kFullScreenHight, kCMNavigationBarHight);
        backgroundImgView.backgroundColor = DefaultColor;
        self.backgroundImgView = backgroundImgView;
        [backgroundImgView release];
        [self addSubview:self.backgroundImgView];
        
        //1.0左返回按钮
        UIButton *backBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        self.backBtn = backBtn;
        [self addSubview:self.backBtn];
        [backBtn release];
        
        //2.0标题lable
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.userInteractionEnabled = NO;
        self.titleLabel = titleLabel;
        [self addSubview:self.titleLabel];
        [titleLabel release];
        
        //3.0右侧按钮
        UIButton *rightBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        self.rightBtn = rightBtn;
        [self addSubview:self.rightBtn];
        [rightBtn release];
        
        
        self.backButtonEnable = YES;
        self.rightButtonEnable = YES;
        _maxExtendButtonCount = MAX_EXTENDBUTTON_COUNT;
        
    }
    return self;
}

- (void)layoutSubviews
{
    //1.0左侧返回按钮frame
    if ( self.backButtonEnable ) {
        CGSize backBtnSize = [[self.backBtn currentImage] size];
        CGRect backBtnFrame = CGRectMake(BACK_BUTTON_X, (kCMNavigationBarHight - backBtnSize.height) / 2, backBtnSize.width, backBtnSize.height);
        self.backBtn.frame = CGRectIntegral(backBtnFrame);
        
    }
    
    //2.0标题标签frame
    CGSize titleSize = [self.title sizeWithFont:self.titleLabel.font];
    self.titleLabel.text = self.title;
    
    CGFloat originaltitleLabelX = self.backButtonEnable ? CGRectGetMaxX(self.backBtn.frame) + TITLE_HAS_BACK_BUTTON_X_OFFSET : TITLE_X_OFFSET;
    CGRect titleFrame = CGRectMake(originaltitleLabelX, (kCMNavigationBarHight - titleSize.height) / 2, titleSize.width, titleSize.height);
    self.titleLabel.frame = CGRectIntegral(titleFrame);
    
    //3.0右侧按钮frame
    if ( self.rightButtonEnable ) {
        CGSize rightBtnSize = [[self.rightBtn currentImage] size];
        if ( rightBtnSize.width ==0 || rightBtnSize.height == 0 ) {
            rightBtnSize = [[self.rightBtn currentBackgroundImage] size];
        }
        
        CGRect rightBtnFrame = CGRectMake(self.bounds.size.width - RIGHT_BUTTON_X_OFFSET - rightBtnSize.width, ( kCMNavigationBarHight - rightBtnSize.height ) / 2, rightBtnSize.width, rightBtnSize.height);
        self.rightBtn.frame = CGRectIntegral(rightBtnFrame);
    }
    else {
        for ( NSInteger btnIndex = 0 ; btnIndex < self.extendBtns.count; btnIndex ++ ) {
            UIButton *button = [self.extendBtns objectAtIndex:(self.extendBtns.count - btnIndex - 1)];
            button.tag = 2000 + btnIndex;
            CGSize buttonSize = [[button currentImage] size];
            if ( buttonSize.width == 0 || buttonSize.width == 0 ) {
                buttonSize = [[button currentBackgroundImage] size];
            }
            
            CGFloat buttonX = self.bounds.size.width - BUTTON_X_OFFSET - btnIndex * (buttonSize.width + BUTTONS_SPACE_WIDTH ) - buttonSize.width;
            CGRect buttonFrame = CGRectMake(buttonX, ( kCMNavigationBarHight - buttonSize.height) / 2, buttonSize.width, buttonSize.height);
            button.frame = buttonFrame;
        }
        
        UIButton *firstBtn = (UIButton *)[self.extendBtns objectAtIndex:0];
        CGFloat labelWidth = self.extendBtns ? CGRectGetMinX(firstBtn.frame) - originaltitleLabelX : titleSize.width;
        CGRect titleFrame = CGRectMake(originaltitleLabelX, ( kCMNavigationBarHight - titleSize.height ) / 2, labelWidth, titleSize.height);
        self.titleLabel.frame = CGRectIntegral(titleFrame);
    }
}

- (void)setBackButtonEnable:(BOOL)backButtonEnable
{
    _backButtonEnable = backButtonEnable;
    self.backBtn.hidden = !_backButtonEnable;
}

- (void)setRightButtonEnable:(BOOL)rightButtonEnable
{
    _rightButtonEnable = rightButtonEnable;
    self.rightBtn.hidden = !_rightButtonEnable;
    
    for ( UIButton *extendBtn in self.extendBtns ) {
        extendBtn.hidden = _rightButtonEnable;
    }
}

/**添加一个扩展按钮
 *@param button:添加按钮对象
 *return YES:成功 NO:失败*/
- (BOOL)addExtendButton:(UIButton *)button
{
    if ( self.extendBtns == nil ) {
        NSMutableArray *extenBtns = [NSMutableArray arrayWithCapacity:_maxExtendButtonCount];
        self.extendBtns = extenBtns;
    }
    
    if ( button == nil || self.extendBtns.count >= _maxExtendButtonCount ) {
        return NO;
    }
    
    [self.extendBtns addObject:button];
    [self addSubview:button];
    
    return YES;
}

/**添加一个扩展按钮
 *@param target:目标 selector:选择方法 normalImage:常态背景图 hightLightedImage:高亮背景图
 **/
- (BOOL)addExtendButtonWithTarget:(id)target 
            touchUpInsideSelector:(SEL)selector
                      normalImage:(UIImage *)normalImage
                hightLightedImage:(UIImage *)hightLightedImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:hightLightedImage forState:UIControlStateHighlighted];
    
    return [self addExtendButton:button];
}

/**添加一组按钮
 *@param buttons:按钮数据
 *return YES:成功 NO:失败*/
- (BOOL)addExtendButtons:(NSArray *)buttons
{
    for ( UIButton *button in buttons ){
        if ( ![self addExtendButton:button] ) {
            return NO;
        }
    }
    
    return YES;
}
@end
