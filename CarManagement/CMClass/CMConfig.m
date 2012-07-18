//
//  CMConfig.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-4.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "CMConfig.h"
#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <arpa/inet.h>
#import <sys/types.h>
#import <netdb.h>
#import <sys/socket.h>
#import <SystemConfiguration/SystemConfiguration.h>


@implementation CMConfig

static CMConfig *_globalConfig = nil;
@synthesize svnMapUrl = _svnMapUrl;
@synthesize svnMapUrl1 = _svnMapUrl1;
@synthesize svnMapUrl2 = _svnMapUrl2;
@synthesize oriSvnMapUrl = _oriSvnMapUrl;
@synthesize photoUrl = _photoUrl;
@synthesize descriptions = _descriptions;

- (void)dealloc
{
    self.svnMapUrl = nil;
    self.svnMapUrl1 = nil;
    self.svnMapUrl2 = nil;
    self.oriSvnMapUrl = nil;
    self.photoUrl = nil;
    self.descriptions = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if ( self)  {
        self.svnMapUrl = @"http://www.fatmanager.cn/maplite/TDtu";
        self.svnMapUrl1 = @"http://www.fatmanager.cn/maplite/TDtu1";
        self.svnMapUrl2 = @"http://www.fatmanager.cn/maplite/TDtu2";
        self.oriSvnMapUrl = @"http://tile2.tianditu.com/DataServer?T=";
        self.photoUrl = @"http://www.fatmanager.cn/photo/";
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
        @"胖总车管,是一款优秀的车辆管理软件.通过胖总车管可以查询车辆信息,地图显示车辆当前及历史位置,车辆油量使用情况和拍照查看车辆当前工作情况.为车辆管理调度提供有力数据支持.",
        @"胖总车管主界面,列表显示车辆当前情况,支持搜索查询,下拉列表即可完成数据更新.",
        @"GPS定位,地图上显示车辆位置,支持查询不超过12小时历史数据,显示在地图上.",
        @"油量历史查询,跟踪车辆使用情况,支持查询不超过10天的历史数据,以文本形式展.",
        @"拍照功能,检查车辆作业情况.支持选择拍摄摄像头以及触摸照片自动刷新功能.拨打电话按钮可列表显示车主电话,一键式选择完成拨号.", nil];
        self.descriptions = array;
        [array release];
    }
    
    return self;
}

/**获取全局实例
 *@param nil
 *return nil*/
+ (CMConfig *)globalConfig
{
    if ( !_globalConfig ) {
        _globalConfig = [[CMConfig alloc] init];
    }
    
    return _globalConfig;
}

/**检查网络是否可用
 *@param nil
 *return YES:可用 NO:不可用*/
- (BOOL)checkNetworkIsValid 
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}
@end
