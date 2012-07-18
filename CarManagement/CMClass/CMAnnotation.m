//
//  CMAnnotation.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-10.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "CMAnnotation.h"

@implementation CMAnnotation
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;

- (void)dealloc
{
    self.title = nil;
    self.subtitle = nil;
    
    [super dealloc];
}


- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)title subtitle:(NSString *)subtitle
{
    self = [super init];
    if ( self ) {
        _coordinate = c;
        self.title = title;
        self.subtitle = subtitle; 
    }
    
    return self;
}


- (NSString *)subtitle 
{
    return _subtitle;
}


- (NSString *)title
{
    return _title;
}

- (void)moveAnnotation:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}
@end
