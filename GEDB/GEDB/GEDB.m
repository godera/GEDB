//
//  GEDB.m
//  GEDB
//
//  Created by Dawn on 2014/3/31.
//  Copyright (c) 2014年 god. All rights reserved.
//  TUTOR QQ:52863466
//  DEVELOPER QQ:719181178
//

#import "GEDB.h"
#import <objc/runtime.h>
#import "FMDB.h"
#import "NSString+GodEraAdd.h"

#define TABLE_NAME_PREFIX @"table_"

@interface GEDB ()


@end


@implementation GEDB

+(BOOL)createTableIfNotExistsViaEntityClass:(Class)entityClass{
    
    NSString* tableName = [self tableNameFromEntityClass:entityClass];

    NSMutableString *sqlcmd = [NSMutableString stringWithFormat:@"CREATE TABLE  IF NOT EXISTS %@(_id INTEGER  PRIMARY KEY  AUTOINCREMENT  NOT NULL",tableName];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(entityClass, &count);
    for(int i = 0 ; i < count ; i++){
        NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        
        [sqlcmd appendFormat:@",%@",propertyName];
        
        NSString *propertyAttribute = [NSString stringWithCString:property_getAttributes(properties[i]) encoding:NSUTF8StringEncoding];
        
//        NSLog(@"%@",propertyAttribute);
        /*
        if ([propertyAttribute containsString:@"@"]) {//說明是個對象
            if ([propertyAttribute containsString:@"T@\"NS"]) {//說明是個系統對象
                NSLog(@"系統對象");
            }else{//用戶對象
                NSLog(@"用戶對象");
            }
        }else{//非對象
            NSLog(@"非對象");
        }
         */
        
        NSString* dataType = nil;
        if ([propertyAttribute containsString:@"NSString"]) {
            dataType = @"TEXT";
        }else if ([propertyAttribute containsString:@"NSNumber"] /*|| [propertyAttribute containsString:@"Tf"] || [propertyAttribute containsString:@"Td"]*/){
            dataType = @"REAL";
        }/*else if ([propertyAttribute containsString:@"Ti"]){
          dataType = @"INTEGER";
          }*/else if ([propertyAttribute containsString:@"NSData"]){
              dataType = @"BLOB";
          }else{
              dataType= @"NULL";
          }
        
        [sqlcmd appendFormat:@" %@",dataType];

    }
    free(properties);
    
    [sqlcmd appendString:@");"];
    
    GEDBLog(@"%@",sqlcmd);

    FMDatabase* db = [self database];
    BOOL opened = [db open];
    if (opened == NO) {
        NSLog(@"Could not open db.");
        return NO;
    }
    BOOL ok = [db executeUpdate:sqlcmd];
    
    [db close];
    
    if (ok) {
        return YES;
    }else{
        return NO;
    }
}


+ (BOOL)insert:(id)entity
{
    NSString* tableName = [self tableNameFromEntityClass:[entity class]];
    
    NSMutableArray *columns = [NSMutableArray array];
    NSMutableString* values = [NSMutableString string];

    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([entity class], &count);
    for(int i = 0 ; i < count ; i++){
        NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        id value = [entity valueForKey:propertyName];
        if (value && ![value isMemberOfClass:[NSNull class]]) {
            [columns addObject:propertyName];
            [values appendFormat:@"'%@',",value];
        }
    }
    free(properties);
    
    [values deleteCharactersInRange:NSMakeRange(values.length - 1, 1)];
    
    NSMutableString *sqlcmd = [NSMutableString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@);", tableName, [columns componentsJoinedByString:@","], values];
    
    GEDBLog(@"%@",sqlcmd);

    FMDatabase *db = [self database];
    
    BOOL opened = [db open];
    if (opened == NO) {
        NSLog(@"Could not open db.");
        return NO;
    }
    BOOL ok = [db executeUpdate:sqlcmd];
    
    [db close];
    
    if (ok) {
        return YES;
    }else{
        return NO;
    }
}


+ (BOOL)deleteWhere:(id)whereEntity
{
    NSString* tableName = [self tableNameFromEntityClass:[whereEntity class]];
    
    //where
    NSMutableString *sqlcmd = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE ",tableName];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([whereEntity class], &count);
    for(int i = 0 ; i < count ; i++){
        NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        
        id value = [whereEntity valueForKey:propertyName];
        if (value && ![value isMemberOfClass:[NSNull class]]) {
            [sqlcmd appendFormat:@"%@ = '%@' AND ",propertyName,value];
        }
    }
    free(properties);
    
    [sqlcmd deleteCharactersInRange:NSMakeRange(sqlcmd.length - 5, 5)];//刪除最後一個" AND "
    [sqlcmd appendString:@";"];

    GEDBLog(@"%@",sqlcmd);
    
    FMDatabase *db = [self database];
    
    BOOL opened = [db open];
    if (opened == NO) {
        NSLog(@"Could not open db.");
        return NO;
    }
    
    BOOL ok = [db executeUpdate:sqlcmd];
    
    [db close];
    
    if (ok) {
        return YES;
    }else{
        return NO;
    }
}


