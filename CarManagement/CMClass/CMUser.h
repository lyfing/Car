//
//  CMUser.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-5.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMUser : NSObject
{
    NSString *_userAccount;
    
    NSString *_userPassword;
    
    NSString *_serverIpAddress;
    
    NSString *_serverIpPort;
}

@property (nonatomic,copy) NSString *userAccount;
@property (nonatomic,copy) NSString *userPassword;
@property (nonatomic,copy) NSString *serverIpAddress;
@property (nonatomic,copy) NSString *serverIpPort;

/**创建一个CMUser对象
 *@param nil
 *return nil*/
+ (CMUser *)getInstance;

/**持久化存档
 *@param nil
 *return nil*/
- (void)persist;

/**APP Document路径
 *@param nil
 *return nil*/
+ (NSString *)documentPath;

/**登陆信息
 *@param nil
 *return YES:有登陆信息 NO:无*/
- (BOOL)checkLoginInfo;

/**保存数据到/userName/docName
 *@param data:要保存的数据 dacName:保存数据的文件名
 **/
- (BOOL)saveData:(NSData *)data path:(NSString *)docName;

/**获取数据到/userName/docName
 *@param dacName:保存数据的文件名
 *return nil:失败 data:成功读取数据*/
- (NSData *)readData:(NSString *)docName;

@end
