//
//  AboutCarManagerViewController.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-6.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "AboutCarManagerViewController.h"

@interface AboutCarManagerViewController ()

@end

@implementation AboutCarManagerViewController
static NSUInteger kNumberPage = 5;
@synthesize pageControl = _pageControl;
@synthesize scrollView = _scrollView;
@synthesize imageViews = _imageViews;
@synthesize imageInfoTView = _imageInfoTView;

- (void)dealloc
{
    [_pageControl release];
    [_scrollView release];
    [_imageInfoTView release];
    [_imageInfoTView release];
    
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"胖总车管";
    self.navigationController.navigationBar.tintColor = DefaultColor;
    
    //1.0scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 5, kFullScreenWidth - 20, 345)];
    scrollView.contentSize = CGSizeMake( scrollView.frame.size.width * kNumberPage, scrollView.frame.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:self.scrollView];
    [scrollView release];
    //2.0ImageTextView
    UITextView *imageInfoTView = [[UITextView alloc] initWithFrame:CGRectMake(10, 350, 300, 60)];
    imageInfoTView.backgroundColor = [UIColor clearColor];
//    imageInfoTView.contentMode = UIViewContentModeCenter;
//    CGFloat topCorrect = ([imageInfoTView bounds].size.height - [imageInfoTView contentSize].height);
//    topCorrect = (topCorrect <0.0 ? 0.0 : topCorrect);
//    imageInfoTView.contentOffset = (CGPoint){.x = 0, .y = -topCorrect};

    
    
    imageInfoTView.userInteractionEnabled = NO;
    self.imageInfoTView = imageInfoTView;
    [self.view addSubview:self.imageInfoTView];
    [imageInfoTView release];
    //3.0UIPageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 325, kFullScreenWidth, 20)];
    pageControl.numberOfPages = kNumberPage;
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
    self.pageControl = pageControl;
    [self.view addSubview:self.pageControl];
    [pageControl release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //1.0imageViews
    NSMutableArray *arrays = [[NSMutableArray alloc] init];
    for ( unsigned i = 0; i < kNumberPage; i ++ ) {
        UIImage *image = [[CMResManager getInstance] imageForKey:[NSString stringWithFormat:@"show%d",i]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [imageView setImage:image];
        [arrays addObject:imageView];
        [imageView release];
    }
    self.imageViews = arrays;
    [arrays release];
    
    [self loadScrollViewWithPage:self.pageControl.currentPage];
}

- (void)viewDidUnload
{
    [_pageControl release];
    [_scrollView release];
    [_imageInfoTView release];
    
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**加载图片到scrollView
 *@param page:页数
 *return nil*/
- (void)loadScrollViewWithPage:(NSInteger)page
{
    if ( page < 0 || page >= kNumberPage ) {
        return;
    }
    UIImageView *imageView = [self.imageViews objectAtIndex:page];
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    imageView.frame = frame;
    [self.scrollView addSubview:imageView];
    //文字发生变化
    self.imageInfoTView.text = [[CMConfig globalConfig].descriptions objectAtIndex:page]; 
    
    if([self.imageInfoTView.text length]>0) {
        CGSize contentSize = self.imageInfoTView.contentSize;
        //NSLog(@"w:%f h%f",contentSize.width,contentSize.height);
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        if(contentSize.height <= self.imageInfoTView.frame.size.height) {
            CGFloat offsetY = (self.imageInfoTView.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, offsetY, 0, 0);
        }
        else {
            newSize = self.imageInfoTView.frame.size;
            offset = UIEdgeInsetsZero;
            CGFloat fontSize = 18;
            while (contentSize.height > self.imageInfoTView.frame.size.height) {
                [self.imageInfoTView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                contentSize = self.imageInfoTView.contentSize;
            }
            newSize = contentSize;
        }
        [self.imageInfoTView setContentSize:newSize];
        [self.imageInfoTView setContentInset:offset];
    }
}

//@
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth + 1 );
    self.pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page];
}

/**pageControl值发生变化
 *@param nil
 *return nil*/
- (void)pageChange
{
    NSInteger page = self.pageControl.currentPage;
    [self loadScrollViewWithPage:page];
    
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}
@end
