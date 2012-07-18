//
//  SettingViewController.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-4.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"

@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_settingTView;
    
    NSDictionary *_settingsDic;
    
    NSArray *_settingKeys;
    
    UITextField *_serverIpAddressField;
    
    UITextField *_serverIpPortField;
    
    UIButton *_doneBtn;
}

@property (nonatomic,retain) UITableView *settingTView;
@property (nonatomic,retain) NSDictionary *settingsDic;
@property (nonatomic,retain) NSArray *settingKeys;
@property (nonatomic,retain) UITextField *serverIpAddressField;
@property (nonatomic,retain) UITextField *serverIpPortField;
@property (nonatomic,retain) UIButton *doneBtn;


@end
