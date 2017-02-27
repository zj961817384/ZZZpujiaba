
//
//  Header.h
//  UI22_yubianyi
//
//  Created by zzzzz on 15/12/22.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#ifndef Header_h
#define Header_h

#if DEBUG

#define NSLog(FORMAT, ...) fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#define NSLog(FORMAT, ...) nil

#else

#define NSLog(FORMAT, ...) nil

#endif

//如果是DEBUG模式用测试服务器地址
#if DEBUG

#define     HttpBaseURL        @"http://www.test.com/" // 测试服务器

#else

#define     HttpBaseURL        @"http://www.baidu.com/" // 正式服务器

#endif

#endif /* Header_h */

//判断当前系统版本和手机类型
#define     iOS8     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO
