//
//  CMTableViewCell.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-8.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "CMTableViewCell.h"

@implementation CMTableViewCell
static const CGRect  imageRect = {{0,0},{100,100}};
static const CGPoint imagePoint = {0,0};
static const CGSize  imageSize = {100,100};

@synthesize terminalNo = _terminalNo;
@synthesize carImgView = _carImgView;
@synthesize carNoCMView = _carNoCMView;
@synthesize speedCMView = _speedCMView;
@synthesize stateCMView = _stateCMView;
@synthesize positionCMView = _positionCMView;

- (void)dealloc
{
    [_carImgView release];
    [_carNoCMView release];
    [_speedCMView release];
    [_stateCMView release];
    [_positionCMView release];
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //1.0carImgView
        UIImageView *carImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 40, 40)];
        carImgView.backgroundColor = [UIColor clearColor];
        self.carImgView = carImgView;
        [self addSubview:self.carImgView];
        [carImgView release];
        
        //2.0carNoCMView
        CMTextView *carNoCMView = [[CMTextView alloc] initWithFrame:CGRectMake(70, 5, 230, 20)];
        carNoCMView.backgroundColor = [UIColor clearColor];
        carNoCMView.titleLabel.text = @"车牌:";
        self.carNoCMView = carNoCMView;
        [self addSubview:self.carNoCMView];
        [carNoCMView release];
        
        //3.0speedCMView
        CMTextView *speedCMView = [[CMTextView alloc] initWithFrame:CGRectMake(70, 25, 230, 20)];
        speedCMView.backgroundColor = [UIColor clearColor];
        speedCMView.titleLabel.text = @"速度(km/h):";
        self.speedCMView = speedCMView;
        [self addSubview:self.speedCMView];
        [speedCMView release];
        
        //4.0stateCMView
        CMTextView *stateCMView = [[CMTextView alloc] initWithFrame:CGRectMake(20, 50, 280, 20)];
        stateCMView.backgroundColor = [UIColor clearColor];
        stateCMView.titleLabel.text = @"状态:";
        self.stateCMView = stateCMView;
        [self addSubview:self.stateCMView];
        [stateCMView release];
        
        //5.0positionCMView
        CMTextView *positionCMView = [[CMTextView alloc] initWithFrame:CGRectMake(20, 70, 260, 40)];
        positionCMView.backgroundColor = [UIColor clearColor];
        positionCMView.titleLabel.text = @"位置:";
        self.positionCMView = positionCMView;
        [self addSubview:self.positionCMView];
        [positionCMView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**设置cell车辆照片
 *
 **/
- (void)setCellImage:(NSString *)imageName
{
    UIImage *image = [[CMResManager getInstance] imageForKey:imageName];
    if ( NULL != UIGraphicsBeginImageContextWithOptions ) {
        UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    }
    else {
        UIGraphicsBeginImageContext(imageSize);
    }
    [image drawInRect:imageRect];
    
}

@end
//CMLabel
@implementation CMLabel
@synthesize textVertical = _textVertical;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        self.textVertical = UITextVerticalMiddle;
    }
    
    return self;
}

- (void)setTextVertical:(UITextVertical)textVertical
{
    _textVertical = textVertical;
    [self setNeedsLayout];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch ( self.textVertical ) {
        case UITextVerticalTop:
        {
            textRect.origin.y = bounds.origin.y;
        }break;
        case UITextVerticalBottom:
        {
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
        }break;
        case UITextVerticalMiddle:
        default:textRect.origin.y = bounds.origin.y + ( bounds.size.height - textRect.size.height ) / 2.0;
            break;
    }    
    
    return textRect;
}

- (void)drawTextInRect:(CGRect)rect
{
    CGRect actualRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end

//CMTextView
@implementation CMTextView
@synthesize titleLabel = _titleLabel;
@synthesize contentLabel = _contentLabel;



- (void)dealloc
{
    [_titleLabel release];
    [_contentLabel release];
    
    [super dealloc];
}

/**初始化
 *@param frame:CMTextView大小
 *return self*/
- (id)initWithFrame:(CGRect)frame  
{
    self = [super initWithFrame:frame];
    if ( self ) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blueColor];
        self.titleLabel = titleLabel;
        [titleLabel release];

        CMLabel *contentLabel = [[CMLabel alloc] init];    
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.contentMode = UIViewContentModeScaleToFill;
        contentLabel.textVertical = UITextVerticalTop;
        
        self.contentLabel = contentLabel;
        [self.contentLabel addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
        [contentLabel release];
    }
    
    return self;
}

- (void)layoutSubviews
{
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    self.titleLabel.frame = CGRectMake(0, 0, titleSize.width * 1.2, titleSize.height);
    
//    CGSize contentSize = [self.contentLabel.text sizeWithFont:self.contentLabel.font];
//    NSInteger lineNum  = 1;
//    if ( contentSize.width > 205 ) {
//        lineNum = (NSInteger)(( contentSize.width - 205 ) / 245 + 1 );
//        if ( contentSize.width > 460 ) {
//            lineNum ++;
//        }
//        else if ( contentSize.width > 255 && contentSize.width < 450 )
//        {
//            lineNum ++;
//        }
//    }
//    NSLog(@"contentSize.width = %f lineNum = %d",contentSize.width,lineNum);  
//    float contentLabelHight = lineNum * contentSize.height;
    self.contentLabel.frame = CGRectMake(0, 0, 260, 100);
    self.contentLabel.numberOfLines = 0;
}
@end
