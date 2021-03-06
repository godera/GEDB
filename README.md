GEDB
====
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


用法示例：

    [GEDB createTableIfNotExistsViaEntityClass:[SQLEntity class]];
    NSLog(@"original db：%@",[GEDB selectWhere:[SQLEntity new]]);
    
    SQLEntity* insertEntity = [SQLEntity new];
    insertEntity.name = @"teacher1";
    insertEntity.age = @100;
    insertEntity.ID = @1;
    [GEDB insert:insertEntity];
    SQLEntity* insertEntity2= [SQLEntity new];
    insertEntity2.name = @"student1";
    insertEntity2.ID = @2;
    [GEDB insert:insertEntity2];
    NSLog(@"db after insertion：%@",[GEDB selectWhere:[SQLEntity new]]);
    

    SQLEntity* whereEntity = [SQLEntity new];
    whereEntity.name = @"teacher1";
    SQLEntity* setEntity = [SQLEntity new];
    setEntity.name = @"Li Jingcheng";
    setEntity.age = @28;
    [GEDB updateWhere:whereEntity set:setEntity];
    NSLog(@"db after updating：%@",[GEDB selectWhere:[SQLEntity new]]);

    SQLEntity* whereEntityDel = [SQLEntity new];
    whereEntityDel.ID = @2;
    [GEDB deleteWhere:whereEntityDel];
    NSLog(@"db after deletion：%@",[GEDB selectWhere:[SQLEntity new]]);
    
    SQLEntity* whereEntitySel= [SQLEntity new];
    whereEntitySel.name = @"Li Jingcheng";
    NSLog(@"info about 'Li Jingcheng'：%@",[GEDB selectWhere:whereEntitySel]);
    