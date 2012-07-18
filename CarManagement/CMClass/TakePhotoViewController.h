//
//  CarInfoViewController.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-6.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"
#import "DetailViewController.h"
#import "CMImageView.h"
#import "FPPopoverController.h"
#import "ChoicesListTableView.h"

@interface TakePhotoViewController : CMBaseViewController<UITableViewDelegate,UITableViewDataSource,FPPopoverControllerDelegate,ChoicesListTableViewDelegate,UIAlertViewDelegate>
{
    UIButton *_backBtn;
    
    NSString *_terminalNo;
    
    UILabel *_photoInfoLabel;
    //@车照片
    CMImageView *_carImgView;
    //记录上次选择拍照模式
    CMCameraType _lastCameraType;
    //数据请求
    AsyncSocket *_socket;
    
    //@加载车辆照片信息
    UIView *_photoLoadingView;
    UILabel *_photoLoadLabel;
    UIActivityIndicatorView *_photoLoadProcessView;
    //选择列表
    FPPopoverController *_popoverView;
    //拨打电话
    UIWebView *_phoneCall;
}

@property (nonatomic,retain) UIButton *backBtn;
@property (nonatomic,copy) NSString *terminalNo;
@property (nonatomic,retain) UILabel *photoInfoLabel;
@property (nonatomic,retain) CMImageView *carImgView;
@property (nonatomic) CMCameraType lastCameraType;
@property (nonatomic,retain) AsyncSocket *socket;
@property (nonatomic,retain) UIView *photoLoadingView;
@property (nonatomic,retain) UILabel *photoLoadLabel;
@property (nonatomic,retain) UIActivityIndicatorView *photoLoadProcessView;
@property (nonatomic,retain) FPPopoverController *popoverView;
@property (nonatomic,retain) UIWebView *phoneCall;
@property (nonatomic) BOOL isTakePhoto;
@property (nonatomic) BOOL isCall;


/**初始化
 *@param terminalNo:终端号码
 *return self*/
- (id)initWithTerminalNo:(NSString *)terminalNoParam;

@end