+ (BOOL)updateWhere:(id)whereEntity set:(id)setEntity
{
    NSString* tableName = [self tableNameFromEntityClass:[whereEntity class]];

    //from-where
    NSMutableString *wheres = [NSMutableString string];
    
    unsigned int countFrom;
    objc_property_t *propertiesFrom = class_copyPropertyList([whereEntity class], &countFrom);
    for(int i = 0 ; i < countFrom ; i++){
        NSString *propertyName = [NSString stringWithCString:property_getName(propertiesFrom[i]) encoding:NSUTF8StringEncoding];
        
        id value = [whereEntity valueForKey:propertyName];
        
        if (value && ![value isMemberOfClass:[NSNull class]]) {
            [wheres appendFormat:@"%@ = '%@' AND ", propertyName, value];
        }
    }
    free(propertiesFrom);
    
    [wheres deleteCharactersInRange:NSMakeRange(wheres.length - 5, 5)];//刪除最後一個" AND "
    
    
    //to-set
    NSMutableString *settings = [NSMutableString string];
    
    unsigned int countTo;
    objc_property_t *propertiesTo = class_copyPropertyList([setEntity class], &countTo);
    for(int i = 0 ; i < countTo ; i++){
        NSString *propertyName = [NSString stringWithCString:property_getName(propertiesTo[i]) encoding:NSUTF8StringEncoding];
        id value = [setEntity valueForKey:propertyName];
        if (value && ![value isMemberOfClass:[NSNull class]]) {
            [settings appendFormat:@"%@ = '%@',", propertyName, value];
        }
    }
    [settings deleteCharactersInRange:NSMakeRange(settings.length - 1, 1)];//刪除最後一個","

    free(propertiesTo);
    
    NSMutableString *sqlcmd = [[NSMutableString alloc] initWithFormat:@"UPDATE %@ SET %@ WHERE %@;", tableName, settings, wheres];
    
    GEDBLog(@"%@",sqlcmd);
    
    FMDatabase *db = [self database];
    
    BOOL opened = [db open];
    if (opened == NO) {
        NSLog(@"Could not open db.");
        return NO;
    }
    
    BOOL ok = [db executeUpdate:sqlcmd];
    
    [db close];
    
    if (ok) {
        return YES;
    }else{
        return NO;
    }

}


+ (NSArray*)selectWhere:(id)whereEntity
{
    NSString* tableName = [self tableNameFromEntityClass:[whereEntity class]];
    
    //where
    NSMutableString *sqlcmd = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE ",tableName];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([whereEntity class], &count);
    for(int i = 0 ; i < count ; i++){
        NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
        
        id value = [whereEntity valueForKey:propertyName];
        if (value && ![value isMemberOfClass:[NSNull class]]) {
            [sqlcmd appendFormat:@"%@ = '%@' AND ",propertyName,value];
        }
    }
    NSInteger uselessLength = 0;
    if ([sqlcmd containsString:@"AND"]) {
        uselessLength = 5;
    }else{
        uselessLength = 7;
    }
    [sqlcmd deleteCharactersInRange:NSMakeRange(sqlcmd.length - uselessLength, uselessLength)];//刪除最後一個" AND "或" WHERE "
    [sqlcmd appendString:@";"];
    
    
    GEDBLog(@"%@",sqlcmd);
    
    FMDatabase *db = [self database];
    
    BOOL opened = [db open];
    if (opened == NO) {
        NSLog(@"Could not open db.");
        return nil;
    }
    
    FMResultSet* resultSet = [db executeQuery:sqlcmd];
    
    NSMutableArray *resultArray = [NSMutableArray array];
    
    while ([resultSet next]) {
        @autoreleasepool {
            id anEntity = [[whereEntity class] new];
            
            for(int i = 0 ; i < count ; i++){
                NSString *propertyName = [NSString stringWithCString:property_getName(properties[i]) encoding:NSUTF8StringEncoding];
                
                id value = [resultSet objectForColumnName:propertyName];
                
                if (value && ![value isMemberOfClass:[NSNull class]]) {
                    [anEntity setValue:value forKey:propertyName];
                }
            }
            
            [resultArray addObject:anEntity];
        }
    }
    
    free(properties);
    
    [db close];
    
    return resultArray;
}

/////////////////////////////////////////////////////////////
+(NSString*)pathInDocumentWithFileName:(NSString*)fileName
{
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* docDr = [path objectAtIndex:0];
    return [docDr stringByAppendingPathComponent:fileName];
}

+(NSString*)tableNameFromEntityClass:(Class)entityClass{
    return [NSString stringWithFormat:@"%@%@",TABLE_NAME_PREFIX,NSStringFromClass(entityClass)];
}

+(FMDatabase*)database{
    NSString *dbPath = [self pathInDocumentWithFileName:DB_NAME];
//    NSLog(@"%@",dbPath);
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    return db;
}

@end
