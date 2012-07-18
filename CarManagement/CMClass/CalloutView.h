//
//  CalloutView.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-25.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <MapKit/MapKit.h>

@class CalloutView;
@protocol CalloutMapAnnotationDelegate 

@optional
- (void)tapAnnotationView;

@end

@interface CalloutView : MKAnnotationView
@property(nonatomic,strong) MKAnnotationView * parentAnnotationView;
@property(nonatomic,strong) MKMapView * mapView;
@property(nonatomic,strong) UIView * contentView;
@property(nonatomic,assign) CGPoint offsetFromParent;
@property(nonatomic,assign) CGFloat contentHeight;//标签高度
@property(nonatomic,assign) CGFloat contentWeight;//标签宽度
@property(assign) id CalloutDelegate;//标签点击响应方法

-(void) animateIn;//第一步动画
-(void) animateInStepTwo;//第二步动画
-(void) animateInStepThree;//第三步动画
@end