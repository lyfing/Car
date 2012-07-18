//
//  CMResManager.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-4.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "CMResManager.h"

@implementation CMResManager

static CMResManager *_instance = nil;
@synthesize imageResourceBundle = _imageResourceBundle;

- (void)dealloc
{
    [_imageResourceBundle release];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    return self;
}

+ (CMResManager *)getInstance
{
    @synchronized(self){
        if ( _instance == nil ) {
            _instance = [[CMResManager alloc] init];
        }
    }
    
    return _instance;
}

#pragma mark - 通过key获取图片资源
/**获取图片资源
 *@param key:图片名(不含后缀)
 *@return nil*/
- (UIImage *)imageForKey:(NSString *)key
{
    NSBundle *imageBundle = [self getImageBundle:IMAGE_BUNDLE];
    NSString *imagePath = [imageBundle pathForResource:key ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    
    return [image autorelease];
}

/**获取图片资源包
 *@param nil
 *return nil*/
- (NSBundle *)getImageBundle:(NSString *)sourceName
{
    if ( !_imageResourceBundle ) {
        NSString *imageBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:sourceName];
        _imageResourceBundle = [[NSBundle alloc] initWithPath:imageBundlePath];
        
    }
    
    return _imageResourceBundle;
}

/**直接获取图片资源
 *@param name:图片名
 *@return nil*/
- (UIImage *)imageForName:(NSString *)name
{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"Image" ofType:@"bundle"]];
    NSString * sourcePath = [bundle pathForResource:name ofType:@"png"]; 
    UIImage *image = [UIImage imageWithContentsOfFile:sourcePath];
    
    return image;
}

/**获取自适应拉伸image
 *@param key:png图片名称
 *return image:拉伸后的图片*/
+ (UIImage*)middleStretchableImageWithKey:(NSString*)key 
{
    UIImage *image = [[CMResManager getInstance] imageForKey:key];
    NSLog(@"image.width = %f,image.hight = %f",image.size.width,image.size.height);
    
    return [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}

/**获取纵向拉伸image
 *@param key:png图片名称
 *return image:拉伸后的图片*/
+ (UIImage *)longitudinalStretchableImageWithKey:(NSString *)key
{
    UIImage *image = [[CMResManager getInstance] imageForKey:key];
    
    return [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height];
}

+ (id) allocWithZone:(NSZone*) zone {
	@synchronized(self) { 
		if (_instance == nil) {
			_instance = [super allocWithZone:zone];  // assignment and return on first allocation
			return _instance;
		}
	}
	return nil;
}

- (id) copyWithZone:(NSZone*) zone {
	return _instance;
}

- (id) retain {
	return _instance;
}

- (unsigned) retainCount {
	return UINT_MAX;  //denotes an object that cannot be released
}

- (id) autorelease {
	return self;
}
@end
