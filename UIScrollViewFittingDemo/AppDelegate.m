//
//  AppDelegate.m
//  UIScrollViewFittingDemo
//
//  Created by Levison on 2.12.24.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <UIKit/UIKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    MainViewController *mainController = [[MainViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainController];
    nav.navigationBar.translucent = NO;
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    return YES;
}



@end
