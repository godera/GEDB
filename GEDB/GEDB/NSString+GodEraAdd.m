//
//  NSString+GodEraAdd.m
//  GEDB
//
//  Created by Dawn on 2014/3/31.
//  Copyright (c) 2014年 god. All rights reserved.
//  TUTOR QQ:52863466
//  DEVELOPER QQ:719181178
//

#import "NSString+GodEraAdd.h"

@implementation NSString (GodEraAdd)

-(BOOL)containsString:(NSString*)aShortString
{
    NSRange range = [self rangeOfString:aShortString];
    if (range.location != NSNotFound) {
        return YES;
    }else{
        return NO;
    }
}

@end
