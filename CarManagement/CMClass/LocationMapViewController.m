//
//  LocationMapViewController.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-6.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "LocationMapViewController.h"
#import "LocationDetailViewController.h"
#import "AppDelegate.h"

#define FIELD_DATE_BEGIN_Y            5
#define FIELD_DATE_BEGIN_MAX_X        155
#define FIELD_DATE_END_BEGIN_MIN_X    165  
#define kAlertEndDateWrong            2000
#define kAlertDatesIntervalWrong      2001

@interface LocationMapViewController ()

@end

@implementation LocationMapViewController
@synthesize mapView = _mapView;
@synthesize historyTrackView = _historyTrackView;
@synthesize lineColor = _lineColor;
@synthesize terminalNo = _terminalNo;
@synthesize locationMgr = _locationMgr;
@synthesize currentLocation = _currentLocation;
@synthesize region = _region;
@synthesize span = _span;
@synthesize annotation = _annotation;
@synthesize annotations = _annotations;
@synthesize locationAddress = _locationAddress;
@synthesize geocoder = _geocoder;
@synthesize detailBtn = _detailBtn;
@synthesize socket = _socket;
@synthesize recv = _recv;
@synthesize dateView = _dateView;
@synthesize dateBegin = _dateBegin;
@synthesize dateEnd = _dateEnd;
@synthesize segLabel = _segLabel;
@synthesize datePicker = _datePicker;
@synthesize dateChoiceProcess = _dateChoiceProcess;
@synthesize isQueryOk = _isQueryOk;

/**初始化
 *@param terminalNo:终端号码
 *return self*/
- (id)initWithTerminalNo:(NSString *)terminalNoParam
{
    self = [super init];
    if ( self ) {
        self.terminalNo = terminalNoParam;
    }
    
    return self;
}

