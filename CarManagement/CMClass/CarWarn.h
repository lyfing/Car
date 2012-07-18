//
//  CarWarn.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-9.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarWarn : NSObject
{
    NSString *_originalNormalCarWarn;
    
    NSString *_originalMixerCarWarn;
    
    NSString *_originalAntiTheftCarWarn;
}

@property (nonatomic,copy) NSString *originalNormalCarWarn;
@property (nonatomic,copy) NSString *originalMixerCarWarn;
@property (nonatomic,copy) NSString *originalAntiTheftCarWarn;


/**获取全局实例
 *@param nil
 *return nil*/
+ (CarWarn *)globalConfig;

/**普通车辆报警信息数组
 *@param nil
 *return param:普通车辆报警信息数组*/
- (NSArray *)normalCarWarnParam;

/**搅拌型车辆报警信息数组
 *@param nil
 *return param:搅拌型车辆报警信息数组*/
- (NSArray *)mixerCarWarnParam;

/**防盗车辆报警信息数组
 *@param nil
 *return param:防盗车辆报警信息数组*/
- (NSArray *)antiTheftCarWarnParam;

/**更具车型返回原始报警字符串数组
 *@param carType:车型
 *return param:车型对应的字符串数组*/
- (NSArray *)originalCarWarn:(CMCarType)carType;

/**获取当前车辆报警(车辆状态)
 *@param warn:报警值 carType:车型 logicLevel:逻辑程度(暂时没用到赋值nil)
 *return result:报警数据*/
- (NSString *)currentCarWarn:(long)warn carType:(CMCarType)carType logicLevel:(NSString *)logicLevel;

@end

