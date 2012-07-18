//
//  CarInfo.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-7.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dirver : NSObject
{
    NSString *_dirverName;
    NSString *_dirverTel;
}

@property (nonatomic,copy) NSString *dirverName;
@property (nonatomic,copy) NSString *dirverTel;

@end

@interface CarInfo : NSObject
{
    NSString *_companyName;
	NSString *_carSIMNo;
	NSString *_terminalNo;
    NSString *_carNo;
    CMCarType _carType;
    NSInteger _cameraNum;
    NSArray *_drivers;
    
    //lastPhoto info
    NSString *_lastPhotoName;
	NSTimeInterval _lastPhotoTime;
    UIImage *_lastPhoto;
}

@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *carSIMNo;
@property (nonatomic,copy) NSString *terminalNo;
@property (nonatomic,copy) NSString *carNo;
@property (nonatomic,copy) NSString *lastPhotoName;
@property (nonatomic) NSTimeInterval lastPhotoTime;
@property (nonatomic,retain) UIImage *lastPhoto;
@property (nonatomic) CMCarType carType;
@property (nonatomic) NSInteger cameraNum;
@property (nonatomic,retain) NSArray *drivers;
@property (nonatomic) BOOL hasNewPhoto;


/**初始化car
 *@param carInfo:数组,包含car的基本属性字段
 *return self*/
- (id)initWithParam:(NSArray *)carInfoParam;
@end



@interface CMCars : NSObject
{
    NSMutableDictionary *_cars;
}

@property (nonatomic,retain) NSMutableDictionary *cars;

/**初始化
 *@param carsInfoParam:车辆信息数组,数组内容为车辆对象
 *return 实例*/
- (id)initwithCarsInfoParam:(NSMutableArray *)carsInfoParam;

/**获取单利
 *@param nil
 *return _instance:单利*/
+ (CMCars *)getInstance;

/**获取所有key值(车牌号)
 *@param nil
 *return 所有车牌号*/
- (NSArray *)carNos;

/**获取所有终端号
 *@param nil
 *return 所有车终端号*/
- (NSArray *)getAllTerminalNo;

/**由终端获取车辆信息
 *@param carNo:车牌号
 *return theCarInfo:车辆信息*/
- (CarInfo *)theCarInfo:(NSString *)terminalNo;

/**更新车辆信息
 *@param terminalNo:终端编号 newCar:车辆信息
 *@return nil*/
- (void)updateCarInfo:(NSString *)terminalNo newCarInfo:(CarInfo *)newCar;

/**通过车牌号获取终端号码
 *@param carNo:车牌号
 *return terminalNo:终端号*/
- (NSString *)getTerminalNoByCarNo:(NSString *)carNo;

/**清除CMCars单例
 *@param nil
 *return nil*/
- (void)clear;

@end