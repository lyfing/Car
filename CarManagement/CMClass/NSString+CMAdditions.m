//
//  NSString+CMAdditions.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-6.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//



#import "NSString+CMAdditions.h"
#import "CurrentCarInfo.h"

#define kLoginSuccess               @"0;3;1;1"
#define kLoginWithPasswordWrong     @"0,3,1,0"
#define kLoginWithAccountNotExist   @""
#define kLoginWithServerIpWrong     @""
#define kLoginWithServerPortWrong     @""

#define kCarInfoRequestError        @""
#define kCarInfoRequestSuccess      @""

#define kTakePhotoSuccess           @""
#define kTakePhotoFailure           @""

#define kQueryHistoryTrackSuccess   @""
#define kQueryHistoryTrackFailure   @""

#define kOilAnalysisSuccess         @""
#define kOilAnalysisFailure         @""

@implementation NSString(CMAdditions)

/*登陆口令
 *@param userAccount:账号 userPassword:密码
 *return loginParam:登陆口令*/
+ (NSString *)createLoginParam:(NSString *)userAccount password:(NSString *)userPassword
{
    NSString *loginParam = [[NSString alloc] initWithFormat:@"$187:%@:%@:11",userAccount,userPassword];
    
    return [loginParam autorelease];
}

/**查询当前车辆信息
 *@param
 *return*/
+ (NSString *)createQueryCurrentCarsInfo:(NSArray *)carNos
{
    NSString *param = [NSString stringWithFormat:@"1:"];
    NSString *part;
    for ( NSString *carNo in carNos ) {
        part = [NSString stringWithFormat:@"%@,-1;",carNo];
        param = [param stringByAppendingString:part];
    }
    
    return  param;
}

/**更新车辆信息
 *@param
 *return*/
+ (NSString *)createUpdateCurrentCarsInfo:(NSArray *)carNos
{
    NSString *param = [NSString stringWithFormat:@"2:"];
    NSString *part;
    for ( NSString *carNo in carNos ) {
        part = [NSString stringWithFormat:@"%@,-1;",carNo];
        param = [param stringByAppendingString:part];
    }
    
    return  param;
}


/**拍照口令
 *@param terminalId:终端编号 cameraType:摄像头类型(前置/后置)
 *return takePhoteParam:拍照口令*/
+ (NSString *)createTakePhotoParam:(NSString *)terminalId cameraType:(CMCameraType)cameraType
{
    NSString *takePhotoParam = nil;
    if ( [terminalId length] == 12 ) {
        takePhotoParam = [NSString stringWithFormat:@"70:%@:%d,1,30,0,0,1,110,50,50,110",terminalId,cameraType];
    }
    else {
        takePhotoParam = [NSString stringWithFormat:@"60:%@:1:%d:1",terminalId,cameraType + 1];
    }

    return takePhotoParam;
}

/**查询历史轨迹
 *@param terminalId:终端编号 beginTime:开始时间 endTime:结束时间
 *return queryHistoryTrackParam:查看历史轨迹口令*/
+ (NSString *)createQueryHistoryTrackParam:(NSString *)terminalId beginTime:(NSString *)beginTime endTime:(NSString *)endTime
{
    NSString *queryHistoryTrackParam = [[NSString alloc] initWithFormat:@"and1:%@:%@:%@",terminalId,beginTime,endTime];
    
    return [queryHistoryTrackParam autorelease];

}

/**油量分析
 *@param terminalId:终端编号 beginTime:开始时间 endTime:结束时间
 *return oilAnalysis*/
+ (NSString *)createOilAnalysisParam:(NSString *)terminalId beginTime:(NSString *)beginTime endTime:(NSString *)endTime
{
    NSString *oilAnalysisParam = [[NSString alloc] initWithFormat:@"and2:%@:%@:%@",terminalId,beginTime,endTime];
    
    return [oilAnalysisParam autorelease]; 

}

/**转换接收到的Data至NSString
 *@param data:接收到的数据
 *@param result:转换后的NSString*/
+ (NSString *)dataToStringConvert:(NSData *)data
{
    NSLog(@"original Data = %@",data);
    NSLog(@"dataToStringConvert");
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *result = [[NSString alloc] initWithData:data encoding:enc];
    NSLog(@"result = %@",result);
    return [result autorelease];
}

/**登陆返回解析
 *@param recv:登陆后接收到的数据
 *return param:车辆信息数组，第一个字段为登陆返回码;第二字段为公司名称;之后为车辆信息数组 */
