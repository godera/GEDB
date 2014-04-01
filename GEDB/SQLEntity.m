//
//  SQLEntity.m
//  GEDB
//
//  Created by Dawn on 2014/3/31.
//  Copyright (c) 2014年 god. All rights reserved.
//

#import "SQLEntity.h"
#import <objc/runtime.h>

@implementation SQLEntity


-(NSString *)description{

    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableString * mString = [NSMutableString string];
    
    for(int i = 0 ; i < count ; i++){
        NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        
        id value = [self valueForKey:propertyName];
        [mString appendFormat:@"%@ = '%@', ",propertyName,value];
    }
    free(properties);
    
    [mString deleteCharactersInRange:NSMakeRange(mString.length - 2, 2)];//刪除最後一個", "
    return [mString copy];
}

@end
