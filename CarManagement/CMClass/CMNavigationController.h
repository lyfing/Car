//
//  CMNavigationController.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-5.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMNavigationBar.h"


@interface CMNavigationController : UIViewController
{
    CMNavigationBar *_navBar;
}

@property (nonatomic,retain) CMNavigationBar *navBar;

@end
