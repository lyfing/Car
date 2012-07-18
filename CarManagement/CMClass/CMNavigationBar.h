//
//  CMNavigationBar.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-5.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMNavigationBar : UIView
{
    //bar背景
    UIImageView *_backgroundImgView;
    //左侧返回按钮
    UIButton *_backBtn;
    //bar标题
    UILabel *_titleLabel;
    //标题
    NSString *_title;
    //右侧按钮
    UIButton *_rightBtn;
    //右边扩展按钮
    NSMutableArray *_extendBtns;
    //右边最大扩展按钮数
    NSInteger _maxExtendButtonCount;
}

@property (nonatomic,retain) UIImageView *backgroundImgView;
@property (nonatomic,retain) UIButton *backBtn;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,retain) UIButton *rightBtn;
@property (nonatomic,retain) NSMutableArray *extendBtns;
@property (nonatomic) NSInteger maxExtendButtonCount;

//返回按钮是否可用，NO会隐藏返回按钮，默认为YES
@property (nonatomic,assign) BOOL backButtonEnable;
//右侧按钮是否可用，NO会隐藏右侧按钮，YES会隐藏扩展按钮们，默认为NO
@property (nonatomic,assign) BOOL rightButtonEnable;


- (void)setBackButtonEnable:(BOOL)backButtonEnable;

- (void)setRightButtonEnable:(BOOL)rightButtonEnable;

/**添加一个扩展按钮
 *@param target:目标 selector:选择方法 normalImage:常态背景图 hightLightedImage:高亮背景图
 **/
- (BOOL)addExtendButtonWithTarget:(id)target 
            touchUpInsideSelector:(SEL)selector
                      normalImage:(UIImage *)normalImage
                hightLightedImage:(UIImage *)hightLightedImage;

/**添加一组按钮
 *@param buttons:按钮数据
 *return YES:成功 NO:失败*/
- (BOOL)addExtendButtons:(NSArray *)buttons;



@end
