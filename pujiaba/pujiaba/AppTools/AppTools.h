//
//  AppTools.h
//  douban
//
//  Created by zzzzz on 15/12/18.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 *  这个是一个通用的正式协议，用来让view操作controller弹出viewcontroller
 */
@protocol ZZZMyPushViewControllerDelegate <NSObject>

@optional
- (void)pushMyViewController:(UIViewController *)viewController;
- (void)presentMyViewController:(UIViewController *)viewController;

@end

typedef void(^AppToolsSuccessBolck)(NSData *resultData);
typedef void(^AppToolsFailBlock)(NSError *error);
typedef void(^AppToolsAlertBlock)();


@interface AppTools : NSObject

/**
 *  用GET方法去请求数据
 *
 *  @param urlStr       请求地址url
 *  @param dicPara      参数列表
 *  @param successBlock 成功后回调的block
 *  @param failBlock    失败后回调的block
*/
+ (void)getDataFromNetUseGETMethodWithUrl:(NSString *)urlStr andParameters:(NSDictionary *)dicPara successBlock:(AppToolsSuccessBolck)successBlock failBlock:(AppToolsFailBlock)failBlock;
+ (void)getDataFromNetUseGETMethodAFNWithUrl:(NSString *)urlStr andParameters:(NSDictionary *)dicPara successBlock:(AppToolsSuccessBolck)successBlock failBlock:(AppToolsFailBlock)failBlock;


/**
 *  用POST方法去请求数据
 *
 *  @param urlStr       请求地址url
 *  @param dicPara      参数列表
 *  @param successBlock 成功后回调的block
 *  @param failBlock    失败后回调的block
 */
+ (void)getDataFromNetUsePOSTMethodWithUrl:(NSString *)urlStr andParameters:(NSDictionary *)dicPara successBlock:(AppToolsSuccessBolck)successBlock failBlock:(AppToolsFailBlock)failBlock;


/**
 *  用户登录成功，修改userdefault中isLogin的登录状态和当前登录的账号
 */
+ (void)userLoginSuccess:(NSString *)userAccount;

/**
 *  用户注销成功，修改userdefault中isLogin的登录状态
 */
+ (void)userLogoutSuccess;

/**
 *  判断用户是否是登录状态
 *
 *  @return 用户已经登录返回yes，否则返回no
 */
+ (BOOL)userIsLogin;

/**
 *  获得当前登录的用户账号
 *
 *  @return 如果用户已经登录，则返回用户账号，否则返回空字符串
 */
+ (NSString *)currentUserAccount;


/**
 *  将图片链接换成本地图片链接
 *
 *  @param imageUrl 图片链接
 *  @param folders  从document到保存图片的地方所途经的所有文件夹
 *
 *  @return 本地图片保存或者将要保存的路径路径
 */
+ (NSString *)createImageLocalPathUseUrl:(NSString *)imageUrl withFolders:(NSArray <NSString *> *)folders;

/**
 *  将图片保存到本地
 *
 *  @param image 要保存的图片
 *  @param path  保存到的本地路径（一般用上面转换图片链接的方法返回的路径）
 *
 *  @return 保存成功返回YES，否则返回NO
 */
+ (BOOL)saveImageOnLocal:(UIImage *)image localPath:(NSString *)path;


/**
 *  创建一个文件路径
 *
 *  @param folders  从document开始经过哪些文件夹
 *  @param fileName 文件的名字
 *
 *  @return 返回创建好的文件名字
 */
+ (NSString *)createFilePathFromDocumentWithFolders:(NSArray<NSString *> *)folders fileName:(NSString *)fileName;

/**
 *  保存数据到本地
 *
 *  @param data 保存的数据
 *  @param path 保存的文件路径
 *
 *  @return 保存成功返回YES，否则返回NO
 */
+ (BOOL)saveDataOnLocal:(NSData *)data localPath:(NSString *)path;

/**
 *  返回一个只有一个按钮的提示框，仅仅起到提示作用
 *
 *  @param msg   提示的信息
 *  @param block 点击按钮回调的事件
 */
+ (UIAlertController *)alertWithMessage:(NSString *)msg block:(AppToolsAlertBlock)block;

@end
