//
//  BaseViewController.m
//  网易新闻
//
//  Created by xiaohan on 15/10/13.
//  Copyright (c) 2015年 xiaohan. All rights reserved.
//

#import "BaseViewController.h"
#define COLORVALUE arc4random_uniform(256)/255.0f
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNeedsStatusBarAppearanceUpdate];

//    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
//    imgView.image = [UIImage imageNamed:@"account_logout_button"];
//    [self.navigationController.navigationBar insertSubview:imgView atIndex:1];
    
//    [self.navigationController.navigationBar addSubview:imgView];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_navigation_background"]];
//    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
