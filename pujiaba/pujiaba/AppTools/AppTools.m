//
//  AppTools.m
//  douban
//
//  Created by zzzzz on 15/12/18.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "AppTools.h"


#define USERACCOUNT @"userAccount"
#define ISLOGIN     @"isLogin"

@implementation AppTools

+ (void)getDataFromNetUseGETMethodWithUrl:(NSString *)urlStr andParameters:(NSDictionary *)dicPara successBlock:(AppToolsSuccessBolck)successBlock failBlock:(AppToolsFailBlock)failBlock{
    
    NSString *finalUrlString = [urlStr stringByAppendingString:@""];
    for (NSString *key in dicPara) {
        if ([[[dicPara allKeys] firstObject] isEqualToString:key]) {
            finalUrlString = [urlStr stringByAppendingString:@"?"];
        }
        finalUrlString = [finalUrlString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, dicPara[key]]];
    }
    NSLog(@"%d -- %s\n%@", __LINE__, __FUNCTION__, finalUrlString);
    
    NSURL *url = [NSURL URLWithString:finalUrlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 10;//设置超时时间
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data == nil) {
                NSLog(@"%d -- %s\n网络请求失败", __LINE__, __FUNCTION__);
                failBlock(error);
            }else{
                NSLog(@"%d -- %s\nget网络请求数据成功", __LINE__, __FUNCTION__);
                successBlock(data);
            }
            
        });
        
    }];
    
    [task resume];
    [request release];
}

+ (void)getDataFromNetUseGETMethodAFNWithUrl:(NSString *)urlStr andParameters:(NSDictionary *)dicPara successBlock:(AppToolsSuccessBolck)successBlock failBlock:(AppToolsFailBlock)failBlock{
    NSLog(@"%@", urlStr);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
//    [manager GET:@"" parameters:dicPara progress:^(NSProgress * _Nonnull downloadProgress) {
//        ;
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        ;
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        ;
//    }];
    [manager GET:urlStr parameters:dicPara progress:^(NSProgress * _Nonnull downloadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock([NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}

+ (void)getDataFromNetUsePOSTMethodWithUrl:(NSString *)urlStr andParameters:(NSDictionary *)dicPara successBlock:(AppToolsSuccessBolck)successBlock failBlock:(AppToolsFailBlock)failBlock{
    
    NSString *parameters = @"";
    for (NSString *key in dicPara) {
        parameters = [parameters stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, dicPara[key]]];
    }
    NSLog(@"%d -- %s\n%@", __LINE__, __FUNCTION__, parameters);
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = 10;//设置超时时间
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data == nil) {
                NSLog(@"%d -- %s\n网络请求失败", __LINE__, __FUNCTION__);
                failBlock(error);
            }else{
                NSLog(@"%d -- %s\npost网络请求数据成功", __LINE__, __FUNCTION__);
                successBlock(data);
            }
        });
        
    }];
    
    [task resume];
    [request release];
}



+ (NSString *)createImageLocalPathUseUrl:(NSString *)imageUrl withFolders:(NSArray <NSString *> *)folders{
    NSString *picPath = [imageUrl lastPathComponent];
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *finalPath = [document copy];
    for (NSString *folder in folders) {
        finalPath = [finalPath stringByAppendingPathComponent:folder];
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:finalPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    finalPath = [finalPath stringByAppendingPathComponent:picPath];
    return finalPath;
}

+ (BOOL)saveImageOnLocal:(UIImage *)image localPath:(NSString *)path{
    NSData *data = UIImageJPEGRepresentation(image, 1);//将图片转换成data保存
    if (data == nil) {
        NSLog(@"无效图片文件, 保存失败");
        return NO;
    } else {
        [data writeToFile:path atomically:YES];
        return YES;
    }
}

+ (NSString *)createFilePathFromDocumentWithFolders:(NSArray<NSString *> *)folders fileName:(NSString *)fileName{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *finalPath = [NSString stringWithFormat:@"%@", document];
    for (NSString *folder in folders) {
        finalPath = [finalPath stringByAppendingPathComponent:folder];
    }
    
    [[NSFileManager defaultManager] createDirectoryAtPath:finalPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    finalPath = [finalPath stringByAppendingPathComponent:fileName];
    return finalPath;
}

+ (BOOL)saveDataOnLocal:(NSData *)data localPath:(NSString *)path{
    
    return [data writeToFile:path atomically:YES];
}

+ (UIAlertController *)alertWithMessage:(NSString *)msg block:(AppToolsAlertBlock)block{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    [alert addAction:act];
    return alert;
}















+ (void)userLoginSuccess:(NSString *)userAccount{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:ISLOGIN];
    [[NSUserDefaults standardUserDefaults] setObject:userAccount forKey:USERACCOUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];//强制保存，有时候userdefault的保存是有延迟的，所以可能会导致读取延迟，不能正确显示结果，这样使用可以立即保存数据
}
+ (void)userLogoutSuccess{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:ISLOGIN];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USERACCOUNT];
    [[NSUserDefaults standardUserDefaults] synchronize];//强制保存，有时候userdefault的保存是有延迟的，所以可能会导致读取延迟，不能正确显示结果，这样使用可以立即保存数据
}
+ (BOOL)userIsLogin{
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:ISLOGIN];
    return [result isEqualToString:@"YES"];
}
+ (NSString *)currentUserAccount{
    NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:USERACCOUNT];
    return account;
}

@end
