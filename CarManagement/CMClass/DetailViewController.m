//
//  DetailViewController.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-4.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "DetailViewController.h"
#import "CMBaseViewController.h"
#import "OilHistoryViewController.h"
#import "LocationMapViewController.h"
#import "TakePhotoViewController.h"



@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize CMTabBarItem = _CMTabBarItem;
@synthesize tabBarController = _tabBarController;
@synthesize terminalNo = _terminalNo;
//@synthesize detailDeleagte = _detailDelegate;

/**初始化
 *@param terminalNo:终端号码
 *return self*/
- (id)initWithTerminalNo:(NSString *)terminalNoParam
{
    self = [super init];
    if ( self ) {
        self.terminalNo = terminalNoParam;
    }
    
    return self;
}

- (void)dealloc
{
    [_CMTabBarItem release];
    [_tabBarController release];
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    //0.0 view
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor redColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //2.0 tabBarController
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    LocationMapViewController *locationMapViewController = [[LocationMapViewController alloc] initWithTerminalNo:self.terminalNo];
    locationMapViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"GPS定位" image:[[CMResManager getInstance] imageForKey:@"gps_item"]  tag:kCarInfoItemTag] autorelease];
    locationMapViewController.delegate = self;
  
    TakePhotoViewController *carInfoViewController = [[TakePhotoViewController alloc] initWithTerminalNo:self.terminalNo];
    carInfoViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"车辆照片" image:[[CMResManager getInstance] imageForKey:@"car_photo_item"] tag:kCarInfoItemTag] autorelease];
    carInfoViewController.delegate = self;
    OilHistoryViewController *historyTracViewController = [[OilHistoryViewController alloc] initWithTerminalNo:self.terminalNo];
    historyTracViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"油量查询" image:[[CMResManager getInstance] imageForKey:@"oil_query_item"] tag:kCarInfoItemTag] autorelease];
    historyTracViewController.delegate = self;
    
    UINavigationController *locationNavigationCtrl = [[UINavigationController alloc] initWithRootViewController:locationMapViewController];
    locationNavigationCtrl.navigationBarHidden = YES;
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:locationNavigationCtrl,historyTracViewController,carInfoViewController,nil];
    tabBarController.viewControllers = viewControllers;
    [carInfoViewController release];
    [locationMapViewController release];
    [historyTracViewController release];
    [locationNavigationCtrl release];
    [viewControllers release];
    self.tabBarController = tabBarController;
    [tabBarController release];
 
    [view addSubview:self.tabBarController.view];
    self.view = view;
    [view release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma DetailViewControllerDelegate
- (void)popBackToMainViewController:(BOOL)animated
{
    NSLog(@"DetailViewControllerArrays = %@",self.navigationController.viewControllers);
    [self.navigationController popViewControllerAnimated:animated];

}
@end
