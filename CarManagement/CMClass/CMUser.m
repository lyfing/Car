//
//  CMUser.m
//  CarManagement
//
//  Created by YongFeng.li on 12-5-5.
//  Copyright (c) 2012年 gpssos.com. All rights reserved.
//

#import "CMUser.h"

@interface CMUser(Private)

/**读取持久化数据user
 *@param userAccount:用户账号
 *return nil*/
+ (CMUser *)readFromDisk:(NSString *)userAccount;

/**持久化路径
 *@param userAccount:用户名
 *return dirPath:归档文件路径*/
+ (NSString *)persistPath:(NSString *)basePath relativePath:(NSString *)relativepath;

@end

static CMUser *_instance = nil;

@implementation CMUser

@synthesize userAccount = _userAccount;
@synthesize userPassword = _userPassword;
@synthesize serverIpAddress = _serverIpAddress;
@synthesize serverIpPort = _serverIpPort;

- (void)dealloc
{
    [_userAccount release];
    [_userPassword release];
    [_serverIpAddress release];
    [_serverIpPort release];
    
    [super dealloc];
}


- (id)init
{
    self = [super init];
    
    return self;
}

/**清除数据
 *@param nil
 *return nil*/
- (void)clear
{
    self.userAccount = nil;
    self.userPassword = nil;
    self.serverIpAddress = nil;
    self.serverIpPort = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kLastUserAccount];
    [defaults removeObjectForKey:kLastUserPassword];
}


+ (CMUser *)getInstance
{
    @synchronized(self){
        if ( !_instance ) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *userAccount = [defaults objectForKey:kLastUserAccount];
            
            if ( userAccount ) {
                _instance = [CMUser readFromDisk:userAccount];
                if ( !_instance ) {
                  _instance = [[CMUser alloc] init];
                }
            }
            else {
                _instance = [[CMUser alloc] init];
            }
            
        }
    }

    return _instance;
}

/**APP Document路径
 *@param nil
 *return nil*/
+ (NSString *)documentPath
{
    NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [searchPath objectAtIndex:0];
    
    return path;
}

/**持久化存档
 *@param nil
 *return nil*/
- (void)persist
{
    NSString *docName = self.userAccount;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:docName forKey:kLastUserAccount];
    
    if ( docName ) {
        NSString *persisPath = [CMUser persistPath:docName relativePath:nil];
        [NSKeyedArchiver archiveRootObject:self toFile:persisPath];
    }
}

/**登陆信息
 *@param nil
 *return YES:有登陆信息 NO:无*/
- (BOOL)checkLoginInfo
{
    if ( self.userAccount && self.userPassword ) {
        return YES;
    }
    
    return NO;
}

#pragma private method
/**持久化路径
 *@param userAccount:用户名
 *return dirPath:归档文件路径*/
+ (NSString *)persistPath:(NSString *)basePath relativePath:(NSString *)relativepath
{
    NSString *dirPath = [[CMUser documentPath] stringByAppendingPathComponent:basePath];
    
    if ( relativepath != nil ) {
        dirPath = [dirPath stringByAppendingPathComponent:relativepath];    
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( ![fileManager fileExistsAtPath:dirPath] ) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:dirPath
               withIntermediateDirectories:YES 
                                attributes:nil
                                     error:&error];
        
        if ( error ) {
            NSLog(@"创建失败~");
            return nil;
        }
    }
    
    return dirPath;
}

/**读取持久化数据user
 *@param userAccount:用户账号
 *return nil*/
+ (CMUser *)readFromDisk:(NSString *)userAccount
{
    NSString *userFile = [CMUser persistPath:userAccount relativePath:nil];
    NSLog(@"[NSKeyedUnarchiver unarchiveObjectWithFile:userFile] = %@",[NSKeyedUnarchiver unarchiveObjectWithFile:userFile]);
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:userFile];
}

/**保存数据到/userName/docName
 *@param data:要保存的数据 dacName:保存数据的文件名
 *return YES:成功 NO:失败*/
- (BOOL)saveData:(NSData *)data path:(NSString *)docName

{
    NSString *path = [CMUser persistPath:self.userAccount relativePath:docName];
    NSLog(@"path = %@",path);
    NSLog(@"CMUser data:%@",data);
    NSLog(@"write sucess? %d",[data writeToFile:path atomically:YES]);
    
    return YES;
}

/**获取数据到/userName/docName
 *@param dacName:保存数据的文件名
 *return nil:失败 data:成功读取数据*/
- (NSData *)readData:(NSString *)docName
{
    NSString *path = [CMUser persistPath:self.userAccount relativePath:docName];
    NSData *data = nil;
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:path] ) {
        data = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    return data;
}

//执行+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path; 会默认调用
- (id)initWithCoder:(NSCoder *)decoder{
    
    if ( self = [super init] ) {
        self.userAccount = [decoder decodeObjectForKey:kLastUserAccount];
        self.userPassword = [decoder decodeObjectForKey:kLastUserPassword];
        self.serverIpAddress = [decoder decodeObjectForKey:kLastServerIpAddress];
        self.serverIpPort = [decoder decodeObjectForKey:kLastServerIpPort];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    
    [encoder encodeObject:self.userAccount forKey:kLastUserAccount];
    [encoder encodeObject:self.userPassword forKey:kLastUserPassword];
    [encoder encodeObject:self.serverIpAddress forKey:kLastServerIpAddress];
    [encoder encodeObject:self.serverIpPort forKey:kLastServerIpPort];
}

@end
