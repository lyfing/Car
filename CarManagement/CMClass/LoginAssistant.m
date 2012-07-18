//
//  LoginAssistant.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-16.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "LoginAssistant.h"

#define kAlertServerMsgLoss             2001
#define kAlertNetWorkUnusable           2002
#define kAlertAccountNotExist           2003
#define kAlertPasswordWrong             2004
#define kAlertServerIpWrong             2005
#define kAlertServerPortWrong           2006

@implementation LoginAssistant
@synthesize socket = _socket;
@synthesize process = _process;

/**初始化
 *@param socket:初始化socket
 *return self*/
- (id)initWithSocket:(AsyncSocket *)socket
{
    self = [super init];
    if ( self ) {
        self.socket = socket;
        self.process = CMProcessLogin;
    }
    
    return self;
}

- (void)dealloc
{
    [_socket release];
    
    [super dealloc];
}

/**连接服务器
 *@param severAddress:服务器地址 severPort:服务器端口 error:
 *return YES:connect Success NO:connect Fa*/
- (BOOL)clientConnectToTheSever:(NSString *)severAddress onPort:(UInt16)severPort error:(NSError **)error
{
    BOOL isConnectSuccess = [self.socket connectToHost:severAddress onPort:severPort error:error];
    if ( !isConnectSuccess ) {
        [self showAlert:kAlertNetWorkUnusable title:nil message:@"连接失败,请重试"];
    }
    
    return isConnectSuccess;
}

/**服务器请求
 *@param data:发送数据 timeout:超时时间 tag:标签
 *return nil*/
- (void)requestToTheSever:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
    [self.socket writeData:data withTimeout:timeout tag:tag];
}
   
#pragma UIAlertView
/**提醒
 *@param
 *return nil*/
- (void)showAlert:(NSInteger)alertTag title:(NSString *)title message:(NSString *)message
{
    if ( !title ) {
        title = kAlertTitleDefault;
    }
    UIAlertView *tip = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    tip.tag = alertTag;
    [tip show];
    [tip release];
}

#pragma AsyncSocket
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    [self.socket readDataWithTimeout:-1 tag:0];
    [self.socket readDataWithTimeout:-1 tag:1];
   
    NSLog(@"didConnectToHost");
}
   
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err 
{
    NSLog(@"Error");
    [self showAlert:kAlertNetWorkUnusable title:nil message:@"当前网络不可用，请检查后重新登陆"];
}
   
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"Sorry this connect is failure in LoginViewController");
}
   
//- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
//{  
//    NSLog(@"recvData = %@",data);
//    //    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    //    NSString *recvMsg = [[NSString alloc] initWithData:data encoding:enc];
//    //    NSLog(@"recvMsg = %@",recvMsg);
//    if ( self.process == CMProcessLogin ) {
//        //        NSLog(@"recvMsg = %@",recvMsg);
//        NSMutableArray *carInfoArrays = [NSString parseLoginRecv:data];
//        NSLog(@"Login return carInfoArrays = %@",carInfoArrays);
//        CMLoginREsultType loginResultType = [[carInfoArrays objectAtIndex:0] intValue];
//        switch ( loginResultType ) {
//            case CMLoinResultTypeAcountNotExist:
//            {
//                
//            }break;
//            case CMLoinResultTypePasswordWrong:
//            {
//                [self showAlert:kAlertPasswordWrong title:nil message:@"您输入的密码有误，请重新输入"];
//            }break;
//            case CMLoinResultTypeServerIpWrong:
//            {
//                
//            }break;
//            case CMLoinResultTypeServerPortWrong:
//            {
//                
//            }break;
//            case CMLoinResultTypeSuccess:
//            {
//                
//                //登陆成功
//                //             NSArray *carNos = [[CMCars getInstance] carNos];
//                self.companyName = [carInfoArrays objectAtIndex:1];
//                NSArray *terminalNos = nil;
//                terminalNos = [NSArray arrayWithArray:[[CMCars getInstance] terminalNos]];
//                NSLog(@"terminalNos = %@",terminalNos);
//                NSString *requireCarsInfoFirstParam = [NSString createRequireCarInfoFirstParam:terminalNos];
//                NSLog(@"requireCarsInfoFirstParam = %@",requireCarsInfoFirstParam);
//                NSData *requireCarsInfoFirstParamData = [requireCarsInfoFirstParam dataUsingEncoding:NSUTF8StringEncoding];
//                [self.socket writeData:requireCarsInfoFirstParamData withTimeout:-1 tag:1];
//                
//                //                NSString *requireCarsInfoSecondParam = [NSString createRequireCarInfoSecondParam:terminalNos];
//                //                NSLog(@"requireCarsInfoSecondParam = %@",requireCarsInfoSecondParam);
//                //                NSData *requireCarsInfoSecondParamData = [requireCarsInfoSecondParam dataUsingEncoding:NSUTF8StringEncoding];
//                //                [self.socket writeData:requireCarsInfoSecondParamData withTimeout:-1 tag:0];
//                
//                self.process = CMProcessRequireCarsInfoStateFirst;
//            }break;
//            default:NSLog(@"Login error~ %d",loginResultType);
//                break;
//        }
//    }
//    else if ( self.process == CMProcessRequireCarsInfoStateFirst ) {
//        NSLog(@"CMProcessRequireCarsInfoStateFirst Sucess");
//        NSMutableArray *terminalNos = [NSString parseRequestCarInfoRecv:data];
//        NSLog(@"Login terminalNos = %@",terminalNos);
//        UIViewController *mainViewController = [[MainViewController alloc] initwithCompanyName:self.companyName terminalNos:terminalNos];
//        UINavigationController *carInfoNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
//        //        self.carInfoNavigationController = carInfoNavigationController;
//        [self presentModalViewController:carInfoNavigationController animated:NO];
//        [mainViewController release];
//        [carInfoNavigationController release];
//        
//    }
//    else if ( self.process == CMProcessRequireCarsInfoStateSecond ) {
//        NSLog(@"CMProcessRequireCarsInfoStateSecond Sucess");
//    }
//}

@end
