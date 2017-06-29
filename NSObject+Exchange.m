//
//  NSObject+Exchange.m
//  FoundationDemo
//
//  Created by Dawn Wang on 2017/6/21.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "NSObject+Exchange.h"
#import <objc/runtime.h>


@implementation NSObject (Exchange)
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    

    id objc = [[self alloc] init];
    unsigned int count;
    Ivar *varList = class_copyIvarList(self, &count);//类方法里面的self是class 实例方法里面的self是对象首地址
    
    for (int i = 0; i < count; i++) {
        Ivar ivarCach = varList[i];
        const char *nameChar = ivar_getName(ivarCach);
        NSString *name = [NSString stringWithUTF8String:nameChar];
        if (name && name.length) {
            NSString *key = [name substringFromIndex:1];
            id value = dic[key];
            if ([value isKindOfClass:[NSDictionary class]]) {
                const char *typeChar = ivar_getTypeEncoding(ivarCach);
                NSString *type = [NSString stringWithUTF8String:typeChar];
                Class modelClass = [self classFromTypeString:type];
                if (modelClass) {
                    value = [modelClass modelWithDic:value];
                }
            }
            
            if ([value isKindOfClass:[NSArray class]]) {

                if ([self respondsToSelector:@selector(arrayContainModel)]) {
                   
                    NSDictionary *keysAndValues = [self arrayContainModel];
                    NSString *typeString = keysAndValues[key];
                    if (typeString) {
                        Class modelClass = [self classFromTypeString:typeString];
                        if (modelClass) {
                            NSMutableArray *subArray = [NSMutableArray array];
                            [value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                                [subArray addObject:[modelClass modelWithDic:obj]];

                            }];
                            value = subArray;
                        }else{
                            NSLog(@"modelclass == nil");
                        }
                    }else{
                        NSLog(@"array contain model keys and valuse, value == nil");
                    }
                }else{
                    NSLog(@"model do not response arrayContainModel");
                }
                
            }
            
            if (value) {
                
                [objc setValue:value forKey:key];
            }
        }
    }
    return objc;
}
- (Class)classFromTypeString:(NSString *)type{
    
    NSRange beginRange = [type rangeOfString:@"\""];
    if (beginRange.location != NSNotFound) {
        type = [type substringFromIndex:beginRange.location + 1];
    }
    
    NSRange endRange = [type rangeOfString:@"\""];
    if (endRange.location != NSNotFound) {
        type = [type substringToIndex:endRange.location];
    }
    
//    NSError *error = nil;
//    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"@\\\"(.+?)\\\"" options:0 error:&error];//@\\\"(.+?)\\\"
//    if (!error) {
//        NSTextCheckingResult *checkResult = [expression firstMatchInString:type options:NSMatchingReportProgress range:NSMakeRange(0, type.length)];
//        
//        if (checkResult) {
//            NSString *resultType = [type substringWithRange:checkResult.range];
            Class result = NSClassFromString(type);
            return result;
//        }
//    }
//    return nil;
}

@end
