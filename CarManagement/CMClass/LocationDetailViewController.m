//
//  LocationDetailViewController.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-10.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "LocationDetailViewController.h"

@interface LocationDetailViewController ()

@end

@implementation LocationDetailViewController

- (void)dealloc
{
   
    [super dealloc];
}

- (void)loadView
{
    //1.0返回按钮
//    [self.navBar.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - buttonAction
/**返回按钮
 *@param nil
 *return nil*/
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
