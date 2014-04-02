//
//  GEDB.h
//  GEDB
//
//  Created by Dawn on 2014/3/31.
//  Copyright (c) 2014年 god. All rights reserved.
//  TUTOR QQ:52863466
//  DEVELOPER QQ:719181178
//

#define DB_NAME @"DB.sqlite3"

#ifdef DEBUG
//本类打印语句的开关信息，设为0即关
#define DEBUG_GEDB 1
#else
#define DEBUG_GEDB 0
#endif

#if DEBUG_GEDB
#define GEDBLog NSLog
#else
#define GEDBLog(...)
#endif

#import <Foundation/Foundation.h>
/**
 *@brief SQLite的建表和增刪改查的面向對象的封裝;實體的屬性只能是 NSString、NSNumber、NSData 三種類型
 *@undone 事務操作尚未加上，批量增刪改耗時較多
 */
@interface GEDB : NSObject

/**
 *@brief 通過實體類來建表，表名包含實體類名，表單會默認建一個_id,其他字段都是以屬性名來命名
 *@param entityClass-實體類
 *@return 操作成功與否
 */
+(BOOL)createTableIfNotExistsViaEntityClass:(Class)entityClass;

/**
 *@brief 插入一個實體
 *@param entity-要插入的實體，含有結果值的實體，設置用
 *@return 操作成功與否
 */
+ (BOOL)insert:(id)entity;

/**
 *@brief 刪除符合條件的實體
 *@param whereEntity-要刪除的實體，條件實體，查詢用
 *@return 操作成功與否
 */
+ (BOOL)deleteWhere:(id)whereEntity;

/**
 *@brief 改變表中的實體
 *@param whereEntity-條件實體，查詢用
 *       setEntity-含有結果值的實體，設置用
 *@return 操作成功與否
 */
+ (BOOL)updateWhere:(id)whereEntity set:(id)setEntity;

/**
 *@brief 查詢符合條件的實體
 *@param whereEntity-條件實體，查詢用
 *@return 查詢回來的實體數組，數組項跟whereEntity一個Class
 */
+ (NSArray*)selectWhere:(id)whereEntity;

@end
