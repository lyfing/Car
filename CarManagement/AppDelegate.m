//
//  AppDelegate.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-4.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "CMResManager.h"
#import "CMUser.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootViewController = _rootViewController;
@synthesize client = _client;

- (void)dealloc
{
    [_window release];
    [_client release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    AsyncSocket *client = [[AsyncSocket alloc] init];
    self.client = client;
    [client release];
    
    UIViewController *firstViewController = [[LoginViewController alloc] initWithAutomaticLogin:[[CMUser getInstance] checkLoginInfo]];
    UINavigationController *rootViewController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
    [rootViewController.navigationBar setBackgroundColor:[UIColor colorWithPatternImage:[CMResManager middleStretchableImageWithKey:@"navigationbar_background"]]];
    self.rootViewController = rootViewController;
    [self.rootViewController setNavigationBarHidden:YES];
    self.window.rootViewController = self.rootViewController;
    [firstViewController release];
    [rootViewController release];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma viewController stack
/**push一个viweController到root
 *@param viewController:push的viewcontroller animate:动画
 *return nil*/
- (void)pushViewController:(UIViewController *)viewController animate:(BOOL)animated
{
    if ( viewController ) {
        [self.rootViewController pushViewController:viewController animated:YES];
    }
}

/**pop顶层viweController
 *@param animate:动画
 *return nil*/
- (void)popViewController:(BOOL)animated
{
    [self.rootViewController popViewControllerAnimated:animated];
}

- (void)presentModleViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ( viewController ) {
        [self presentModleViewController:viewController animated:YES];
    }
}

- (void)removeAllViewControllerFrowStack
{
    self.rootViewController.viewControllers = nil;
}

/**清空堆栈里面所有viewController,在push新viewController
 *@param viewController:新viewController animated:是否动画
 *return nil*/
- (void)pushViewControllerWithClearAll:(UIViewController *)viewController animate:(BOOL)animated
{
    self.rootViewController.viewControllers = nil;
    [self.rootViewController pushViewController:viewController animated:YES];
}

@end
