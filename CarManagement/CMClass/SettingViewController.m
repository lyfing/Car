//
//  SettingViewController.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-4.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutCarManagerViewController.h"
#import "CMResManager.h"

#define kServerSettingKey             @"服务器配置"
#define kSetServerIpAddress           @"ip地址"
#define kSetServerIpPort              @"端口号"
#define kAboutCarManagerKey           @"胖总车管"
#define kSetAoubtCarManager           @"胖总车管·新用户引导"
#define kSettingTableCellHight        40
@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize settingTView = _settingTView;
@synthesize settingsDic = _settingDic;
@synthesize settingKeys = _settingKeys;
@synthesize serverIpAddressField = _serverIpAddressField;
@synthesize serverIpPortField = _serverIpPortField;
@synthesize doneBtn = _doneBtn;

- (void)dealloc
{
    [_settingTView release];
    [_settingDic release];
    [_settingKeys release];
    [_serverIpAddressField release];
    [_serverIpPortField release];
    [_doneBtn release];
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    //0.0self.view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth, kFullScreenWidth)];
    view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"设置";
    
    //1.0tableview
    UITableView *settingTView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
    settingTView.backgroundColor = [UIColor whiteColor];
    settingTView.sectionHeaderHeight = 20;
    settingTView.sectionFooterHeight = 2;
    self.settingTView = settingTView;
    self.settingTView.delegate = self;
    self.settingTView.dataSource = self;
    [settingTView release];
    
    [view addSubview:self.settingTView];
    self.view = view;
    [view release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSArray *settingKeys = [[NSArray alloc] initWithObjects:kServerSettingKey,kSetAoubtCarManager,nil];
    self.settingKeys = settingKeys;
    [settingKeys release];
    
    NSArray *serverSetting = [NSArray arrayWithObjects:kSetServerIpAddress,kSetServerIpPort,nil];
    NSArray *aboutCarManager = [NSArray arrayWithObjects:kSetAoubtCarManager,nil];
    NSMutableDictionary *settingDics = [[NSMutableDictionary alloc] init];
    [settingDics setObject:serverSetting forKey:kServerSettingKey];
    [settingDics setObject:aboutCarManager forKey:kSetAoubtCarManager];
    self.settingsDic = [NSDictionary dictionaryWithDictionary:settingDics];
    [settingDics release];
    
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] > 3.2 ) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addButtonTokeyboard) name:UIKeyboardDidShowNotification object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addButtonTokeyboard) name:UIKeyboardWillShowNotification object:nil];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.serverIpAddressField.text forKey:kLastServerIpAddress];
    [defaults setObject:self.serverIpPortField.text forKey:kLastServerIpPort];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSString *key = [self.settingKeys objectAtIndex:[indexPath section]];
    NSString *settingName = [[self.settingsDic objectForKey:key] objectAtIndex:[indexPath row]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ( [settingName isEqualToString:kSetServerIpAddress] ) {
        if ( !self.serverIpAddressField ) {
            UITextField *serverIpAddressField = [[UITextField alloc] initWithFrame:CGRectMake(40, 5, 200, kSettingTableCellHight)];
            serverIpAddressField.placeholder = kSetServerIpAddress;
            serverIpAddressField.text = [defaults objectForKey:kLastServerIpAddress];
            serverIpAddressField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            serverIpAddressField.keyboardType = UIKeyboardTypeDecimalPad;
            serverIpAddressField.clearButtonMode  = UITextFieldViewModeWhileEditing;
            serverIpAddressField.returnKeyType = UIReturnKeyDone;
            serverIpAddressField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            serverIpAddressField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.serverIpAddressField = serverIpAddressField;
            self.serverIpAddressField.delegate = self;
            [serverIpAddressField release];
        }
        
        cell.accessoryView = self.serverIpAddressField;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if ( [settingName isEqualToString:kSetServerIpPort] ) {
        if ( !self.serverIpPortField ) {
            UITextField *serverIpPortField = [[UITextField alloc] initWithFrame:CGRectMake(40, 5, 200, kSettingTableCellHight)];
            serverIpPortField.placeholder = kSetServerIpPort;
            serverIpPortField.text = [defaults objectForKey:kLastServerIpPort];
            serverIpPortField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            serverIpPortField.keyboardType = UIKeyboardTypeNumberPad;
            serverIpPortField.clearButtonMode  = UITextFieldViewModeWhileEditing;
            serverIpPortField.returnKeyType = UIReturnKeyDone;
            serverIpPortField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            serverIpPortField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.serverIpPortField = serverIpPortField;
            self.serverIpPortField.delegate = self;
            [serverIpPortField release];
        }
        
        cell.accessoryView = self.serverIpPortField;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.text = settingName;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.settingKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.settingKeys objectAtIndex:section];
    
    return [[self.settingsDic objectForKey:key] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [self.settingKeys objectAtIndex:section];
    
    return key;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ( [cell.textLabel.text isEqualToString:kSetAoubtCarManager] ) {
        AboutCarManagerViewController *aboutCarManagerViewController = [[AboutCarManagerViewController alloc] init];
        aboutCarManagerViewController.navigationItem.backBarButtonItem.title = kSetAoubtCarManager;
        [self.navigationController pushViewController:aboutCarManagerViewController animated:YES];
        [aboutCarManagerViewController release];
    }
    
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

#pragma textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

/**
 *添加按钮到NumberPad虚拟键盘
 *@param nil
 *@return nil*/
- (void)addButtonTokeyboard
{
    
    if ( !self.doneBtn ) {
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(0, 427, 106, 53);
        [doneBtn setImage:[[CMResManager getInstance] imageForKey:@"DoneUp"]  forState:UIControlStateNormal];
        [doneBtn setImage:[[CMResManager getInstance] imageForKey:@"DoneDown"] forState:UIControlEventTouchUpInside];
        [doneBtn addTarget:self action:@selector(doneBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        self.doneBtn = doneBtn;
    }
    
    //找到键盘的view
    NSInteger topWindow = [[[UIApplication sharedApplication] windows] count] - 1;
    NSLog(@"topWindow = %d",topWindow);
    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:topWindow];
    
    [tempWindow addSubview:self.doneBtn];
    
    if ( self.serverIpPortField.editing ) {
        self.doneBtn.hidden = NO;
    }
    else {
        self.doneBtn.hidden = YES;
    }
}

/**
 *NumberPad虚拟键盘添加按钮按下响应
 *@param nil;
 *@return nil*/
- (void)doneBtnPressed
{
    [self.doneBtn removeFromSuperview];
    [self.serverIpPortField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ( self.serverIpPortField.editing ) {
        self.doneBtn.hidden = NO;
    }
    else {
        self.doneBtn.hidden = YES;
    }
}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self.settingTView];
//    NSLog(@"touchesEnded");
//    
//    if ( point.y < CGRectGetMinY(self.serverIpAddressField.frame) || point.y > CGRectGetMaxY(self.serverIpPortField.frame) ) {
//        [self.serverIpAddressField resignFirstResponder];
//        [self.serverIpPortField resignFirstResponder];
//        NSLog(@"touchesEnded if");
//    }
//}
@end