+ (NSMutableArray *)parseLoginRecv:(NSData *)data
{
    NSString *recv = [NSString dataToStringConvert:data];
    NSMutableArray *param = [[NSMutableArray alloc] init];
    NSMutableArray *carsParam = [[NSMutableArray alloc] init];
    if ( [recv hasPrefix:kLoginWithAccountNotExist] ) {
        [param addObject:[NSString stringWithFormat:@"%d",CMLoinResultTypeAcountNotExist]];
    }
    else if ( [recv hasPrefix:kLoginWithPasswordWrong] ) {
        [param addObject:[NSString stringWithFormat:@"%d",CMLoinResultTypePasswordWrong]];
    }
    else if ( [recv hasPrefix:kLoginWithServerIpWrong] ) {
        [param addObject:[NSString stringWithFormat:@"%d",CMLoinResultTypeServerIpWrong]];
    }
    else if ( [recv hasPrefix:kLoginWithServerPortWrong] ) {
        [param addObject:[NSString stringWithFormat:@"%d",CMLoinResultTypeServerPortWrong]];
    }
    else if ( [recv hasPrefix:kLoginSuccess] ) {
        [param addObject:[NSString stringWithFormat:@"%d",CMLoinResultTypeSuccess]];
        
        NSArray *semicolonArray = [recv componentsSeparatedByString:@";"];
        [param addObject:[semicolonArray objectAtIndex:4]];//第一个字段位公司名称
        NSString *carsInfo = [semicolonArray objectAtIndex:5];
        NSArray *carInfoArray = [carsInfo componentsSeparatedByString:@","];
        for ( NSString *carInfos in carInfoArray ) {
            NSArray *carDetailInfo = [carInfos componentsSeparatedByString:@":"];
            //[param addObject:carDetailInfo];
            CarInfo *theCarInfo = [[CarInfo alloc] initWithParam:carDetailInfo];
            [carsParam addObject:theCarInfo];
        }
        
        CMCars *cars = [[[CMCars alloc] initwithCarsInfoParam:carsParam] autorelease];
        NSLog(@"cars = %@",cars);
    }
    [carsParam release];
    NSLog(@"param = %@",param);
    return [param autorelease];
}

/**车辆信息请求返回解析
 *@param recv:车辆信息请求接收到的数据
 *return terminalNos:终端号码数组*/
+ (NSMutableArray *)parseRequestCarInfoRecv:(NSData *)data
{
    NSString *recv = [NSString dataToStringConvert:data];
    NSLog(@"parseRequestCarInfoRecv:%@",recv);
    NSMutableArray *param = [[NSMutableArray alloc] init];
    NSMutableArray *terminalNos = [[NSMutableArray alloc] init];
    //逗号分割
    NSArray *commaArray = [recv componentsSeparatedByString:@","];
    //冒号分割
    for ( NSString *currentCarInfosWith6 in commaArray ) {
        if ( ![currentCarInfosWith6 isEqualToString:@""] ) {
            NSArray *colonArray = [currentCarInfosWith6 componentsSeparatedByString:@":"];
            if ( [colonArray count] >= 2 ) {
                NSString *currentCarInfos = [colonArray objectAtIndex:1];
                NSArray *currentCarInfoParam = [currentCarInfos componentsSeparatedByString:@";"];
                if ( [currentCarInfoParam count] == 18 ) {
                    CurrentCarInfo *currentCarInfo = [[CurrentCarInfo alloc] initWithParam:currentCarInfoParam];
                    [terminalNos addObject:currentCarInfo.terminalNo];
                    [param addObject:currentCarInfo];
                }
            }
        }
    }

    CMCurrentCars *currentCars = [[CMCurrentCars alloc] initWithCurrentCarInfoParam:param];
    NSLog(@"RequestCarInfoRecv param = %@",param);
    NSLog(@"currentCars = %@",currentCars);
    [currentCars release];
    [param release];

    return [terminalNos autorelease];
}

/**解析更新车辆信息
 *@param data:返回信息
 *return nil*/
+ (void)praseUpdateCurrentCarsInfo:(NSData *)data
{
    NSLog(@"NSString + update");
    NSString *recv = [NSString dataToStringConvert:data];
    //逗号分割
    NSArray *comma = [recv componentsSeparatedByString:@","];
    for ( NSString *carInfoStringWith6 in comma ) {
        if ( [carInfoStringWith6 hasPrefix:@"6:"] ) {
            //冒号分割
            NSArray *colon = [carInfoStringWith6 componentsSeparatedByString:@":"];
            if ( [colon count] >= 2 ) {
                NSString *carInfoString = [colon objectAtIndex:1];
                NSArray *carInfoArray = [carInfoString componentsSeparatedByString:@";"];
                if ( [carInfoArray count] == 18 ) {
                    //更新车辆信息
                    [[CMCurrentCars getInstance] updateCurrentCarsInfo:carInfoArray];
                }
            }
        }
    }
}

