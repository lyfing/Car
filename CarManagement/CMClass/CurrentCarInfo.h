//
//  CurrentCarInfo.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-8.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "CarInfo.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface CurrentCarInfo : CarInfo
{
    //位置
    CLLocationCoordinate2D _currentLocation;
    //当前位置数据
    NSMutableArray *_currentLocations;
    //速度
    float _speed;
    //报警位(车辆状态)
    long _warn;
    //里程
    float _mileage;
    //方向
    float _direction;
    //车辆传输数据时间
    long _lastTransmissionTime;
    //连续驾驶时间
    long _continueDirverTime;
    //油量
    float _oilLeft;
    //位置信息
    NSString *_carPosition;
    //电压
    float _voltage;
    //扩展内容1
    NSString *_expand1;
    //扩展内容2
    NSString *_expand2;
    //版本号
    NSString *_version;
    //照片名字
    NSString *_photoName;
    //超声波距离
    float _uitrasonicWaveDistance;
    //最后拍摄时间
    long _lastTakePhotoTime;
    //历史数据
    NSMutableDictionary *_history;
    //油量分析
    NSMutableArray *_oil;
}
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (nonatomic,retain) NSMutableArray *currentLocations;
@property (nonatomic) float speed;
@property (nonatomic) long warn;
@property (nonatomic) float mileage;
@property (nonatomic) float direction;
@property (nonatomic) long lastTransmissionTime;
@property (nonatomic) long continueDirverTime;
@property (nonatomic) float oilLeft;
@property (nonatomic,copy) NSString *carPosition;
@property (nonatomic) float voltage;
@property (nonatomic,copy) NSString *expand1;
@property (nonatomic,copy) NSString *expand2;
@property (nonatomic,copy) NSString *version;
@property (nonatomic,copy) NSString *photoName;
@property (nonatomic) float uitrasonicWaveDistance;
@property (nonatomic) long lastTakePhotoTime;
@property (nonatomic,retain) NSMutableDictionary *history;
@property (nonatomic,retain) NSMutableArray *oil;

/**初始化currentCar
 *@param currentCarInfo:数组，包含currentCar的基本属性字段
 *return self*/
- (id)initWithParam:(NSArray *)currentCarInfoParam;
@end


@interface CMCurrentCars : NSObject
{
    NSMutableDictionary *_currentCars;
}

@property (nonatomic,retain) NSMutableDictionary *currentCars;
/**初始化
 *@param currentCarParam:当前车辆信息数组,数组内容为当前车辆信息对象
 *return 实例*/
- (id)initWithCurrentCarInfoParam:(NSMutableArray *)currentCarsInfoParam;

/**获取单利
 *@param nil
 *return _instance:单利*/
+ (CMCurrentCars *)getInstance;

/**获取所有终端号
 *@param nil
 *return 所有车终端号*/
- (NSArray *)getAllTerminalNo;

/**由终端号获取当前车辆信息
 *@param terminalNo:车牌号
 *return theCarInfo:车辆信息*/
- (CurrentCarInfo *)theCurrentCarInfo:(NSString *)terminalNo;

/**更新车辆信息
 *@param newCarsInfo:新车辆信息数据
 *return nil*/
- (void)updateCurrentCarsInfo:(NSArray *)newCarsInfo;

/**更新车辆信息
 *@param newCurrentCarInfo:新车辆信息数据
 *return nil*/
- (void)updateCurrentCarsInfoWithCurrentCarInfo:(CurrentCarInfo *)newcurrentCarInfo;

/**清除CMCars单例
 *@param nil
 *return nil*/
- (void)clear;
@end

