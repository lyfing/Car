//
//  CarInfoViewController.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-6.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "AppDelegate.h"

#define kAlertTakePhotoTimeout 3000

@interface TakePhotoViewController ()

@end

@implementation TakePhotoViewController
@synthesize backBtn = _backBtn;
@synthesize terminalNo = _terminalNo;
@synthesize photoInfoLabel = _photoInfoLabel;
@synthesize carImgView = _carImgView;
@synthesize lastCameraType = _lastCameraType;
@synthesize socket = _socket;
@synthesize popoverView = _popoverView;
@synthesize photoLoadingView = _photoLoadingView;
@synthesize photoLoadLabel = _photoLoadLabel;
@synthesize photoLoadProcessView = _photoLoadProcessView;
@synthesize phoneCall = _phoneCall;
@synthesize isTakePhoto = _isTakePhoto;
@synthesize isCall = _isCall;


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
    [_backBtn release];
    [_photoInfoLabel release];
    [_carImgView release];
    [_socket release];
    [_photoLoadLabel release];
    [_photoLoadProcessView release];
    [_photoLoadingView release];
    [_phoneCall release];
    [_popoverView release];
    self.terminalNo = nil;
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    //1.0 view
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"车辆照片";
    
//    UIImage *takePhotoImg = [[CMResManager getInstance] imageForKey:@"take_photo"];
//    UIImage *callImg = [[CMResManager getInstance] imageForKey:@"call"];
    UIImage *takePhotoImg = [[CMResManager getInstance] imageForKey:@"car_photo_item"];
    UIImage *callImg = [[CMResManager getInstance] imageForKey:@"call_item"];
    [self setRightBtnEnabled:NO];
    [self addExtendBtnWithTarget:self touchUpInsideSelector:@selector(externBtnAction:) normalImage:takePhotoImg hightLightedImage:nil];
    [self addExtendBtnWithTarget:self touchUpInsideSelector:@selector(externBtnAction:) normalImage:callImg hightLightedImage:nil];
    
    //2.0标题
    UILabel *photoInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, 300, 40)];
    photoInfoLabel.font = [UIFont systemFontOfSize:15];
    photoInfoLabel.textColor = [UIColor blueColor];
    photoInfoLabel.textAlignment = UITextAlignmentCenter;
    photoInfoLabel.backgroundColor = [UIColor whiteColor];
    self.photoInfoLabel = photoInfoLabel;
    [self.view addSubview:self.photoInfoLabel];
    [photoInfoLabel release];
    
    //3.0carImg
    CMImageView *carImgView = [[CMImageView alloc] initWithFrame:CGRectMake(5, 90, 310, 300)];
    carImgView.userInteractionEnabled = YES;
    carImgView.backgroundColor = [UIColor whiteColor];
    [carImgView addTarget:self action:@selector(touchRefreshAction) forControlEvents:UIControlEventTouchUpInside];
    self.carImgView = carImgView;
    [self.view addSubview:self.carImgView];
    [carImgView release];    
    
    //4.0下载图片加载
    UIView *photoLoadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    photoLoadView.backgroundColor = [UIColor clearColor];
    //4.1菊花
    UIActivityIndicatorView *photoLoadIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    photoLoadIndicator.frame = CGRectMake(60, 20, 30, 30);
    self.photoLoadProcessView = photoLoadIndicator;
    [self.photoLoadProcessView startAnimating];
    [photoLoadView addSubview:self.photoLoadProcessView];
    [photoLoadIndicator release];
    //4.2文本信息
    UILabel *photoLoadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 150, 30)];
    photoLoadLabel.textAlignment = UITextAlignmentCenter;
    photoLoadLabel.textColor = [UIColor blueColor];
    photoLoadLabel.text = @"正在加载车辆照片...";
    photoLoadLabel.backgroundColor = [UIColor clearColor];
    self.photoLoadLabel = photoLoadLabel;
    [photoLoadView addSubview:self.photoLoadLabel];
    [photoLoadLabel  release];
    
    self.photoLoadingView = photoLoadView;
    self.photoLoadingView.center = CGPointMake(160, self.view.center.y - 60);
    [self.view addSubview:self.photoLoadingView];
    [photoLoadView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //右侧按钮不可选
    for ( UIButton *button in self.navBar.extendBtns ) {
        button.enabled = NO;
    }
    //读取照片数据,如果本地没有,则请求终端拍照,默认拍取前景
    NSData *photoData = [[CMUser getInstance] readData:kCarPhotoFileName];
    self.lastCameraType = CMCameraTypeFront;
    //获取当前socket
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.client.delegate = self;
    self.socket = appDelegate.client;
    
    //如果有数据,则取最后拍照的数据加载
    if ( photoData ) {
        [self.carImgView.imageView setImage:[UIImage imageWithData:photoData]];
        NSTimeInterval timeInterval = [[CMCars getInstance] theCarInfo:self.terminalNo].lastPhotoTime;
        [self setPhotoInfo:@"上次拍照时间" timeInterval:timeInterval];
        [self hidePhotoLoadingView];
    }
    else {
        [self refreshCarPhoto:self.lastCameraType];
    }
    //拨打电话OR拍照
    _isCall = NO;
    _isTakePhoto = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [_backBtn release];
    [_photoInfoLabel release];
    [_carImgView release];
    [_photoInfoLabel release];
    [_photoLoadProcessView release];
    [_photoLoadingView release];
    [_phoneCall release];
    [_popoverView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - for buttonAction
/**刷新车辆图片
 *@param nil
 *return nil*/
- (void)refreshCarPhoto:(CMCameraType)type
{
    NSString *takePhotoParam = [NSString createTakePhotoParam:self.terminalNo cameraType:type];
    NSLog(@"takePhotoParam = %@",takePhotoParam);
    [self.socket writeData:[takePhotoParam dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
    [self.socket readDataWithTimeout:20 tag:0];
    [self showPhotoLoadingView];
}

/**触摸图片现实区刷新
 *@param nil  
 *return nil*/
- (void)touchRefreshAction
{
    [self refreshCarPhoto:self.lastCameraType];
}

/**拍照响应事件
 *@param nil
 *return nil*/
- (void)externBtnAction:sender
{
    [self popover:sender];
}

/**显示加载照片进度
 *@param nil
 *return nil*/
- (void)showPhotoLoadingView
{
    [self.photoLoadingView setHidden:NO];
    [self.carImgView.imageView setImage:nil];
    //加载进度,导航栏右侧按钮不可选
    for ( UIButton *button in self.navBar.extendBtns ) {
        button.enabled = NO;
    }
}

/**隐藏加载进度
 *@param nil
 *return nil*/
- (void)hidePhotoLoadingView
{
    [self.photoLoadingView setHidden:YES];
    for ( UIButton *button in self.navBar.extendBtns ) {
        button.enabled = YES;
    }
}

/**设置照片时间信息
 *@param title:标题 timeInterval:时间戳
 *return nil*/
- (void)setPhotoInfo:(NSString *)title timeInterval:(NSTimeInterval)timeInterval
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:kDateFormaterStandard];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSLog(@"setPhotoInfo timeInterval = %f,date = %@",timeInterval,date);
    NSString *text = [NSString stringWithFormat:@"%@ %@",title,[dateFormater stringFromDate:date]];
    self.photoInfoLabel.text = text;
    [dateFormater release];
}

/**弹起选择列表
 *@param sender:事件发起者
 *return nil*/
-(void)popover:(id)sender
{
    //the controller we want to present as a popover
    //初始化数据源
    CarInfo *theCarInfo = [[CMCars getInstance] theCarInfo:self.terminalNo];
    UIButton *actionBtn = (UIButton *)sender;
    ChoicesListTableView *controller = nil;
    
    if ( actionBtn.tag == 2000 ) {
        controller = [[ChoicesListTableView alloc] initWithTitle:@"选择电话" andDataSource:theCarInfo.drivers];
    }
    else if ( actionBtn.tag = 2001 ) {
        NSArray *cameras = nil;
        if ( theCarInfo.cameraNum == 1 ) {
            cameras = [NSArray arrayWithObjects:@"前置摄像头", nil];
        }
        else if ( theCarInfo.cameraNum == 2 ) {
            cameras = [NSArray arrayWithObjects:@"前置摄像头",@"后置摄像头",nil];
        }
        else if ( theCarInfo.cameraNum == 0 ) {
            cameras = [NSArray arrayWithObjects:@"无摄像头", nil];
        }
        controller = [[ChoicesListTableView alloc] initWithTitle:@"选择摄像头" andDataSource:cameras];
    }
    
    controller.delegate = self;
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
    self.popoverView = popover;
    [controller release];
    
    //popover.arrowDirection = FPPopoverArrowDirectionAny;
    popover.tint = FPPopoverRedTint;
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    //sender is the UIButton view
    self.popoverView = popover;
    [popover release];
    [self.popoverView presentPopoverFromView:sender]; 
}
#pragma mark - for Alert
/*@Alert处理*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( alertView.tag == kAlertTakePhotoTimeout ) {
        if ( buttonIndex == 1 ) {//重新请求
            [self refreshCarPhoto:self.lastCameraType];
        }
        else if ( buttonIndex == 0 ) {//放弃拍照
            [self hidePhotoLoadingView];
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
    UIAlertView *tip = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    tip.tag = alertTag;
    [tip show];
    [tip release];
}
#pragma mark - AsyncSocketDelegate 

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    //解析数据
    [NSString ParsetakePhotoRecv:data];
    NSString *url = [NSString photoRequestUrl:self.terminalNo];
    [self.carImgView downloadImageWithUrl:url];
    NSTimeInterval timeInterval = [[CMCars getInstance] theCarInfo:self.terminalNo].lastPhotoTime;
    [self setPhotoInfo:@"拍照时间" timeInterval:timeInterval];
    [self hidePhotoLoadingView];
}

- (NSTimeInterval)onSocket:(AsyncSocket *)sock
  shouldTimeoutReadWithTag:(long)tag
                   elapsed:(NSTimeInterval)elapsed
                 bytesDone:(NSUInteger)length
{
    NSLog(@"takePhoto tiemout~");
    [self showAlert:kAlertTakePhotoTimeout title:nil message:@"请求照片超时,重新请求?"];
    return 0;
}

#pragma mark - for <FPPopoverControllerDelegate>
- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController 
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    [visiblePopoverController dismissPopoverAnimated:YES];
    [visiblePopoverController autorelease];
}

#pragma mark - for <ChoicesListTableViewDelegate>
- (void)handleTakePhotoRequest:(CMCameraType)type
{
    [self.popoverView dismissPopoverAnimated:YES];
    self.lastCameraType = type;
    [self refreshCarPhoto:type];
}

/**拨打电话,挂机后可以返回到车管系统界面
 *@param phoneNum:电话号码
 *return nil*/
- (void)phoneCallByUsingWebview:(NSString *)phoneNum
{
    NSURL *telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    if ( !_phoneCall ) {
        _phoneCall = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    
    [self.popoverView dismissPopoverAnimated:YES];
    [_phoneCall loadRequest:[NSURLRequest requestWithURL:telUrl]];
}
@end
