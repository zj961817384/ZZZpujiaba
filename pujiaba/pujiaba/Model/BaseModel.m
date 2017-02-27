//
//  BaseModel.m
//  pujiaba
//
//  Created by zzzzz on 15/12/26.
//  Copyright © 2015年 zzzzz. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //输出和model不匹配的键值对
    NSLog(@"Key:%@ -- value:%@", key, value);
}

@end
