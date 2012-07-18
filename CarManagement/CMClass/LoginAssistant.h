//
//  LoginAssistant.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-16.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginAssistant : NSObject<UIAlertViewDelegate>{
    AsyncSocket *_socket;
    
    CMProcess _process;
}

@property (nonatomic,retain) AsyncSocket *socket;
@property (nonatomic) CMProcess process;

/**初始化
 *@param socket:初始化socket
 *return self*/
- (id)initWithSocket:(AsyncSocket *)socket;

@end
