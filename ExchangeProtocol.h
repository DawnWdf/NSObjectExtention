//
//  ExchangeProtocol.h
//  FoundationDemo
//
//  Created by Dawn Wang on 2017/6/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol ExchangeProtocol <NSObject>

@optional
+ (NSDictionary *)arrayContainModel DEPRECATED("方法已经过期的demo",2_0);

@end