- (void)dealloc
{
    [_mapView release];
    [_historyTrackView release];
    [_locationMgr release];
    [_annotation release];
    [_detailBtn release];
    [_socket release];
    [_recv release];
    [_dateView release];
    [_dateBegin release];
    [_dateEnd release];
    [_datePicker release];
    [_segLabel release];
    [_annotations release];
 
    self.locationAddress = nil;
    self.terminalNo = nil;
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"GPS定位";
    self.navigationController.navigationBarHidden = YES;
    
    //2.0当前位置
//    UIImage *locationBtnImg = [[CMResManager getInstance] imageForKey:@"current_location"];
//    UIImage *historyBtnImg = [[CMResManager getInstance] imageForKey:@"history_trace"];
    UIImage *locationBtnImg = [[CMResManager getInstance] imageForKey:@"my_location_item"];
    UIImage *historyBtnImg = [[CMResManager getInstance] imageForKey:@"search_item"];
    [self setRightBtnEnabled:NO];
    [self addExtendBtnWithTarget:self touchUpInsideSelector:@selector(locationAction) normalImage:locationBtnImg hightLightedImage:nil];
    [self addExtendBtnWithTarget:self touchUpInsideSelector:@selector(queryHistoryTrackAction) normalImage:historyBtnImg hightLightedImage:nil];

    //3.0mapView
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, kCMNavigationBarHight, kFullScreenWidth, 400)];
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeStandard;
    self.mapView = mapView;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [mapView release];
    
    //3.1地图上划线
    UIImageView *historyTrackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kCMNavigationBarHight, kFullScreenWidth, self.mapView.frame.size.height)];
    historyTrackView.userInteractionEnabled = NO;
    self.historyTrackView = historyTrackView;
    [self.mapView addSubview:self.historyTrackView];
    [historyTrackView release];
    //3.2线
    self.lineColor = [UIColor colorWithWhite:0.2 alpha:0.5];

    //4.0地图上详细按钮
    UIButton *detailBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    detailBtn.frame = CGRectMake(0, 0, 23, 23);
    detailBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    detailBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [detailBtn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
    self.detailBtn = detailBtn;
    [detailBtn release];
    
    //5.0时间选择
    //5.1背景view
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, kFullScreenHight, kFullScreenWidth, 256)];
    dateView.backgroundColor = [UIColor grayColor];
    //5.2开始查询时间
    UITextField *dateBegin = [[UITextField alloc] initWithFrame:CGRectMake(15,5,140,30)];
    dateBegin.backgroundColor = [UIColor clearColor];
    dateBegin.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    dateBegin.textAlignment = UITextAlignmentCenter;
    dateBegin.textColor = [UIColor blueColor];
    dateBegin.userInteractionEnabled = NO;
    dateBegin.placeholder = @"查询开始日期";
    self.dateBegin = dateBegin;
    self.dateBegin.delegate = self;
    [dateView addSubview:self.dateBegin];
    [dateBegin release];
    //5.3中间分割，
    UILabel *segLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 5, 10, 30)];
    segLabel.backgroundColor = [UIColor clearColor];
    segLabel.textAlignment = UITextAlignmentCenter;
    segLabel.text = @"-";
    self.segLabel = segLabel;
    [dateView addSubview:self.segLabel];
    [segLabel release];
    //5.4结束时间
    UITextField *dateEnd = [[UITextField alloc] initWithFrame:CGRectMake(165, 5, 140, 30)];
    dateEnd.backgroundColor = [UIColor clearColor];
    dateEnd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    dateEnd.textAlignment = UITextAlignmentCenter;
    dateEnd.textColor = [UIColor blueColor];
    dateEnd.userInteractionEnabled = NO;
    dateEnd.placeholder = @"查询结束日期";
    self.dateEnd = dateEnd;
    self.dateEnd.delegate = self;
    [dateView addSubview:self.dateEnd];
    [dateEnd release];
    //5.5滚轮
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,40, kFullScreenWidth, 216)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(pickerValueChangedAction) forControlEvents:UIControlEventValueChanged];
    self.datePicker = datePicker;
    [dateView addSubview:self.datePicker];
    [datePicker release];
    
    self.dateView = dateView;
    [self.view addSubview:self.dateView];
    [dateView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1.0查询日期默认
    //1.1获取当前时间
    NSDateFormatter *dateFormater = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormater setDateFormat:kDateAndTimeHourFormater];
    NSString *theRightEndDate = [dateFormater stringFromDate:[NSDate date]];
    //1.2获取一周前的时间
    NSDate *now = [NSDate date];
    NSString *theRightBeginDate = [dateFormater stringFromDate:[now dateByAddingTimeInterval:-3600 * 24 * kQueryHistoryTimeInterval]];
    self.dateBegin.text = theRightBeginDate;
    self.dateEnd.text = theRightEndDate;
    //1.3滚轮初始化选择时间
    NSDate *currentTime = [[[NSDate alloc] init] autorelease];
    [self.datePicker setDate:currentTime animated:YES];
    //初始化地图
    //当前车辆信息
    CurrentCarInfo *theCurrentCarInfo = [[CMCurrentCars getInstance] theCurrentCarInfo:self.terminalNo];
    self.mapView.centerCoordinate = theCurrentCarInfo.currentLocation;
    MKCoordinateSpan span;
    MKCoordinateRegion region;
    span = MKCoordinateSpanMake(0.2, 0.2);
    region.span = span;
    region.center = self.currentLocation;
    [self.mapView setRegion:region];
    
    //地图上显示当前信息
    NSString *latitude = [NSString stringWithFormat:@"%f",theCurrentCarInfo.currentLocation.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",theCurrentCarInfo.currentLocation.longitude];
    NSArray *array = [NSArray arrayWithObjects:latitude,longitude,[NSString stringWithFormat:@"%ld",theCurrentCarInfo.warn] ,theCurrentCarInfo.carPosition,nil];
    [self showHistroryTrack:[now timeIntervalSince1970] history:array];
    //socket
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.socket = appDelegate.client;
    self.socket.delegate = self;

    self.isQueryOk = NO;
    //annotations初始化
    NSMutableArray *arrays = [[NSMutableArray alloc] init];
    self.annotations = arrays;
    [arrays release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self.locationMgr startUpdatingLocation];


}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.locationMgr stopUpdatingLocation];  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma buttonAction
/*@手指触发事件*/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.dateView];
    if ( point.y > FIELD_DATE_BEGIN_Y - 5 && point.y < FIELD_DATE_BEGIN_Y + 35 ) {
        
        if ( point.x < FIELD_DATE_BEGIN_MAX_X ) {
            self.dateBegin.text = @"";
            self.dateChoiceProcess = CMDateChoiceProcessBegin;
        }
        else if ( point.x > FIELD_DATE_END_BEGIN_MIN_X ){
            self.dateEnd.text = @"";
            self.dateChoiceProcess = CMDateChoiceProcessEnd;
        }
    }
}

