//
//  AppDelegate.m
//  HHLinkageViewController
//
//  Created by 豫风 on 2018/10/30.
//  Copyright © 2018年 豫风. All rights reserved.
//

#import "AppDelegate.h"
#import "HHViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[HHViewController new]];
//    nav.navigationBarHidden = YES;//测试nav是否影响
    [nav.navigationBar setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:204/255.0 green:225/255.0 blue:152/255.0 alpha:1.0f]] forBarMetrics:UIBarMetricsDefault];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
