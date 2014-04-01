GEDB
====

/**
 *@brief SQLite的建表和增刪改查的面向對象的封裝;實體的屬性只能是NSString、NSNumber、UIImage三種類型,不建議在實體里有UIImage對象
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
