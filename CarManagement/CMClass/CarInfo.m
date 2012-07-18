//
//  CarInfo.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-7.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "CarInfo.h"

@implementation Dirver
@synthesize dirverName = _dirverName;
@synthesize dirverTel = _dirverTel;

- (id)initWithParam:(NSString *)name tel:(NSString *)tel
{
    self = [super init];
    if ( self ) {
        self.dirverName = name;
        self.dirverTel = tel;
    }
    
    return self;
}
@end

@implementation CarInfo

@synthesize companyName = _companyName;
@synthesize carSIMNo = _carSIMNo;
@synthesize terminalNo = _terminalNo;
@synthesize carNo = _carNo;
@synthesize drivers = _drivers;
@synthesize lastPhotoName = _lastPhotoName;
@synthesize lastPhoto = _lastPhoto;
@synthesize hasNewPhoto = _hasNewPhoto;
@synthesize lastPhotoTime = _lastPhotoTime;
@synthesize carType = _carType;
@synthesize cameraNum = _cameraNum;


/**初始化car
 *@param carInfo:数组,包含car的基本属性字段
 *return self*/
- (id)initWithParam:(NSArray *)carInfoParam
{
    self = [super init];
    if ( self ) {
        NSArray *carInfo = [NSArray arrayWithArray:carInfoParam];
        //self.companyName = [carInfo objectAtIndex:0];
        self.terminalNo = [carInfo objectAtIndex:0];
        self.carNo = [carInfo objectAtIndex:1];
        self.carSIMNo = [carInfo objectAtIndex:2];
        self.carType = [[carInfo objectAtIndex:3] intValue];
        self.cameraNum = [[carInfo objectAtIndex:4] intValue];
        Dirver *dirver1 = [[Dirver alloc] initWithParam:[carInfo objectAtIndex:5] tel:[carInfo objectAtIndex:6]];
        Dirver *dirver2 = [[Dirver alloc] initWithParam:[carInfo objectAtIndex:7] tel:[carInfo objectAtIndex:8]];
        if ( [dirver1.dirverName isEqualToString:dirver2.dirverName] && [dirver1.dirverTel isEqualToString:dirver2.dirverTel] ) {
           // Dirver *test1 = [[Dirver alloc] initWithParam:@"lyfing" tel:@"18705925519"];
            Dirver *test2 = [[Dirver alloc] initWithParam:@"fenge" tel:@"18600345330"];
            self.drivers = [[NSArray alloc] initWithObjects:dirver1,test2,nil];
            [test2 release];
            
//            self.drivers = [NSArray arrayWithObjects:dirver1,nil];
        }
        else 
            self.drivers = [[NSArray alloc] initWithObjects:dirver1,dirver2, nil];
        [dirver1 release];
        [dirver2 release];
    }
    
    return self;
}

@end



@implementation CMCars

static CMCars *_instance = nil;
@synthesize cars = _cars;

- (void)dealloc
{
    [_cars release];
    
    [super dealloc];
}

/**初始化
 *@param carsInfoParam:车辆信息数组,数组内容为车辆对象
 *return 实例*/
- (id)initwithCarsInfoParam:(NSMutableArray *)carsInfoParam
{
    self = [super init];
    if ( self ) {
        NSMutableDictionary *carInfoDics = [[NSMutableDictionary alloc] init];
        NSString *key;
        for ( CarInfo *theCarInfo in carsInfoParam ){
            key = theCarInfo.terminalNo;
            [carInfoDics setObject:theCarInfo forKey:key];
        }
        
        self.cars = carInfoDics;
        [carInfoDics release];
    }
    
    return self;
}

/**获取单利
 *@param nil
 *return _instance:单利*/
+ (CMCars *)getInstance
{
    @synchronized(self){
        if ( !_instance ) {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

/**获取所有key值(车牌号)
 *@param nil
 *return 所有车牌号*/
- (NSArray *)carNos
{
    NSMutableArray *carNos = [[[NSMutableArray alloc] init] autorelease];
    for ( id key in self.cars ) {
        CarInfo *theCarInfo = [self.cars objectForKey:key];
        [carNos addObject:theCarInfo.carNo];
    }
    
    return [NSArray arrayWithArray:carNos];
}

/**获取所有终端号
 *@param nil
 *return 所有车终端号*/
- (NSArray *)getAllTerminalNo
{
    NSMutableArray *terminalNos = [[[NSMutableArray alloc] init] autorelease];
    for ( id key in self.cars ){
        CarInfo *theCarInfo = [self.cars objectForKey:key];
        [terminalNos addObject:theCarInfo.terminalNo];
    }
    
    return [NSArray arrayWithArray:terminalNos];
}

/**由终端获取车辆信息
 *@param carNo:车牌号
 *return theCarInfo:车辆信息*/
- (CarInfo *)theCarInfo:(NSString *)terminalNo
{
    return [self.cars objectForKey:terminalNo];
}

/**更新车辆信息
 *@param terminalNo:终端编号 newCar:车辆信息
 *@return nil*/
- (void)updateCarInfo:(NSString *)terminalNo newCarInfo:(CarInfo *)newCar
{
    if ( terminalNo != nil ) {
        CarInfo *theCarInfo = [[CMCars getInstance] theCarInfo:terminalNo];
        theCarInfo.drivers = newCar.drivers;
        theCarInfo.lastPhoto = newCar.lastPhoto;
        theCarInfo.lastPhotoName = newCar.lastPhotoName;
        theCarInfo.lastPhotoTime = newCar.lastPhotoTime;
        
        [self.cars removeObjectForKey:terminalNo];
        [self.cars setObject:theCarInfo forKey:terminalNo];
    }
}

/**通过车牌号获取终端号码
 *@param carNo:车牌号
 *return terminalNo:终端号*/
- (NSString *)getTerminalNoByCarNo:(NSString *)carNo
{
    for ( id key in self.cars ) {
        CarInfo *theCarInfo = [self.cars objectForKey:key];
        if ( [theCarInfo.carNo isEqualToString:carNo] ) {
            return key;
        }
    }
    
    return nil;
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
    return  _instance;
}

- (oneway void)release
{
    
}

- (unsigned)retainCount
{
    return UINT_MAX;
}

- (id)autorelease
{
    return self;
}

@end