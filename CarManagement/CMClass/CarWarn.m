//
//  CarWarn.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-9.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "CarWarn.h"

static CarWarn *_globalConfig = nil;

@implementation CarWarn

@synthesize originalNormalCarWarn = _originalNormalCarWarn;
@synthesize originalMixerCarWarn = _originalMixerCarWarn;
@synthesize originalAntiTheftCarWarn = _originalAntiTheftCarWarn;

- (void)dealloc
{
    self.originalNormalCarWarn = nil;
    self.originalMixerCarWarn = nil;
    self.originalAntiTheftCarWarn = nil;
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if ( self)  {
        self.originalNormalCarWarn = @" ,掉电,GPS无信号, ,油门断开, ,停车,非法移动, , , , , ,断电,ACC开, ,短信报警开,Gprs报警开,越界报警,越界报警开, , ,超速,GPRS掉线, , , , ,加油, ,偷油,工作时间外驾车, , , , ,有人在岗";
        self.originalMixerCarWarn = @" ,掉电,GPS无信号,搅拌,油门断开, ,停车,非法移动, ,卸料, , , ,断电,ACC开, ,短信报警开,Gprs报警开,越界报警,越界报警开, , ,超速, GPRS掉线, , , , ,加油, ,偷油,工作时间外驾车, , , , ,有人在岗";
        self.originalAntiTheftCarWarn = @" ,掉电,GPS无信号,车子锁定,油门断开, ,停车,非法移动, ,车门开, , , ,断电,ACC开, ,短信报警开,Gprs报警开,越界报警,越界报警开, , ,超速,GPRS掉线, , , , ,加油, ,偷油,工作时间外驾车, , , , ,有人在岗";
    }
    
    return self;
}

/**获取全局实例
 *@param nil
 *return nil*/
+ (CarWarn *)globalConfig
{
    if ( !_globalConfig ) {
        _globalConfig = [[CarWarn alloc] init];
    }
    
    return _globalConfig;
}

/**普通车辆报警信息数组
 *@param nil
 *return param:普通车辆报警信息数组*/
- (NSArray *)normalCarWarnParam
{
    NSArray *param = nil;
    param = [self.originalNormalCarWarn componentsSeparatedByString:@","];
    
    return param;
}

/**搅拌型车辆报警信息数组
 *@param nil
 *return param:搅拌型车辆报警信息数组*/
- (NSArray *)mixerCarWarnParam
{
    NSArray *param = nil;
    param = [self.originalMixerCarWarn componentsSeparatedByString:@","];
    
    return param;
}

/**防盗车辆报警信息数组
 *@param nil
 *return param:防盗车辆报警信息数组*/
- (NSArray *)antiTheftCarWarnParam
{
    NSArray *param = nil;
    param = [self.originalAntiTheftCarWarn componentsSeparatedByString:@","];
    
    return param;
}

/**更具车型返回原始报警字符串数组
 *@param carType:车型
 *return param:车型对应的字符串数组*/
- (NSArray *)originalCarWarn:(CMCarType)carType
{
    NSArray *param = nil;
    if ( carType == CMCarTypeNormal ) {
        param = [[CarWarn globalConfig] normalCarWarnParam];
    }
    else if ( carType == CMCarTypeMixer )
    {
        param = [[CarWarn globalConfig] mixerCarWarnParam];
    }
    else if ( carType == CMCarTypeAntiTheft )
    {
        param = [[CarWarn globalConfig] antiTheftCarWarnParam];
    }
    
    return param;
}

/**获取当前车辆报警(车辆状态)
 *@param warn:报警值 carType:车型 logicLevel:逻辑程度(暂时没用到赋值nil)
 *return result:报警数据*/
- (NSString *)currentCarWarn:(long)warn carType:(CMCarType)carType logicLevel:(NSString *)logicLevel
{
    NSString *result = [[NSString alloc] init]; 
    long flag = 1L;
    
    NSArray *theCarWarn = [[CarWarn globalConfig] originalCarWarn:carType];
    NSArray *logicLevelArray = nil;
    if ( !logicLevel ) {
        logicLevelArray = [logicLevel componentsSeparatedByString:@"]"];
    }
    
    for ( int i = 0; i < [theCarWarn count]; i ++ ) {
        if ( (warn & flag ) > 0 && ( flag == DOOR || flag == BELOCKED || flag == USERALARM ) && logicLevelArray != nil && logicLevelArray.count > 0 ) {
            NSString *logicLevel1 = [logicLevelArray objectAtIndex:1];
            if ( flag == DOOR ) {
                if ( ![logicLevel1 isEqualToString:@""]  && [logicLevelArray count] > 0 ) {
                    result = [result stringByAppendingFormat:@"%@,",[logicLevelArray objectAtIndex:1]];
                }
                else {
                    result = [result stringByAppendingFormat:@"%@,",[theCarWarn objectAtIndex:i]];
                }
            }
            else if ( flag == BELOCKED && [logicLevelArray count] > 1 ) {
                if ( ![@"" isEqualToString:[logicLevelArray objectAtIndex:0]] ) {
                    result = [result stringByAppendingFormat:@"%@,",[logicLevelArray objectAtIndex:0]];
                }
                else {
                    result = [result stringByAppendingFormat:@"%@,",[theCarWarn objectAtIndex:i]];
                }
            }
            else if (  flag == USERALARM && [logicLevelArray count] > 2 ) {
                if ( ![@"" isEqualToString:[logicLevelArray objectAtIndex:2]] ) {
                    result = [result stringByAppendingFormat:@"%@,",[logicLevelArray objectAtIndex:2]];
                }
                else {
                    result = [result stringByAppendingFormat:@"%@,",[theCarWarn objectAtIndex:i]];
                }
            }
        }
        else {
            if ( ( warn & flag ) > 0 ) {
                result = [result stringByAppendingFormat:@"%@,",[theCarWarn objectAtIndex:i]];
            }
        }
        
        flag = flag * 2L;
    }
    //冒号分割,去除多余,
    NSArray *comma = [result componentsSeparatedByString:@","];
    result = @"";
    for ( NSInteger i = 0; i < [comma count]; i ++ ) {
        if ( ![[comma objectAtIndex:i] isEqualToString:@" "] && ![[comma objectAtIndex:i] isEqualToString:@""] ) {
            result = [result stringByAppendingFormat:@"%@,",[comma objectAtIndex:i]];
        }
    }
    while ( [result hasSuffix:@","] ) {
        result = [result substringToIndex:result.length - 1];
    }
    
    return result;
}

@end
