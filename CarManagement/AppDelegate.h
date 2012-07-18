//
//  AppDelegate.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-4.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocket.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *_rootViewController;
    
    AsyncSocket *_client;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *rootViewController;
@property (nonatomic,retain) AsyncSocket *client;

/**push一个viweController到root
 *@param viewController:push的viewcontroller animate:动画
 *return nil*/
- (void)pushViewController:(UIViewController *)viewController animate:(BOOL)animated;

/**pop顶层viweController
 *@param animate:动画
 *return nil*/
- (void)popViewController:(BOOL)animated;

- (void)presentModleViewController:(UIViewController *)viewController animated:(BOOL)animated;

/**清空堆栈里面所有viewController,在push新viewController
 *@param viewController:新viewController animated:是否动画
 *return nil*/
- (void)pushViewControllerWithClearAll:(UIViewController *)viewController animate:(BOOL)animated;
 
@end
