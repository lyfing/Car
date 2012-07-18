//
//  NSString+CMAdditions.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-6.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(CMAdditions)
/*登陆口令
 *@param userAccount:账号 userPassword:密码
 *return loginParam:登陆口令*/
+ (NSString *)createLoginParam:(NSString *)userAccount password:(NSString *)userPassword;

/**查询当前车辆信息
 *@param
 *return*/
+ (NSString *)createQueryCurrentCarsInfo:(NSArray *)carNos;

/**更新车辆信息
 *@param
 *return*/
+ (NSString *)createUpdateCurrentCarsInfo:(NSArray *)carNos;

/**拍照口令
 *@param terminalId:终端编号 cameraType:摄像头类型(前置/后置)
 *return takePhoteParam:拍照口令*/
+ (NSString *)createTakePhotoParam:(NSString *)terminalId cameraType:(CMCameraType)cameraType;

/**查询历史轨迹
 *@param terminalId:终端编号 beginTime:开始时间 endTime:结束时间
 *return queryHistoryTrackParam:查看历史轨迹口令*/
+ (NSString *)createQueryHistoryTrackParam:(NSString *)terminalId beginTime:(NSString *)beginTime endTime:(NSString *)endTime;

/**油量分析
 *@param terminalId:终端编号 beginTime:开始时间 endTime:结束时间
 *return oilAnalysis*/
+ (NSString *)createOilAnalysisParam:(NSString *)terminalId beginTime:(NSString *)beginTime endTime:(NSString *)endTime;

///**车辆状态
// *@param staate:车辆状态码 
// *return param*/
//+ (NSString *)createCarStateParam:(long)state;

/**转换接收到的Data至NSString
 *@param data:接收到的数据
 *@param result:转换后的NSString*/
+ (NSString *)dataToStringConvert:(NSData *)data;

/**登陆返回解析
 *@param recv:登陆后接收到的数据
 *return */
+ (NSMutableArray *)parseLoginRecv:(NSData *)data;

/**车辆信息请求返回解析
 *@param recv:车辆信息请求接收到的数据
 *return terminalNos:终端号码数组*/
+ (NSMutableArray *)parseRequestCarInfoRecv:(NSData *)data;

/**车辆历史信息请求返回解析
 *@param recv:车辆历史信息请求接收到的数据
 *return result:历史数据数组键值*/
+ (NSMutableArray *)parseQueryHistoryTrackRecv:(NSData *)data;

/**车辆油量信息请求返回解析
 *@param recv:车辆历史信息请求接收到的数据
 *return result:历史油量数据*/
+ (NSString *)parseQueryOilAnalysisRecv:(NSData *)data;

/**解析更新车辆信息
 *@param data:返回信息
 *return nil*/
+ (void)praseUpdateCurrentCarsInfo:(NSData *)data;

/**拍照返回数据解析
 *@param recv:拍照接收到的数据
 **/
+ (void)ParsetakePhotoRecv:(NSData *)data;

///**拍照后在服务器获取照片url地址
// *@param terminalNo:终端号
// *return url:获取照片url*/
//+ (NSString *)photoRequestUrl:(NSString *)terminalNo;
//
///**拍照返回数据解析
// *@param recv:拍照接收到的数据
// **/
//+ (NSArray *)takePhotoRecv:(NSString *)recv;
//
///**查询历史轨迹返回数据解析
// *@param recv:历史轨迹接收到的数据
// **/
//+ (NSArray *)historyTrackRecv:(NSString *)recv;
//
///**剩余油量返回解析
// *@param recv:查询剩余油量接收到的数据
// **/
//+ (NSArray *)oilAnalysis:(NSString *)recv;

/**获取对应车类型的车图片
 *@param carType:车类型
 *return key:对应车类型的图片的key*/
+ (NSString *)carImage:(CMCarType)carType;

/**车速
 *@param speed:车速(float类型)
 *return param:车速:value*/
+ (NSString *)carSpeedParam:(float)speed;

/**位置
 *@param carPosition:车辆位置
 *return 位置:value*/
+ (NSString *)carPositionParam:(NSString *)carPosition;

/*******************adjustment NSString for cell
 *******************/

/**适应cell的车牌号码字符串
 *@param carNoParam:车牌号
 *return carNo:适应cell的车牌号*/
+ (NSString *)carNoAdjustmentParam:(NSString *)carNoParam;

/**适应cell的车速字符串
 *@param carSpeedParam:车速
 *return carSpeed:适应cell的车速*/
+ (NSString *)carSpeedAdjustmentParam:(float)carSpeedParam;

/**适应cell的车状态
 *@param carStateParam:车牌号
 *return carState:适应cell的车状态*/
+ (NSString *)carStateAdjustmentParam:(NSString *)carStateParam;


/**适应cell的车位置字符串
 *@param carPositionParam:车位置
 *return carPosition:适应cell的车位置*/
+ (NSString *)carPositionAdjustmentParam:(NSString *)carPositionParam;

/**拍照后在服务器获取照片url地址
 *@param terminalNo:终端号
 *return url:获取照片url*/
+ (NSString *)photoRequestUrl:(NSString *)terminalNo;

/**时区转换
 *@param forDate:待转换的时间
 *return newDate:转换后的时间*/
+ (NSDate *)convertDateToLocalTime:(NSDate *)forDate;

@end