/**车辆历史信息请求返回解析
 *@param recv:车辆历史信息请求接收到的数据
 *return result:历史数据数组键值*/
+ (NSMutableArray *)parseQueryHistoryTrackRecv:(NSData *)data
{
    NSString *recv = [NSString dataToStringConvert:data];
    NSLog(@"parseQueryHistoryTrackRecv recv: %@",recv);
    NSString *terminalNo = nil;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSMutableDictionary *history = [[NSMutableDictionary alloc] init];
    //分号分割数据
    NSArray *semicolon = [recv componentsSeparatedByString:@";"];
    if ( [semicolon count] > 0 ) {
        for ( NSString *historyInfos in semicolon ) {
            if ( [historyInfos hasPrefix:@"and1:"] ) {
                //冒号分割
                NSArray *comma = [historyInfos componentsSeparatedByString:@":"];
                if ( [comma count] >= 2 ) {
                    terminalNo = [comma objectAtIndex:1];
                    historyInfos = [comma objectAtIndex:2];
                }
            }
            //]分割
            if ( historyInfos != nil && historyInfos != @"" ) {
                NSMutableArray *bracket = [NSMutableArray arrayWithArray:[historyInfos componentsSeparatedByString:@"]"]];
                NSString *historyKey = [bracket objectAtIndex:0];
                [result addObject:historyKey];
                [bracket removeObjectAtIndex:0];
                [history setObject:bracket forKey:historyKey];
            }
        }
    }

    CurrentCarInfo *theCurrentCar = [[CMCurrentCars getInstance] theCurrentCarInfo:terminalNo];
    theCurrentCar.history = history;
    NSLog(@"history = %@",theCurrentCar.history);
    [[CMCurrentCars getInstance] updateCurrentCarsInfoWithCurrentCarInfo:theCurrentCar];
    [history release];
    return [result autorelease];
}

/**车辆油量信息请求返回解析
 *@param recv:车辆历史信息请求接收到的数据
 *return result:历史油量数据*/
+ (NSString *)parseQueryOilAnalysisRecv:(NSData *)data
{
    NSString *recv = [NSString dataToStringConvert:data];
    NSLog(@"recv = %@",recv);
    NSString *terminalNo = nil;
    NSString *result = [[NSString alloc] init];
    NSMutableArray *oil = [[NSMutableArray alloc] init];
    //分号分割数据
    NSArray *semicolon = [recv componentsSeparatedByString:@";"];
    if ( [semicolon count] > 0 ) {
        for ( NSString *oilHistoryInfos in semicolon ) {
            if ( [oilHistoryInfos hasPrefix:@"and2:"] ) {
                //冒号分割
                NSArray *comma = [oilHistoryInfos componentsSeparatedByString:@":"];
                if ( [comma count] > 1 ) {
                    terminalNo = [comma objectAtIndex:1];
//                    oilHistoryInfos = [comma objectAtIndex:[comma count] -1];
                }
            }
            else if ( [oilHistoryInfos isEqualToString:@""] || oilHistoryInfos == nil ) {
                
            }
            else {
                [oil addObject:oilHistoryInfos];
                result = [result stringByAppendingFormat:@"%@\n",oilHistoryInfos];
            }

        }
    }
    
    CurrentCarInfo *theCurrentCar = [[CMCurrentCars getInstance] theCurrentCarInfo:terminalNo];
    theCurrentCar.oil = oil;
    [[CMCurrentCars getInstance] updateCurrentCarsInfoWithCurrentCarInfo:theCurrentCar];
    [oil release];
    NSLog(@"result = %@",result);
    if ( [result hasPrefix:@"and2:"] || [result isEqualToString:@""] || result == nil ) {
        return @"查询时间段内没有油量历史数据,请重新选择查询时段";
    }
    
    NSLog(@"oil = %@",theCurrentCar.oil);
    
    return result;
}



/**拍照返回数据解析
 *@param recv:拍照接收到的数据
 **/
