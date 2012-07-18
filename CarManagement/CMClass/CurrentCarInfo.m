//
//  CurrentCarInfo.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-8.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "CurrentCarInfo.h"

@implementation CurrentCarInfo
@synthesize currentLocation = _currentLocation;
@synthesize currentLocations = _currentLocations;
@synthesize warn = _warn;
@synthesize speed = _speed;
@synthesize mileage = _mileage;
@synthesize direction = _direction;
@synthesize lastTransmissionTime = _lastTransmissionTime;
@synthesize continueDirverTime = _continueDirverTime;
@synthesize oilLeft = _oilLeft;
@synthesize carPosition = _carPosition;
@synthesize voltage = _voltage;
@synthesize expand1 = _expand1;
@synthesize expand2 = _expand2;
@synthesize photoName = _photoName;
@synthesize uitrasonicWaveDistance = _uitrasonicWaveDistance;
@synthesize lastTakePhotoTime = _lastTakePhotoTime;
@synthesize version = _version;
@synthesize history = _history;
@synthesize oil = _oil;

- (void)dealloc
{
    [_history release];
    [_oil release];
    [_currentLocations release];
    
    [super dealloc];
}
/**初始化currentCar
 *@param currentCarInfo:数组，包含currentCar的基本属性字段
 *return self*/
- (id)initWithParam:(NSArray *)currentCarInfoParam
{
    self = [super init];
    if ( self ) {
        NSArray *currentCarInfo = [NSArray arrayWithArray:currentCarInfoParam];
        if ( [currentCarInfo count] == 18 ) {
            self.terminalNo = [currentCarInfo objectAtIndex:0];
            //获取当前位置
            CLLocationCoordinate2D currentLocation = CLLocationCoordinate2DMake([[currentCarInfo objectAtIndex:1] floatValue], [[currentCarInfo objectAtIndex:2] floatValue]);
            //line 59 测试
            self.currentLocation = currentLocation;
            //获取最近一次位置数据
//            if ( [self.currentLocations count] > 0 ) {
//                NSData *lastLocationData = [self.currentLocations objectAtIndex:0];
//                CLLocationCoordinate2D lastLocation;
//                [lastLocationData getBytes:&lastLocation length:sizeof(CLLocationCoordinate2D)];
//                //如果两次数据相同则不加入数组
//                if ( currentLocation.latitude == lastLocation.latitude && currentLocation.longitude == lastLocation.longitude ) {
//                    
//                }
//                else {
//                    [self.currentLocations addObject:[NSData dataWithBytes:&currentLocation length:sizeof(CLLocationCoordinate2D)]];
//                }
//            }
            self.speed = [[currentCarInfo objectAtIndex:3] floatValue];
            self.warn = [[currentCarInfo objectAtIndex:4] longLongValue];
            self.direction = [[currentCarInfo objectAtIndex:5] floatValue];
            self.mileage = [[currentCarInfo objectAtIndex:6] floatValue];
            self.lastTransmissionTime = [[currentCarInfo objectAtIndex:7] longLongValue];
            self.continueDirverTime = [[currentCarInfo objectAtIndex:8] longLongValue];
            self.oilLeft = [[currentCarInfo objectAtIndex:9] floatValue];
            self.carPosition = [currentCarInfo objectAtIndex:10];
            self.voltage = [[currentCarInfo objectAtIndex:11] floatValue];
            self.expand1 = [currentCarInfo objectAtIndex:12];
            self.version = [currentCarInfo objectAtIndex:13];
            self.expand2 = [currentCarInfo objectAtIndex:14];
            self.photoName = [currentCarInfo objectAtIndex:15];
            self.uitrasonicWaveDistance = [[currentCarInfo objectAtIndex:16] floatValue];
            self.lastTakePhotoTime = [[currentCarInfo objectAtIndex:17] longLongValue];
            self.history = nil;
            self.oil = nil;
        }
    }
    
    return self;
}

@end

@implementation CMCurrentCars

static CMCurrentCars *_instance = nil;
@synthesize currentCars = _currentCars;

- (void)dealloc
{
    [_currentCars release];
    
    [super dealloc];
}

/**初始化
 *@param currentCarParam:当前车辆信息数组,数组内容为当前车辆信息对象
 *return 实例*/
- (id)initWithCurrentCarInfoParam:(NSMutableArray *)currentCarsInfoParam
{
    self = [super init];
    if ( self ) {
        NSMutableDictionary *currentCarDics = [[NSMutableDictionary alloc] init];
        NSString *key;
        for ( CurrentCarInfo *theCurrentCarInfo in currentCarsInfoParam ){
            key = theCurrentCarInfo.terminalNo;
            //currentCarInfo 从 carInfo赋值
            [currentCarDics setObject:theCurrentCarInfo forKey:key];
        }
        
        self.currentCars = currentCarDics;
        [currentCarDics release];
    }
    
    return self;
}

/**获取单利
 *@param nil
 *return _instance:单利*/
+ (CMCurrentCars *)getInstance
{
    @synchronized(self){
        if ( !_instance ) {
           _instance = [[CMCurrentCars alloc] init];
        }
    }
    
    return _instance;
}

/**获取所有终端号
 *@param nil
 *return 所有车终端号*/
- (NSArray *)getAllTerminalNo
{
    NSMutableArray *terminalNos = [[[NSMutableArray alloc] init] autorelease];
    for ( id key in self.currentCars ){
        [terminalNos addObject:key];
    }
    
    return [NSArray arrayWithArray:terminalNos];
}

/**由终端号获取当前车辆信息
 *@param terminalNo:车牌号
 *return theCarInfo:车辆信息*/
- (CurrentCarInfo *)theCurrentCarInfo:(NSString *)terminalNo
{
    return [self.currentCars objectForKey:terminalNo];
}

/**更新车辆信息
 *@param newCarsInfo:新车辆信息数据
 *return nil*/
- (void)updateCurrentCarsInfo:(NSArray *)newCarsInfo
{
    NSString *key = [newCarsInfo objectAtIndex:0];
    CurrentCarInfo *theNewCarInfo = [[CurrentCarInfo alloc] initWithParam:newCarsInfo];
    [self.currentCars removeObjectForKey:key];
    [self.currentCars setObject:theNewCarInfo forKey:key];
    [theNewCarInfo release];
    NSLog(@"CurrentCarInfo update");
}

/**更新车辆信息
 *@param newCurrentCarInfo:新车辆信息数据
 *return nil*/
- (void)updateCurrentCarsInfoWithCurrentCarInfo:(CurrentCarInfo *)newcurrentCarInfo
{
    if ( newcurrentCarInfo ) {
        NSString *key = newcurrentCarInfo.terminalNo;
        [self.currentCars removeObjectForKey:key];
        [self.currentCars setObject:newcurrentCarInfo forKey:key];
    }
}

/**清除CMCars单例
 *@param nil
 *return nil*/
- (void)clear
{
    _instance = nil;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if ( !_instance ) {
            _instance = [super allocWithZone:zone];
            return _instance;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (unsigned)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
    NSLog(@"CurrentCarInfo release~~~~");
}

- (id)autorelease
{
    return self;
}
@end