/**显示滚轮
 *@param nil
 *return nil*/
- (void)showPickerView
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    self.dateView.center = CGPointMake(160, 283);
    [UIView commitAnimations];
}

/**隐藏滚轮
 *@param nil
 *return nil*/
- (void)hidePickerView
{
    [UIView beginAnimations:@"Animation" context:nil];
    [UIView setAnimationDuration:0.3];
    self.dateView.center = CGPointMake(160, 588);
    [UIView commitAnimations];    
}

/**滚轮数值改变
 *@param nil
 *return nil*/
- (void)pickerValueChangedAction
{
    NSDate *selected = [self.datePicker date];
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:kDateAndTimeHourFormater];
    NSString *theDate = [dateFormat stringFromDate:selected];
    switch ( self.dateChoiceProcess ) {
        case CMDateChoiceProcessBegin:
        {
            self.dateBegin.text = theDate;
        }break;
        case CMDateChoiceProcessEnd:
        {
            self.dateEnd.text = theDate;
        }break;
        default:NSLog(@"date choice error～");
            break;
    }
}

/**当前用户所在位置
 *@param nil
 *return nil*/
- (void)locationAction
{
    self.mapView.showsUserLocation = YES;
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    locationManager.delegate=self;//设置代理
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
    locationManager.distanceFilter=1000.0f;//设置距离筛选器
    [locationManager startUpdatingLocation];//启动位置管理器
    MKCoordinateSpan theSpan;
    //地图的范围 越小越精确
    theSpan.latitudeDelta=0.05;
    theSpan.longitudeDelta=0.05;
    MKCoordinateRegion theRegion;
    theRegion.center = [[locationManager location] coordinate];
    theRegion.span = theSpan;
    [self.mapView setRegion:theRegion];
    [locationManager release];
}

///**地图箭头按钮事件,详细信息
// *@param nil
// *return nil*/
//- (void)detailAction
//{
//    LocationDetailViewController *detailViewController = [[LocationDetailViewController alloc] init];
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    [detailViewController release];
//}

/**滚轮选择值改变触发
 *@param nil    
 *return nil*/
