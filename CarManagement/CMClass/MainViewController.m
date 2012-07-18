//
//  MainViewController.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-4.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "MainViewController.h"
#import "DetailViewController.h"
#import "LoginViewController.h"
#import "CMTableViewCell.h"
#import "AppDelegate.h"

#define kAlertLogoutTag         2000


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize searchBar = _searchBar;
@synthesize carInfoTView = _carInfoTView;
@synthesize logoutBtn = _logoutBtn;
@synthesize companyName = _companyName;
@synthesize isSearchOn = _isSearchOn;
@synthesize terminalNos = _terminalNos;
@synthesize searchResult = _searchResult;
@synthesize carNos = _carNos;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize reloading = _reloading;
      
/**初始化
 *@param companyName:公司名称 terminalNos:终端号码数组
 *return self*/
- (id)initwithCompanyName:(NSString *)companyName terminalNos:(NSMutableArray *)terminalNosParam
{
    self = [super init];
    if ( self ) {
        self.companyName = companyName;
        NSMutableArray *terminalNos = [[NSMutableArray alloc] initWithArray:terminalNosParam];
        self.terminalNos = terminalNos;
        [terminalNos release];
        NSLog(@"initwithCompanyName [self.terminalNos retain]= %d self.terminalNos = %@",[self.terminalNos retainCount],self.terminalNos);
    }
    
    return self;
}

- (void)dealloc
{
    [_searchBar release];
    [_carInfoTView release];
    [_logoutBtn release];
    [_terminalNos release];
    [_carNos release];
    [_searchResult release];
    [_refreshHeaderView release];
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    [self.navigationItem.titleView sizeToFit];
    self.title = self.companyName;
    self.navigationController.navigationBar.tintColor = DefaultColor;
    
    //0.0
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor whiteColor];
    
    //1.0登出
    UIBarButtonItem *logoutBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(logoutAction)];
    self.logoutBtn = logoutBtn;
    self.navigationItem.leftBarButtonItem = self.logoutBtn;
    [logoutBtn release];
    
    //2.0tableview
    UITableView *carInfoTView = [[UITableView alloc] initWithFrame:CGRectMake(0, -1, kFullScreenWidth, 416) style:UITableViewStyleGrouped];
    carInfoTView.backgroundColor = [UIColor whiteColor];
