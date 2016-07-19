//
//  DBManager.h
//  User_封装
//
//  Created by imac on 15/10/14.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface DBManager : NSObject

+ (instancetype)shareManager;

// 创建NSManagedObject
- (id)createMO:(NSString *)entityName;

// 保存
- (void)save:(NSManagedObject *)mo;

// 查询
- (NSArray *)query:(NSString *)entityName predicate:(NSPredicate *)predicate;

// 修改
- (void)update:(NSManagedObject *)mo;

// 删除
- (void)remove:(NSManagedObject *)mo;

@end
