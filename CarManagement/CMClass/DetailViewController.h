//
//  DetailViewController.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-4.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMBaseViewController.h"

//@protocol DetailViewControllerDelegate <NSObject>
//
//- (void)popBackToMainView:(BOOL)animated;
//
//@end

@interface DetailViewController : UIViewController<UITabBarDelegate,BaseViewControllerDelegate>
{
    UITabBarItem *_CMTabBarItem;
    
    NSString *_terminalNo;
    
    UITabBarController *_tabBarController;
    
//    id <DetailViewControllerDelegate> *_detailDelegate;
}

@property (nonatomic,copy) NSString *terminalNo;
@property (nonatomic,retain) UITabBarItem *CMTabBarItem;
@property (nonatomic,retain) UITabBarController *tabBarController;
//@property (nonatomic,assign) id<DetailViewControllerDelegate> *detailDeleagte;

/**初始化
 *@param terminalNo:终端号码
 *return self*/
- (id)initWithTerminalNo:(NSString *)terminalNoParam;
@end


