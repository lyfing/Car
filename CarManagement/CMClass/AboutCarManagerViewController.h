//
//  AboutCarManagerViewController.h
//  CarManagement
//
//  Created by YongFeng.li on 12-5-6.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutCarManagerViewController : UIViewController<UIScrollViewDelegate>
{
    UIPageControl *_pageControl;
    
    UIScrollView *_scrollView;
    //图片信息
    NSMutableArray *_imageViews;
    //文字描述
    UITextView *_imageInfoTView;
}

@property (nonatomic,retain) UIPageControl *pageControl;
@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) NSMutableArray *imageViews;
@property (nonatomic,retain) UITextView *imageInfoTView;
@end