- (void)queryHistoryTrackAction
{
    if ( !self.isQueryOk ) {
        [self showPickerView];
        self.isQueryOk = YES;
    }
    else {
        //1.0时间判断
        //1.1获取日期之差,判断是否大于系统查询间隔
        NSDateFormatter *formater = [[[NSDateFormatter alloc] init] autorelease];
        [formater setDateFormat:kDateAndTimeHourFormater];
        NSDate *beginDate = [NSString convertDateToLocalTime:[formater dateFromString:self.dateBegin.text]];
        NSDate *endDate = [NSString convertDateToLocalTime:[formater dateFromString:self.dateEnd.text]];
        NSDate *currentDate = [NSString convertDateToLocalTime:[NSDate date]];
        
        NSTimeInterval daysBetweenEB = [endDate timeIntervalSinceDate:beginDate];
        NSTimeInterval daysBetweenNE = [currentDate timeIntervalSinceDate:endDate];
        NSTimeInterval daysBetweenNB = [currentDate timeIntervalSinceDate:beginDate];
        
        NSLog(@"daysBetweenEB=%f,daysBetweenNE=%f,daysBetweenNB=%f",daysBetweenEB,daysBetweenNE,daysBetweenNB);
        NSLog(@"beginDate=%@,endDate=%@,currentDate=%@",beginDate,endDate,currentDate);
        if ( daysBetweenNE >= kZeroErrorValue && daysBetweenNB >= kZeroErrorValue ) {
            if ( daysBetweenEB < kZeroErrorValue ) {
                [self showAlert:kAlertDatesIntervalWrong title:nil message:@"查询开始时间不可大于结束时间"];
            }
            else if ( daysBetweenEB > kQueryHistoryTimeInterval * 3600 * 24 ) {
                [self showAlert:kAlertDatesIntervalWrong title:nil message:[NSString stringWithFormat:@"查询日期差不可超过12小时"]];
            }
            else {
                NSString *historyTrackQueryParam = [NSString createQueryHistoryTrackParam:self.terminalNo beginTime:self.dateBegin.text endTime:self.dateEnd.text];
                NSLog(@"historyTrackQueryParam = %@",historyTrackQueryParam);
                NSData *query = [historyTrackQueryParam dataUsingEncoding:NSUTF8StringEncoding];
                [self.socket writeData:query withTimeout:-1 tag:3];
                [self.socket readDataWithTimeout:-1 tag:3];
                [self hidePickerView];
                self.isQueryOk = NO;
            }
        }
        else {
            [self showAlert:kAlertEndDateWrong title:nil message:@"查询开始/结束时间不可超过当日"];
        }
    }
}

/**提醒
 *@param
 *return nil*/
- (void)showAlert:(NSInteger)alertTag title:(NSString *)title message:(NSString *)message
{
    if ( !title ) {
        title = kAlertTitleDefault;
    }
    UIAlertView *tip = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    tip.tag = alertTag;
    [tip show];
    [tip release];
}

/**地图上显示历史信息点
 *@param location:历史经纬度
 *@return nil*/
- (void)showHistroryTrack:(NSTimeInterval)timeInterval history:(NSArray *)history
{
    MKCoordinateSpan span;
    MKCoordinateRegion region;
    span = MKCoordinateSpanMake(0.01f, 0.01f);
    region.span = span;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[history objectAtIndex:0] doubleValue], [[history  objectAtIndex:1] doubleValue]);
    region.center = location;
    [self.mapView setRegion:region];
    //获取时间
    NSDateFormatter *dateFormater = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormater setDateFormat:kDateFormaterStandard];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [dateFormater stringFromDate:date];
    //添加标记
    CMAnnotation *ann = [[CMAnnotation alloc] initWithCoordinate:location title:dateString subtitle:[history objectAtIndex:3]];
    [self.mapView addAnnotation:ann];
    [ann release];
    [self.annotations addObject:ann];
}

/**地图上两点划线
 *@param from:开始点 to:结束点
 *return nil*/
- (void)drawLineFromLocation:(NSArray *)locations
{
    CGContextRef context = 	CGBitmapContextCreate(nil, 
												  self.historyTrackView.frame.size.width, 
												  self.historyTrackView.frame.size.height, 
												  8, 
												  4 * self.historyTrackView.frame.size.width,
												  CGColorSpaceCreateDeviceRGB(),
												  kCGImageAlphaPremultipliedLast);
    
	CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
	CGContextSetLineWidth(context, 3.0);
    
    for ( NSInteger i = 0; i < [locations count]; i ++ ) {
        CLLocation *location = [locations objectAtIndex:i];
        CGPoint point = [self.mapView convertCoordinate:location.coordinate toPointToView:self.historyTrackView];
        
        if ( i == 0 ) {
            CGContextMoveToPoint(context, point.x, self.historyTrackView.frame.size.height - point.y);
        }
        else {
            CGContextAddLineToPoint(context, point.x, self.historyTrackView.frame.size.height - point.y);
        }
    }
    
    CGContextStrokePath(context);
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    UIImage *img = [UIImage imageWithCGImage:image];
    [self.historyTrackView setImage:img];
    CGContextRelease(context);
}
#pragma mark - UITextFieldDelegate
/*@=UITextFieldDelegate*/
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma mark - MKMapViewDelegate
/*@地图缩放时*/
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated    
{
    
}

