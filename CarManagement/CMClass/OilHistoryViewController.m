//
//  HistoryTrackViewController.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-6.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "OilHistoryViewController.h"
#import "AppDelegate.h"   

#define kAlertEndDateWrong            2000
#define kAlertDatesIntervalWrong      2001

@interface OilHistoryViewController ()

@end

@implementation OilHistoryViewController
@synthesize terminalNo = _terminalNo;
@synthesize oilHistoryView = _oilHistoryView;
@synthesize dateView = _dateView;
@synthesize dateBegin = _dateBegin;
@synthesize dateEnd = _dataEnd;
@synthesize segLabel = _segLabel;
@synthesize loadingView = _loadingView;
@synthesize indicator = _indicator;
@synthesize tipLabel = _tipLabel;
@synthesize datePicker = _datePicker;
@synthesize dateChoiceProcess = _dateChoiceProcess;
@synthesize socket = _socket;
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
    [_dateView release];
    [_dateBegin release];
    [_dateEnd release];
    [_oilHistoryView release];
    [_segLabel release];
    [_loadingView release];
    [_indicator release];
    [_tipLabel release];
    [_datePicker release];
    [_socket release];
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    //1.0 view
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"油量查询";
    
    //2.0查询按钮
//    UIImage *historyBtnImg = [[CMResManager getInstance] imageForKey:@"history_trace"];
    UIImage *historyBtnImg = [[CMResManager getInstance] imageForKey:@"search_item"];
    [self addRightBtn:historyBtnImg controllerEventTouchUpInside:@selector(oilHistoryAction) target:self];
    
    //3.0UItextView 
    CMUITextView *oilHistoryView = [[CMUITextView alloc] initWithFrame:CGRectMake(10, kCMNavigationBarHight, 300,367)];
    oilHistoryView.backgroundColor = [UIColor clearColor];
    oilHistoryView.font = [UIFont systemFontOfSize:16];
    oilHistoryView.userInteractionEnabled = YES;
    oilHistoryView.editable = NO;
    self.oilHistoryView = oilHistoryView;
    self.oilHistoryView.delegate = self;
    [self.view addSubview:self.oilHistoryView];
    [oilHistoryView release];
    
    //4.0进度指示
    //4.1加载数据view
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)];
    //4.2加载数据菊花
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(45, 20, 30, 30);
    self.indicator = indicator;
    [self.indicator startAnimating];
    [loadingView addSubview:self.indicator];
    [indicator release];
    //4.3加载数据lable
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 120, 30)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = UITextAlignmentCenter;
    tipLabel.textColor = [UIColor blueColor];
    tipLabel.text = @"正在加载数据...";
    self.tipLabel = tipLabel;
    [loadingView addSubview:self.tipLabel];
    [tipLabel release];
    
    self.loadingView = loadingView;
    [self.view addSubview:self.loadingView];
    self.loadingView.center = CGPointMake(160, self.view.center.y - 60);
    [loadingView release];
    
    //5.0时间选择
    //5.1背景view
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, kFullScreenHight, kFullScreenWidth, 256)];
    dateView.backgroundColor = [UIColor grayColor];
    //5.2开始查询时间
    UITextField *dateBegin = [[UITextField alloc] initWithFrame:CGRectMake(20,5,135,30)];
    dateBegin.backgroundColor = [UIColor clearColor];
    dateBegin.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    dateBegin.textAlignment = UITextAlignmentCenter;
    dateBegin.userInteractionEnabled = NO;
    dateBegin.textColor = [UIColor blueColor];
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
    UITextField *dateEnd = [[UITextField alloc] initWithFrame:CGRectMake(165, 5, 135, 30)];
    dateEnd.backgroundColor = [UIColor clearColor];
    dateEnd.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    dateEnd.textAlignment = UITextAlignmentCenter;
    dateEnd.userInteractionEnabled = NO;
    dateEnd.textColor = [UIColor blueColor];
    dateEnd.placeholder = @"查询结束日期";
    self.dateEnd = dateEnd;
    self.dateEnd.delegate = self;
    [dateView addSubview:self.dateEnd];
    [dateEnd release];
    //5.5滚轮
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,40, kFullScreenWidth, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
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
	// Do any additional setup after loading the view.
    //查询日期默认
    //获取当前时间
    NSDateFormatter *dateFormater = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormater setDateFormat:kDateFormater];
    NSString *theRightEndDate = [dateFormater stringFromDate:[NSDate date]];
    //获取一周前的时间
    NSDate *now = [NSString convertDateToLocalTime:[NSDate date]];
    NSString *theRightBeginDate = [dateFormater stringFromDate:[now dateByAddingTimeInterval:-kQueryOilTimeInterval*3600*24]];
    self.dateBegin.text = theRightBeginDate;
    self.dateEnd.text = theRightEndDate;
    
    NSDate *currentTime = [[[NSDate alloc] init] autorelease];
    [self.datePicker setDate:currentTime animated:YES];
    //socket
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.client.delegate = self;
    self.socket = appDelegate.client;
    NSString *oilHistoryQueryParam = [NSString createOilAnalysisParam:self.terminalNo beginTime:theRightBeginDate endTime:theRightEndDate];
    NSLog(@"oilHistoryQueryParam = %@",oilHistoryQueryParam);
    NSData *query = [oilHistoryQueryParam dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:query withTimeout:-1 tag:5];
    [self.socket readDataWithTimeout:-1 tag:5];
    [self showLoadingView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.tipLabel = nil;
    self.dateView = nil;
    self.dateBegin = nil;
    self.dateEnd = nil;
    self.dateView = nil;
    self.segLabel = nil;
    self.datePicker = nil;
    self.loadingView = nil;
    self.indicator = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark buttonAction
/**查询车辆油量历史记录
 *@param nil
 *return nil*/
- (void)oilHistoryAction
{
    if ( !_isQueryOk ) {
        [self showPickerView];
        _isQueryOk = YES;
    }
    else {
        NSLog(@"History Oil~");
        //1.0时间判断
        //1.1获取日期之差,判断是否大于系统查询间隔
        NSDateFormatter *formater = [[[NSDateFormatter alloc] init] autorelease];
        [formater setDateFormat:kDateFormater];
        NSDate *beginDate = [formater dateFromString:self.dateBegin.text];
        NSDate *endDate = [formater dateFromString:self.dateEnd.text];
        NSLog(@"beginDate = %@",beginDate);
        NSLog(@"endDate = %@",endDate);
        NSDate *currentDate = [NSString convertDateToLocalTime:[NSDate date]];
        
        NSTimeInterval daysBetweenEB = [endDate timeIntervalSinceDate:beginDate];
        NSTimeInterval daysBetweenNE = [currentDate timeIntervalSinceDate:endDate];
        NSTimeInterval daysBetweenNB = [currentDate timeIntervalSinceDate:beginDate];
        
        NSLog(@"daysBetweenEB=%f,daysBetweenNE=%f,daysBetweenNB=%f",daysBetweenEB,daysBetweenNE,daysBetweenNB);
        NSLog(@"beginDate=%@,endDate=%@,currentDate=%@",beginDate,endDate,currentDate);
        if ( daysBetweenNE >= 0.000001 && daysBetweenNB >= 0.000001 ) {
            if ( daysBetweenEB < 0.000001 ) {
                [self showAlert:kAlertDatesIntervalWrong title:nil message:@"查询开始时间不可大于结束时间"];
            }
            else if ( daysBetweenEB > kQueryOilTimeInterval * 24 * 3600 ) {
                [self showAlert:kAlertDatesIntervalWrong title:nil message:[NSString stringWithFormat:@"查询日期差不可超过%d天",kQueryOilTimeInterval]];
            }
            else {
                NSString *oilHistoryQueryParam = [NSString createOilAnalysisParam:self.terminalNo beginTime:self.dateBegin.text endTime:self.dateEnd.text];
                NSLog(@"oilHistoryQueryParam = %@",oilHistoryQueryParam);
                NSData *query = [oilHistoryQueryParam dataUsingEncoding:NSUTF8StringEncoding];
                [self.socket writeData:query withTimeout:-1 tag:6];
                [self.socket readDataWithTimeout:-1 tag:6];
                [self hidePickerView];
                _isQueryOk = NO;
                [self.oilHistoryView hideTitleAndSlider:YES];
                [self.oilHistoryView setText:@""];
                [self showLoadingView];
            }
        }
        else {
            [self showAlert:kAlertEndDateWrong title:nil message:@"查询开始/结束时间不可超过当日"];
        }
    }
}

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

/**显示加载进度
 *@param nil
 *return nil*/
- (void)showLoadingView
{
    [UIView beginAnimations:@"showLoadingView" context:nil];
    [UIView setAnimationDuration:0.3];
    self.loadingView.hidden = NO;
    self.navBar.rightBtn.enabled = NO;
    [UIView commitAnimations];
}
/**隐藏加载进度
 *@param nil
 *return nil*/
- (void)hideLoadingView
{
    [UIView beginAnimations:@"showLoadingView" context:nil];
    [UIView setAnimationDuration:0.3];
    self.loadingView.hidden = YES;
    self.navBar.rightBtn.enabled = YES;
    [UIView commitAnimations];
}

/**滚轮数值改变
 *@param nil
 *return nil*/
- (void)pickerValueChangedAction
{
    NSDate *selected = [self.datePicker date];
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormat setDateFormat:kDateFormater];
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
#pragma mark - for UITextFieldDelegate
/*@=UITextFieldDelegate*/
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

#pragma AsyncSocket
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSLog(@"Sorry this connect is failure");
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{  
    //收到查询数据
    //隐藏加载动画&右侧查询按钮可点击
    [self hideLoadingView];
    
    NSString *oilHistory = [NSString parseQueryOilAnalysisRecv:data];
    CarInfo *theCarInfo = [[CMCars getInstance] theCarInfo:self.terminalNo];
    [self.oilHistoryView hideTitleAndSlider:NO];
    self.oilHistoryView.titleLabel.text = theCarInfo.carNo;
    self.oilHistoryView.queryDate.text = [NSString stringWithFormat:@"%@ - %@\n",self.dateBegin.text,self.dateEnd.text];
    NSString *showTitleAndContent = [NSString stringWithFormat:@"\n\n\n%@",oilHistory];
    self.oilHistoryView.text = showTitleAndContent;
}
@end

@implementation CMUITextView
@synthesize titleLabel = _titleLabel;
@synthesize queryDate = _queryDate;
@synthesize sliderImgV = _sliderImgV;

- (void)dealloc
{
    [_titleLabel release];
    [_sliderImgV release];
    [_queryDate release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        //1.0标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, kFullScreenWidth, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.userInteractionEnabled = NO;
        titleLabel.numberOfLines = 1;
        self.titleLabel = titleLabel;
        [self addSubview:self.titleLabel];
        [titleLabel release];
        //2.0查询起止时间
        UILabel *queryDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kFullScreenWidth, 30)];
        queryDate.backgroundColor = [UIColor clearColor];
        queryDate.font = [UIFont systemFontOfSize:15];
        queryDate.textAlignment = UITextAlignmentCenter;
        queryDate.userInteractionEnabled = NO;
        queryDate.numberOfLines = 1;
        self.queryDate = queryDate;
        [self addSubview:self.queryDate];
        [queryDate release];
        //3.0划线
        UIImage *slider = [CMResManager middleStretchableImageWithKey:@"slider"];
        UIImageView *sliderImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0,62.5,kFullScreenWidth, 1)];
        [sliderImgV setImage:slider];
        self.sliderImgV = sliderImgV;
        [self addSubview:self.sliderImgV];
        [sliderImgV release];
        
        [self hideTitleAndSlider:YES];
    }
    
    return self;
}
/**是否显示title 和 slider
 *@param show:显示与否
 *return nil*/
- (void)hideTitleAndSlider:(BOOL)show
{
    self.titleLabel.hidden = show;
    self.queryDate.hidden = show;
    self.sliderImgV.hidden = show;
}
@end

/*CarManagement(315,0xac10e2c0) malloc: *** error for object 0x8315000: pointer being freed was not allocated
*** set a breakpoint in malloc_error_break to debug
CarManagement(315,0xac10e2c0) malloc: *** error for object 0x766c040: pointer being freed was not allocated
*** set a breakpoint in malloc_error_break to debug
*/