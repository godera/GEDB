//
//  GEAppDelegate.m
//  GEDB
//
//  Created by Dawn on 2014/4/1.
//  Copyright (c) 2014年 god. All rights reserved.
//

#import "GEAppDelegate.h"
#import "GEDB/GEDB.h"
#import "SQLEntity.h"

@implementation GEAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
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
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