/*@显示箭头*/
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *identifier = @"pin";
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if ( !pin ) {
        pin = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
    }
    else {
        pin.annotation = annotation;
    }
    
//    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    detailBtn.frame = CGRectMake(0, 0, 30, 30);
//    [detailBtn addTarget:self action:@selector(detailAction) forControlEvents:UIControlEventTouchUpInside];
    //判断如果是当前车辆信息点,显示绿色图钉
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:kDateFormaterStandard];
    NSDate *annotationTitle = [dateFormatter dateFromString:annotation.title];
    NSTimeInterval timeDiff = [[NSDate date] timeIntervalSinceDate:annotationTitle];
    if ( timeDiff < 10 ) {
        pin.pinColor = MKPinAnnotationColorGreen;
    }
    
    pin.rightCalloutAccessoryView = nil;
    pin.enabled = YES;
    pin.animatesDrop = NO;
    pin.canShowCallout = YES;
    
    return pin;
}



#pragma mark - CLLocationmanagerDelegate
/*@更新*/
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation   
{
    NSLog(@"locationManager~~");
    MKCoordinateSpan span = MKCoordinateSpanMake(.002, .002);
    MKCoordinateRegion region;
    region.center = newLocation.coordinate;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
    
    if ( self.annotation ) {
        [self.annotation moveAnnotation:self.currentLocation];
    }
    else {
        CMAnnotation *annotation = [[CMAnnotation alloc] initWithCoordinate:newLocation.coordinate title:@"You are here" subtitle:@"great"];
        self.annotation = annotation;
        [self.mapView addAnnotation:self.annotation];
        [annotation release];
    }
    
    if ( !self.geocoder ) {
        MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:self.currentLocation];
        self.geocoder = geocoder;
        self.geocoder.delegate = self;
        [self.geocoder start];
        [geocoder release];
    }
}

#pragma mark - MKReverseGeocoderDelegate
/*@逆地址解析成功回调*/
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark 
{
    self.locationAddress = [NSString stringWithFormat:@"%@,%@",placemark.locality,placemark.country];
    self.annotation.subtitle = self.locationAddress;
    [_geocoder release];
    _geocoder = nil;
}

/*@逆地址解析失败回调*/
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    [_geocoder release];
    _geocoder = nil;
}

#pragma AsyncSocket
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{  
    //[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    NSLog(@"onSocket recvData = %@",data);
    NSString *result = [NSString dataToStringConvert:data];
    NSLog(@"recvOrginalData = %@",result);
    
    NSMutableArray *recv = [NSString parseQueryHistoryTrackRecv:data];
    NSLog(@"history Key %d: %@",[recv count],recv);
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    //移除已经存在的标记
    [self.mapView removeAnnotations:self.annotations];
    [self.annotations removeAllObjects];
    for ( NSString *key in recv ) {
        NSArray *history = [[[CMCurrentCars getInstance] theCurrentCarInfo:self.terminalNo].history objectForKey:key];
        NSLog(@"history = %@",history);
        if ( [history count] >= 4 ) {
            [self showHistroryTrack:([key doubleValue] / 1000) history:history];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[[history objectAtIndex:0] doubleValue] longitude:[[history objectAtIndex:1] doubleValue]];
            [locations addObject:location];
        }
    }
    [self drawLineFromLocation:locations];
    [locations release];
}
@end
//test 59.77.15.2:1440
