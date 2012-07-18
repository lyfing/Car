//
//  ChoicesListView.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-25.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

typedef enum 
{
    CMChoiceDataTypeCamera = 1,
    CMChoiceDataTypePhone,
}CMChoiceDataType;

#import <UIKit/UIKit.h>

@protocol ChoicesListTableViewDelegate <NSObject>

- (void)handleTakePhotoRequest:(CMCameraType)type;
- (void)phoneCallByUsingWebview:(NSString *)phoneNum;

@end

@interface ChoicesListTableView : UITableViewController
{
    NSArray *_choices;
    
    CMChoiceDataType _type;
    
    //拨打电话
    UIWebView *_phoneCall;
    
    id<ChoicesListTableViewDelegate> _delegate;
}

@property (nonatomic,retain) NSArray *choices;
@property (nonatomic,retain) UIWebView *phoneCall;
@property (nonatomic) CMChoiceDataType type;
@property (nonatomic,assign) id<ChoicesListTableViewDelegate> delegate;

/**初始化tableView
 *@param title:列表标题 data:数据
 **/
- (id)initWithTitle:(NSString *)title andDataSource:(NSArray *)data;
@end
