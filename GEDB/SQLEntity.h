//
//  SQLEntity.h
//  GEDB
//
//  Created by Dawn on 2014/3/31.
//  Copyright (c) 2014年 god. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLEntity : NSObject

@property (nonatomic, copy) NSString* name;
@property (nonatomic, strong) NSNumber* ID;
@property (nonatomic, strong) NSNumber* age;
@property (nonatomic, strong) NSData *icon;

@end
