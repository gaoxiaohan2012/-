//
//  MyTabBarViewController.m
//  网易新闻
//
//  Created by xiaohan on 15/10/13.
//  Copyright (c) 2015年 xiaohan. All rights reserved.
//

#import "MyTabBarViewController.h"

@interface MyTabBarViewController ()

@end

@implementation MyTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tabBar.hidden = YES;
    //
//    for (UIView *view in self.tabBar.subviews) {
//        if ([view isKindOfClass:[UIControl class]]) {
//            [view removeFromSuperview];
//        }
//    }
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createButton];
}

- (void)createButton {
    NSArray *itemNameArr = @[@"新闻",@"阅读",@"视听",@"发现",@"我"];
    NSArray *imageArrNormal = @[@"tabbar_icon_news_normal",@"tabbar_icon_reader_normal",@"tabbar_icon_media_normal",@"tabbar_icon_found_normal",@"tabbar_icon_me_normal"];
    NSArray *imageArrSelected = @[@"tabbar_icon_news_highlight",@"tabbar_icon_reader_highlight",@"tabbar_icon_media_highlight",@"tabbar_icon_found_highlight",@"tabbar_icon_me_highlight"];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 49)];
    itemView.backgroundColor = [UIColor whiteColor];
    itemView.userInteractionEnabled = YES;
    for (int i = 0; i < 5; i++) {
        UIButton * button = [[UIButton alloc]init];
        button.frame = CGRectMake(i*(frame.size.width/5), 0, frame.size.width/5, 49);
        [button setImage:[UIImage imageNamed:imageArrNormal[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageArrNormal[i]] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:imageArrSelected[i]] forState:UIControlStateSelected];
        
        button.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, button.frame.size.width, 9)];
        label.text = itemNameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = CFBridgingRelease([UIColor blackColor].CGColor);
        
        [button addSubview:label];
        button.tag = 10 +i;
        //进入tabbar的状态
        NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"SlectedIndex"];
        if (button.tag == index+10) {
            button.selected = YES;
        }
        
        [button addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:button];
    }
    
    //[self.view addSubview:itemView];
    
    //直接加到tabbar上面 ，不需要加到view上。
    [self.tabBar addSubview:itemView];
}
- (void)itemBtnClick:(UIButton *)button {
    for (int i = 0; i<5; i++) {
        UIButton *btn = (id)[self.view viewWithTag:10+i];
        if (btn.tag != button.tag) {
            btn.selected = NO;
        }
    }
    button.selected = YES;
    
    self.selectedIndex = button.tag - 10;

    [[NSUserDefaults standardUserDefaults] setInteger:self.selectedIndex forKey:@"SlectedIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
