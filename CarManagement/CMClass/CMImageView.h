//
//  CMImageView.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-21.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMImageView : UIControl
{
    //图片网络url
    NSString *_url;
    //图像内容区
    UIImageView *_imageView;
    //默认图片
    UIImageView *_defaultImageView;
}

@property (nonatomic,copy) NSString *url;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UIImageView *defaultImageView;

/**下载图片
 *@param url:下载地址
 *return nil*/
- (void)downloadImageWithUrl:(NSString *)url;
@end
