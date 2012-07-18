//
//  MainViewController.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-4.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface MainViewController : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate,EGORefreshTableHeaderDelegate>
{
    UISearchBar *_searchBar;
    
    UITableView *_carInfoTView;
    
    UIBarButtonItem *_logoutBtn;
    
    NSString *_companyName;
    
    NSMutableArray *_terminalNos;
    
    NSMutableArray *_carNos;
    
    NSMutableArray *_searchResult;
    //刷新进度
    EGORefreshTableHeaderView *_refreshHeaderView;
}

@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,retain) UITableView *carInfoTView;
@property (nonatomic,retain) UIBarButtonItem *logoutBtn;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,retain) NSMutableArray *terminalNos;
@property (nonatomic,retain) NSMutableArray *carNos;
@property (nonatomic,retain) NSMutableArray *searchResult;
@property (nonatomic,retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic) BOOL isSearchOn;
@property (nonatomic) BOOL reloading;

/**初始化
 *@param companyName:公司名称 terminalNos:终端号码数组
 *return self*/
- (id)initwithCompanyName:(NSString *)companyName terminalNos:(NSMutableArray *)terminalNosParam;

/**刷新
 *@param nil
 *return nil*/
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
