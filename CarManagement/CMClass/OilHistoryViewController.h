//
//  HistoryTrackViewController.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-6.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"

@class CMUITextView;
@interface OilHistoryViewController : CMBaseViewController<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    NSString *_terminalNo;
    
    CMUITextView *_oilHistoryView;
    
    //@时间选择相关
    //时间选择
    UIView *_dateView;
    //开始时间
    UITextField *_dateBegin;
    //结束时间
    UITextField *_dateEnd;
    //分割
    UILabel *_segLabel;
    //日期选择
    UIDatePicker *_datePicker;
    CMDateChoiceProcess _dateChoiceProcess;
    
    //@加载数据进度指示
    //加载view
    UIView *_loadingView;
    //加载菊花
    UIActivityIndicatorView *_indicator;
    //文本信息
    UILabel *_tipLabel;
    
    //通讯socket
    AsyncSocket *_socket;
}

@property (nonatomic,copy) NSString *terminalNo;
@property (nonatomic,retain) CMUITextView *oilHistoryView;
@property (nonatomic,retain) UITextField *dateBegin;
@property (nonatomic,retain) UITextField *dateEnd;
@property (nonatomic,retain) UIView *dateView;
@property (nonatomic,retain) UILabel *segLabel;
@property (nonatomic,retain) UIDatePicker *datePicker;
@property (nonatomic,retain) UIView *loadingView;
@property (nonatomic,retain) UIActivityIndicatorView *indicator;
@property (nonatomic,retain) UILabel *tipLabel;
@property (nonatomic) CMDateChoiceProcess dateChoiceProcess;
@property (nonatomic,retain) AsyncSocket *socket;
@property (nonatomic) BOOL isQueryOk;
/**初始化
 *@param terminalNo:终端号码
 *return self*/
- (id)initWithTerminalNo:(NSString *)terminalNoParam;

@end

@interface CMUITextView : UITextView
{
    UILabel *_titleLabel;
    UILabel *_queryDate;
    UIImageView *_sliderImgV;
}

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *queryDate;
@property (nonatomic,retain) UIImageView *sliderImgV;

/**是否显示title 和 slider
 *@param show:显示与否
 *return nil*/
- (void)hideTitleAndSlider:(BOOL)show;
@end


