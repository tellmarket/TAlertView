//
//  TAppDelegate.m
//  TAlertView
//
//  Created by CocoaPods on 11/25/2014.
//  Copyright (c) 2014 Washington. All rights reserved.
//

#import "TAppDelegate.h"
#import "TAlertView.h"

@implementation TAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TAlertView appearance].alertBackgroundColor= [[UIColor yellowColor] colorWithAlphaComponent:0.6];
    [TAlertView appearance].titleFont           = [UIFont fontWithName:@"Arial" size:18];
    [TAlertView appearance].messageColor        = [UIColor whiteColor];
    [TAlertView appearance].messageFont         = [UIFont fontWithName:@"Arial" size:18];
    [TAlertView appearance].buttonsTextColor    = [UIColor whiteColor];
    [TAlertView appearance].buttonsFont         = [UIFont fontWithName:@"Arial" size:18];
    [TAlertView appearance].separatorsLinesColor= [UIColor redColor];
    [[TAlertView appearance] setTitleColor:[UIColor brownColor] forAlertViewStyle:TAlertViewStyleInformation];
    [[TAlertView appearance] setDefaultTitle:@"Info" forAlertViewStyle:TAlertViewStyleInformation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[[TAlertView alloc] initWithTitle:nil
                                   message:@"message"
                                   buttons:@[@"1", @"2"]
                               andCallBack:^(TAlertView *alertView, NSInteger buttonIndex) {
                                   
                               }] show];
    });
    
    // Override point for customization after application launch.
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
