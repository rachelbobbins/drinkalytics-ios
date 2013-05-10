//
//  DrinkAppDelegate.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 4/17/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "DrinkAppDelegate.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "LeaderboardViewController.h"
#import "HTTPController.h"

@implementation DrinkAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //fetch cookies, so that we don't have to authenticate again to the api.
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedCookies"];
    if([cookiesdata length] > 0) {
        NSLog(@"retreiving saved cookies");
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *navController = [[UINavigationController alloc]init];
    
    //if user has no cookies, they log in. login view controller deals w/ logic of presenting proper view.
    LoginViewController *loginView = [[LoginViewController alloc] init];
    loginView.navigationItem.hidesBackButton = YES;
    [navController pushViewController:loginView animated:NO];
    
    if ([[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] count] > 0) {
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"userIsSenior"]) { //prepare leaderboard for underclassmen
            LeaderboardViewController *lvc = [[LeaderboardViewController alloc] init];
            [navController pushViewController:lvc animated:YES];
        } else { //prepare regular home screen for seniors
            RootViewController *mainController = [[RootViewController alloc] init];
            [navController pushViewController:mainController animated:NO];
        }
    }
    
    
    self.window.rootViewController = navController;
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
    // Saves changes in the application's managed object context before the application terminates.
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