+ (void)ParsetakePhotoRecv:(NSData *)data
{
    NSString *recv = [NSString dataToStringConvert:data];
    if ( [recv hasPrefix:@"60:"] ) {
        //冒号分割
        NSArray *comma = [recv componentsSeparatedByString:@":"];
        if ( [comma count] == 4 ) {
            NSString *terminalNo = [comma objectAtIndex:1];
            CarInfo *theCarInfo = [[CMCars getInstance] theCarInfo:terminalNo];
            theCarInfo.lastPhotoName = [comma objectAtIndex:2];
            theCarInfo.lastPhotoTime = [[comma objectAtIndex:3] longLongValue] / 1000;
            [[CMCars getInstance] updateCarInfo:terminalNo newCarInfo:theCarInfo];
            NSLog(@"theCarInfo.lastPhotoTime = %f",theCarInfo.lastPhotoTime);
        }
    }
}

/**拍照后在服务器获取照片url地址
 *@param terminalNo:终端号
 *return url:获取照片url*/
+ (NSString *)photoRequestUrl:(NSString *)terminalNo
{
    CMConfig *config = [CMConfig globalConfig];
    //terminalNo 分12位OR16位
    NSRange dateRange = NSMakeRange(0, 0);
    if ( [terminalNo length] == 16 ) {
        dateRange = NSMakeRange(17, 8);
    }
    else if ( [terminalNo length] == 12 ) {
        dateRange = NSMakeRange(15, 8);
    }
    
    CarInfo *theCarInfo = [[CMCars getInstance] theCarInfo:terminalNo];
    NSString *photoDate = theCarInfo.lastPhotoName;
    NSString *relativePath = [photoDate substringWithRange:dateRange];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@.JPEG",config.photoUrl,relativePath,theCarInfo.lastPhotoName];
    
    return url;
}

/**获取对应车类型的车图片
 *@param carType:车类型
 *return key:对应车类型的图片的key*/
+ (NSString *)carImage:(CMCarType)carType
{
    NSString *key = nil;
    if ( carType == CMCarTypeNormal ) {
        key = @"car_red";
    }
    else if ( carType == CMCarTypeMixer ) {
        key = @"crane";
    }
    else if ( carType == CMCarTypeAntiTheft ) {
        key = @"truck";
    }
    
    return key;
}

/**车速
 *@param speed:车速(float类型)
 *return param:车速:value*/
+ (NSString *)carSpeedParam:(float)speed
{
    NSString *param = [[NSString alloc] initWithFormat:@"车速(km/h):\n%f",speed];
    
    return [param autorelease];
}

/**位置
 *@param carPosition:车辆位置
 *return 位置:value*/
+ (NSString *)carPositionParam:(NSString *)carPosition
{
    NSString *param = [[NSString alloc] initWithFormat:@"位置:%@",carPosition];
    
    return [param autorelease];
}


/**获取对应车类型的车图片
 *@param carType:车类型
 *return keys:对应车类型的图片的keys*/


/**适应cell的车牌号码字符串
 *@param carNoParam:车牌号
 *return carNo:适应cell的车牌号*/
+ (NSString *)carNoAdjustmentParam:(NSString *)carNoParam
{
    NSString *carNo = [NSString stringWithFormat:@"         %@",carNoParam];
    
    return carNo;
}

/**适应cell的车速字符串
 *@param carSpeedParam:车速
 *return carSpeed:适应cell的车速*/
+ (NSString *)carSpeedAdjustmentParam:(float)carSpeedParam
{
    NSString *carSpeed = [NSString stringWithFormat:@"                   %f",carSpeedParam];
    
    return carSpeed;
}

/**适应cell的车状态
 *@param carStateParam:车牌号
 *return carState:适应cell的车状态*/
+ (NSString *)carStateAdjustmentParam:(NSString *)carStateParam
{
    NSString *carState = [NSString stringWithFormat:@"         %@",carStateParam];
    
    return carState;
}

/**适应cell的车位置字符串
 *@param carPositionParam:车位置
 *return carPosition:适应cell的车位置*/
+ (NSString *)carPositionAdjustmentParam:(NSString *)carPositionParam
{
    NSString *carPosition = [NSString stringWithFormat:@"         %@",carPositionParam];
    
    return carPosition;
}

/**时区转换
 *@param forDate:待转换的时间
 *return newDate:转换后的时间*/
+ (NSDate *)convertDateToLocalTime:(NSDate *)forDate 
{
    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    int timeOffset = [nowTimeZone secondsFromGMTForDate:forDate];
    
    NSDate *newDate = [forDate dateByAddingTimeInterval:timeOffset];    
    return newDate;
}

@end
