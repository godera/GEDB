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
 *@return 建表成功與否
 */
 
+(BOOL)createTableIfNotExistsViaEntityClass:(Class)entityClass;

/**
 *@brief 插入一個實體
 *@param entity-要插入的實體，含有結果值的實體，設置用
 *@return 插入實體成功與否
 */
 
+ (BOOL)insertEntity:(id)entity;
+ 
/**
 *@brief 刪除一個實體
 *@param entity-要刪除的實體，條件實體，查詢用
 *@return 刪除數據成功與否
 */

+ (BOOL)deleteEntity:(id)entity;
+ 
/**
 *@brief 改變表中的實體
 *@param fromEntity-條件實體，查詢用
 *       toEntity-含有結果值的實體，設置用
 *@return 改變實體成功與否
 */

+ (BOOL)updateEntity:(id)fromEntity toEntity:(id)toEntity;
+ 
/**
 *@brief 查詢符合條件的實體
 *@param entity-條件實體，查詢用
 *@return 查詢回來的實體數組
 */

+ (NSArray*)queryEntity:(id)entity;

@end

用法示例：

    [GEDB createTableIfNotExistsViaEntityClass:[SQLEntity class]];
    NSLog(@"original db：%@",[GEDB queryEntity:[SQLEntity new]]);
    
    SQLEntity* insertEntity = [SQLEntity new];
    insertEntity.name = @"teacher1";
    insertEntity.age = @100;
    insertEntity.ID = @1;
    [GEDB insertEntity:insertEntity];
    SQLEntity* insertEntity2= [SQLEntity new];
    insertEntity2.name = @"student1";
    insertEntity2.ID = @2;
    [GEDB insertEntity:insertEntity2];
    NSLog(@"db after insertion：%@",[GEDB queryEntity:[SQLEntity new]]);
    

    SQLEntity* fromEntity = [SQLEntity new];
    fromEntity.name = @"teacher1";
    SQLEntity* toEntity = [SQLEntity new];
    toEntity.name = @"Li Jingcheng";
    toEntity.age = @28;
    [GEDB updateEntity:fromEntity toEntity:toEntity];
    NSLog(@"db after updating：%@",[GEDB queryEntity:[SQLEntity new]]);

    SQLEntity* deleteEntity = [SQLEntity new];
    deleteEntity.ID = @2;
    [GEDB deleteEntity:deleteEntity];
    NSLog(@"db after deletion：%@",[GEDB queryEntity:[SQLEntity new]]);
    
    SQLEntity* queryEntity= [SQLEntity new];
    queryEntity.name = @"Li Jingcheng";
    NSLog(@"info about 'Li Jingcheng'：%@",[GEDB queryEntity:queryEntity]);
