//
//  CMConfig.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-4.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMConfig : NSObject
{
    NSString *_svnMapUrl;
    NSString *_svnMapUrl1;
    NSString *_svnMapUrl2;
    NSString *_oriSvnMapUrl;
    NSString *_photoUrl;
    //关于胖总车管图片描述
    NSMutableArray *_descriptions;
}

@property (nonatomic,copy) NSString *svnMapUrl;
@property (nonatomic,copy) NSString *svnMapUrl1;
@property (nonatomic,copy) NSString *svnMapUrl2;
@property (nonatomic,copy) NSString *oriSvnMapUrl;
@property (nonatomic,copy) NSString *photoUrl;
@property (nonatomic,retain) NSMutableArray *descriptions;

/**获取全局实例
 *@param nil
 *return nil*/
+ (CMConfig *)globalConfig;

/**检查网络是否可用
 *@param nil
 *return YES:可用 NO:不可用*/
- (BOOL)checkNetworkIsValid;

@end
