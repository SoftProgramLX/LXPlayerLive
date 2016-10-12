//
//  LXTabBarController.m
//  LXLiveDemo
//
//  Created by 李旭 on 16/10/12.
//  Copyright © 2016年 lixu. All rights reserved.
//

#import "LXTabBarController.h"
#import "LXPlayerController.h"
#import "LXLiveController.h"

@interface LXTabBarController ()

@end

@implementation LXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = bgColor;
    
    [self addOneChlildVc:[[LXPlayerController alloc] init] title:@"播放" navigationTitle:@"播放" imageName:nil selectedImageName:nil];
    
    [self addOneChlildVc:[[LXLiveController alloc] init] title:@"直播" navigationTitle:@"直播" imageName:nil selectedImageName:nil];
    
    //    self.tabBar.backgroundImage = [UIImage imageNamed:@""];
    self.tabBar.translucent = NO;
}

- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title navigationTitle:(NSString *)navTitle imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.title = title;
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = globalRedColor;
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    childVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    nav.navigationItem.title = navTitle;
    
    [self addChildViewController:nav];
}

@end