//    carInfoTView.sectionHeaderHeight = 40;
    carInfoTView.sectionFooterHeight = 2;
    self.carInfoTView = carInfoTView;
    self.carInfoTView.delegate = self;
    self.carInfoTView.dataSource = self;
    [carInfoTView release];
    
    //2.1搜索
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kFullScreenWidth, kCMNavigationBarHight)];
    searchBar.backgroundColor = DefaultColor;
    searchBar.autocorrectionType = UITextAutocorrectionTypeYes;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.keyboardType = UIKeyboardTypeDefault; 
    searchBar.showsCancelButton = NO;
    self.searchBar = searchBar;
    self.searchBar.delegate = self;
    self.carInfoTView.tableHeaderView = self.searchBar;
    [searchBar release];
    
    [view addSubview:self.carInfoTView];
    self.view = view;
    [view release];
    
    //3.0刷新
    EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, - 63.0f - self.carInfoTView.bounds.size.height, self.carInfoTView.frame.size.width, self.view.bounds.size.height)];
    refreshView.delegate = self;
    self.refreshHeaderView = refreshView;
    [self.carInfoTView addSubview:self.refreshHeaderView];
    [refreshView release];
    [self.refreshHeaderView refreshLastUpdatedDate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //获取carNos
    NSMutableArray *carNos = [[NSMutableArray alloc] initWithArray:[[CMCars getInstance] carNos]];
    self.carNos = carNos;
    [carNos release];
    
    //2.0
    NSMutableArray *searchResult = [[NSMutableArray alloc] init];
    self.searchResult = searchResult;
    [searchResult release];
    
    _isSearchOn = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.searchBar = nil;
    self.carInfoTView = nil;
    self.logoutBtn = nil;
    self.refreshHeaderView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma buttonAction

- (void)logoutAction
{
    UIAlertView *tip = [[UIAlertView alloc] initWithTitle:kAlertTitleDefault message:@"您确定要退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    tip.tag = kAlertLogoutTag;
    [tip show];
    [tip release];
}

#pragma UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  
{
    NSLog(@"alertView.tag = %d,buttonIndex = %d",alertView.tag,buttonIndex);
    if ( alertView.tag == kAlertLogoutTag ) {
        if ( buttonIndex == 1 ) {
            //确定退出
            NSLog(@"退出啦~");
            NSLog(@"logout~");
            //断开socket
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.client.delegate = self;
            [appDelegate.client disconnect];
            //清除缓存
            [[CMCars getInstance] clear];
            [[CMCurrentCars getInstance] clear];
            //切换到登陆页面
            [self dismissModalViewControllerAnimated:NO];
        }
    }
}

#pragma tableView
- (CMTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell";
    
    CMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];

    if ( !cell ) {
        cell = [[[CMTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier
                                                      :cellIndentifier] autorelease];
    }
    
    if ( _isSearchOn ) {
        cell.terminalNo = [[CMCars getInstance] getTerminalNoByCarNo:[self.searchResult objectAtIndex:[indexPath row]]];
    }
    else {
        cell.terminalNo = [self.terminalNos objectAtIndex:[indexPath row]];
    }
    
    CurrentCarInfo *theCurrentCarInfo = [[CMCurrentCars getInstance] theCurrentCarInfo:cell.terminalNo];
    CarInfo *theCarInfo = [[CMCars getInstance] theCarInfo:cell.terminalNo];
    
    cell.carNoCMView.contentLabel.text = [NSString carNoAdjustmentParam:theCarInfo.carNo];
    cell.speedCMView.contentLabel.text = [NSString carSpeedAdjustmentParam:theCurrentCarInfo.speed];
    NSString *carWarn = [[CarWarn globalConfig] currentCarWarn:theCurrentCarInfo.warn carType:theCarInfo.carType logicLevel:nil];
    cell.stateCMView.contentLabel.text = [NSString carStateAdjustmentParam:carWarn];
    cell.positionCMView.contentLabel.text =[NSString carPositionAdjustmentParam:theCurrentCarInfo.carPosition];
    
    NSString *carName = [NSString carImage:theCarInfo.carType];
    cell.carImgView.image = [UIImage imageNamed:carName];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection [self.terminalNos retain]= %d",[self.terminalNos retainCount]);
    
    if ( _isSearchOn ) {
        return [self.searchResult count];
    }

    return [self.terminalNos count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CMTableViewCell *cell = (CMTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithTerminalNo:cell.terminalNo];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
    NSLog(@"MainViewControllerArrays = %@",self.navigationController.viewControllers);
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *terminalNo = [self.terminalNos objectAtIndex:[indexPath row]];
    NSString *msg = [[CMCurrentCars getInstance] theCurrentCarInfo:terminalNo].carPosition;
    NSLog(@"msg = %@",msg);
    
    UIFont *font = [UIFont systemFontOfSize:18];
    float contentWidth = self.carInfoTView.frame.size.width - 70.0;
    CGSize msgSize = [msg sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    NSLog(@"msgSize.width = %f,msgSize.hight = %f",msgSize.width,msgSize.height);
    NSLog(@"cell.hight = %f",70 + msgSize.height);
    return 70 + msgSize.height;
}

#pragma mark - for searchBar
- (void)searchAction
{
    [self.searchResult removeAllObjects];
    
    for ( NSString *carNo in self.carNos )
    {
        NSRange carIDResultRange = [carNo rangeOfString:self.searchBar.text options:NSCaseInsensitiveSearch];
        if ( carIDResultRange.length > 0 ) {
            [self.searchResult addObject:carNo];
        }
        
        NSLog(@"self.searchBar.text = %@ ,self.searchResult = %@",self.searchBar.text,self.searchResult);
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.carInfoTView.scrollEnabled = NO;
    [searchBar setShowsCancelButton:YES animated:YES];
    for ( id subView in [searchBar subviews] ) {
        if ( [subView isKindOfClass:[UIButton class]] ) {
            UIButton *btn = (UIButton *)subView;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText 
{
    if ( [self.searchBar.text length] > 0 ) {
        _isSearchOn = YES;
        self.carInfoTView.scrollEnabled = YES;
        [self searchAction];
    }
    else {
        _isSearchOn = NO;
        self.carInfoTView.scrollEnabled = NO;
    }
    
    [self.carInfoTView reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _isSearchOn = NO;
    self.carInfoTView.scrollEnabled = YES;
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar   
{
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    self.carInfoTView.scrollEnabled = YES;
}

#pragma mark - for DataSource Loading
- (void)reloadTableViewDataSource
{
    NSLog(@"开始加载数据");
    //更新数据请求
    NSString *update = [NSString createQueryCurrentCarsInfo:[[CMCars getInstance] getAllTerminalNo]];
    NSLog(@"In MainViewController updateRquest:%@",update);
    NSData *request = [update dataUsingEncoding:NSUTF8StringEncoding];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.client.delegate = self;
    [appDelegate.client writeData:request withTimeout:-1 tag:4];
    [appDelegate.client readDataWithTimeout:-1 tag:4];
    _reloading = YES;
}

- (void)doneLoadingTableViewData
{
    NSLog(@"加载数据完毕");
    _reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.carInfoTView];
}
#pragma mark - for UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark - for EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}
#pragma mark - for AsyncSocket
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{  
    [NSString praseUpdateCurrentCarsInfo:data];
    [self.carInfoTView reloadData];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}
@end
