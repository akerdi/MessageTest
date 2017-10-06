//
//  XXBaseDB.m
//  XXT
//
//  Created by aKerdi on 2017/6/3.
//  Copyright © 2017年 xxtstudio. All rights reserved.
//

#import "XXBaseDB.h"

@implementation XXBaseDB

+(LKDBHelper *)getUsingLKDBHelper{
    static LKDBHelper *db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        db = [[LKDBHelper alloc]initWithDBPath:[self dbPath]];
    });
    return db;
}

+(NSString *)dbPath{
    NSString *xxtDBPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"db/XXTDB.sqlite"];
    return xxtDBPath;
}

+(BOOL)dbWillInsert:(NSObject *)entity{
    return YES;
}

+(void)dbDidInserted:(NSObject *)entity result:(BOOL)result{}

+(BOOL)isContainParent{
    return YES;
}

@end

@implementation NSObject (PrintSQL)

+(NSString *)getCreateTableSQL{
    LKModelInfos *infos = [self getModelInfos];
    NSString *primaryKey = [self getPrimaryKey];
    NSMutableString *table_pars = [NSMutableString string];
    
    for (int i=0; i<infos.count; i++) {
        if (i>0) [table_pars appendString:@","];
        
        LKDBProperty *property = [infos objectWithIndex:i];
        [self columnAttributeWithProperty:property];
        
        [table_pars appendFormat:@"%@ %@",property.sqlColumnName,property.sqlColumnType];
        
        if ([property.sqlColumnType isEqualToString:LKSQL_Type_Text]) {
            if (property.length>0) {
                [table_pars appendFormat:@"(%ld)",(long)property.length];
            }
        }
        if (property.isNotNull) {
            [table_pars appendFormat:@" %@ ",LKSQL_Attribute_Unique];
        }
        if (property.checkValue) {
            [table_pars appendFormat:@" %@(%@)",LKSQL_Attribute_Check,property.checkValue];
        }
        if (property.defaultValue) {
            [table_pars appendFormat:@" %@ %@",LKSQL_Attribute_Default,property.defaultValue];
        }
        if (primaryKey&&[property.sqlColumnName isEqualToString:primaryKey]) {
            [table_pars appendFormat:@" %@ ",LKSQL_Attribute_PrimaryKey];
        }
    }
    NSString *createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXI STS %@(%@)",[self getTableName],table_pars];
    return createTableSQL;
}

@end
