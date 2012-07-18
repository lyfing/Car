//
//  CMImageView.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-21.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "CMImageView.h"

@implementation CMImageView
@synthesize imageView = _imageView;
@synthesize defaultImageView = _defaultImageView;
@synthesize url = _url;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initMemberVariables];
    }
    return self;
}

- (void)initMemberVariables
{
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [imageView release];
    
    UIImageView *defaultImageView = [[UIImageView alloc] init];
    self.defaultImageView = defaultImageView;
    [defaultImageView release];
    
    [self addSubview:self.defaultImageView];
    [self addSubview:self.imageView];
    
    [self layoutIfNeeded];
}

- (void)layoutSubviews {
    
	self.clipsToBounds = YES; //填充方式
    self.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.clipsToBounds = YES;//在不变形的情况下填充图片
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;  	
	self.imageView.frame = self.bounds;
}

/**设置默认图片
 *@param image:默认图片
 *return nil*/
- (void)setDefaultImage:(UIImage *)image
{
    if ( self.url == nil || self.url.length == 0 ) {
        
        [self.defaultImageView setImage:image];
        self.imageView = self.defaultImageView;
    }
}

/**下载图片
 *@param url:下载地址
 *return nil*/
- (void)downloadImageWithUrl:(NSString *)url
{
    if ( url == nil || url.length == 0 ) {
        return;
    }
    else{
        NSError *error = nil;
        self.url = url;
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataWritingFileProtectionCompleteUnlessOpen error:&error];
        if (  !error ) {
            [self.imageView setImage:[UIImage imageWithData:imgData]];
            //保存车辆照片信息
            [[CMUser getInstance] saveData:imgData path:kCarPhotoFileName];
            NSData *lastImgData = [[CMUser getInstance] readData:kCarPhotoFileName];
            NSLog(@"CMImageView Test lastImgData = %@",lastImgData);
        }
        else {
            NSLog(@"error = %@",error.description);
        }
    }
    
}
@end
