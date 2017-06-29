//
//  NSObject+Coding.m
//  FoundationDemo
//
//  Created by Dawn Wang on 2017/6/23.
//  Copyright © 2017年 Dawn Wang. All rights reserved.
//

#import "NSObject+Coding.h"

#import <objc/runtime.h>
#import "NSObject+Class.h"



@implementation NSObject (Coding)
- (void)enumPropertyList:(void(^)(id key, id value))emunBlock {
    
    [self enumClass:^(__unsafe_unretained Class cl, BOOL *stop) {
        
        [self propertyForClass:cl finish:^(PropertyModel *pModel) {
            NSString *attributeTypeString = pModel.propertyType;
            NSString *name = pModel.name;
            if ([attributeTypeString hasPrefix:@"@\""]) {
                attributeTypeString = [attributeTypeString substringWithRange:NSMakeRange(2, attributeTypeString.length - 3)];
                
                Class attributeClass = NSClassFromString(attributeTypeString);
                
                
                BOOL isConformCoding = class_conformsToProtocol(attributeClass, NSProtocolFromString(@"NSCoding"));
                NSString *message = [NSString stringWithFormat:@"model:%@ 不支持NSCoding协议",attributeTypeString];
                NSAssert(isConformCoding, message);
            }
            
            if (emunBlock) {
                emunBlock(name,[self valueForKey:name]);
            }
        }];
    }];
    
    
    
}

- (void)coding_encode:(NSCoder *)aCoder {
    
    [self enumPropertyList:^(id key, id value) {
        
        [aCoder encodeObject:value forKey:key];
    }];
}
- (nullable instancetype)coding_decode:(NSCoder *)aDecoder {
    [self enumPropertyList:^(id key, id value) {
        
        [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
    }];
    
    return self;
}

@end
