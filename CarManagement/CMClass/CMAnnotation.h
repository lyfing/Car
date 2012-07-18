//
//  CMAnnotation.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-10.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CMAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D _coordinate;
    
    NSString *_title;
    
    NSString *_subtitle;
}

@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle;

- (void)moveAnnotation:(CLLocationCoordinate2D)newCoordinate;

- (NSString *)title;

- (NSString *)subtitle;
@end
