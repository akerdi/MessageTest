//
//  XXBaseDB.h
//  XXT
//
//  Created by aKerdi on 2017/6/3.
//  Copyright © 2017年 xxtstudio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LKDBHelper.h"

@interface XXBaseDB : NSObject

@end

@interface NSObject(PrintSQL)
+ (NSString *)getCreateTableSQL;
@end
