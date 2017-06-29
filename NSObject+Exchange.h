//
//  NSObject+Exchange.h
//  FoundationDemo
//
//  Created by Dawn Wang on 2017/6/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExchangeProtocol.h"

@interface NSObject (Exchange) <ExchangeProtocol>

+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
