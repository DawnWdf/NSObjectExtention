//
//  NSObject+Copy.m
//  FoundationDemo
//
//  Created by Dawn Wang on 2017/6/27.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "NSObject+Copy.h"
#import "NSObject+Class.h"

@implementation NSObject (Copy)

- (id)dw_copyZone:(NSZone *)zone {
    id classObject = [[[self class] alloc] init];
    [self enumClass:^(__unsafe_unretained Class cl, BOOL *stop) {
        [self propertyForClass:cl finish:^(PropertyModel *pModel) {
            id value = [self valueForKey:pModel.name];
            [classObject setValue:value forKey:pModel.name];
        }];
    }];
    return classObject;
}

//- (id)dw_multableCopyZone:(NSZone *)zone {
//    id classMultableObject = [[[self class] alloc] init];
//    [self enumClass:^(__unsafe_unretained Class cl, BOOL *stop) {
//        [self propertyForClass:cl finish:^(PropertyModel *pModel) {
//            id value = [self valueForKey:pModel.name];
//            [classObject setValue:value forKey:pModel.name];
//        }];
//    }];
//    return classObject;
//}
@end
