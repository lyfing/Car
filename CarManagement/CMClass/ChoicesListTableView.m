//
//  ChoicesListView.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-25.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "ChoicesListTableView.h"

@interface ChoicesListTableView ()

@end

@implementation ChoicesListTableView
@synthesize choices = _choices;
@synthesize phoneCall = _phoneCall;
@synthesize type = _type;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_choices release];
    [_phoneCall release];
    
    [super dealloc];
}

/**初始化tableView
 *@param title:列表标题 data:数据
 **/
- (id)initWithTitle:(NSString *)title andDataSource:(NSArray *)data
{
    self = [super initWithStyle:UITableViewStylePlain];
    if ( self ) {
        self.title = [[NSString alloc] initWithString:title];
        self.choices = [[NSArray alloc] initWithArray:data];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
     return [self.choices count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    id key = [self.choices objectAtIndex:[indexPath row]];
    if ( [key isKindOfClass:[Dirver class]] ) {
        Dirver *dirver = (Dirver *)key;
        cell.textLabel.text = dirver.dirverName;
        cell.detailTextLabel.text = dirver.dirverTel;
        self.type = CMChoiceDataTypePhone;
    }
    else if ( [key isKindOfClass:[NSString class]] ) {
        cell.textLabel.text = (NSString *)key;
        self.type = CMChoiceDataTypeCamera;
    }
    else {
        cell.textLabel.text = @"helloworld";
    }
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellValue = cell.textLabel.text;
    //当前为打电话选择
    if ( self.type == CMChoiceDataTypePhone ) {
        [self.delegate phoneCallByUsingWebview:cell.detailTextLabel.text];
    }//当前为拍照选择
    else if ( self.type == CMChoiceDataTypeCamera ) {
        CMCameraType camerType = 0;
        if ( [cellValue isEqualToString:@"前置摄像头"] ) {
            camerType = CMCameraTypeFront;
        }
        else if ( [cellValue isEqualToString:@"后置摄像头"] ) {
            camerType = CMCameraTypeRear;
        }
        
        [self.delegate handleTakePhotoRequest:camerType];
    }
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}
@end
