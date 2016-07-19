//
//  DBManager.m
//  User_封装
//
//  Created by imac on 15/10/14.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager
{
    NSManagedObjectContext *managedContext;
}
+ (instancetype)shareManager{
    static DBManager *instance = nil;
    static dispatch_once_t once = 0;
    dispatch_once(&once, ^{
        instance = [[[self class]alloc]init];
        [instance openDB];
    });
    return instance;
}

- (void)openDB{
    // 加载数据模型路径
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Data.momd" withExtension:nil];
    // 创建数据模型对象
    NSManagedObjectModel *managedModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:managedModel];
    
    // 定义数据库文件的路径
    NSURL *dbURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingString:@"/Documents/coreData.sqlite"]];
    
    /*
        addPersistentStoreWithType
        打开数据库文件，如果存在，则打开准备使用
        打开数据库文件，如果不存在，则创建文件
     */
    NSError *error = nil;
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:nil error:&error];
    if(error == nil){
        NSLog(@"打开数据库文件成功");
    }else{
        NSLog(@"打开数据库文件失败 %@", error);
    }
    managedContext = [[NSManagedObjectContext alloc] init];
    managedContext.persistentStoreCoordinator = store;
}

- (id)createMO:(NSString *)entityName{
    NSManagedObject *managedObject =  [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedContext];
    return managedObject;
}

- (void)save:(NSManagedObject *)mo{
    // 添加到上下文容器
    [managedContext insertObject:mo];
    NSError *error = nil;
    if([managedContext save:&error]){
        NSLog(@"数据保存成功");
    }else{
        NSLog(@"数据保存失败 %@", error);
    }
}

- (NSArray *)query:(NSString *)entityName predicate:(NSPredicate *)predicate{
    if(entityName.length == 0){
        return nil;
    }
    // 关联查询条件
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.predicate = predicate;
    
    return [managedContext executeFetchRequest:request error:nil];
}

- (void)update:(NSManagedObject *)mo{
    NSError *error = nil;
    if([managedContext save:nil]){
        NSLog(@"修改成功");
    }else{
        NSLog(@"修改失败 %@", error);
    }
}

- (void)remove:(NSManagedObject *)mo{
    if(mo == nil){
        return;
    }
    [managedContext deleteObject:mo];
    NSError *error = nil;
    if([managedContext save:&error]){
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败 %@", error);
    }
}

@end
