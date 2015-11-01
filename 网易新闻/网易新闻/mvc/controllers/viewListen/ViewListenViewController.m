//
//  ViewListenViewController.m
//  网易新闻
//
//  Created by xiaohan on 15/10/13.
//  Copyright (c) 2015年 xiaohan. All rights reserved.
//

#import "ViewListenViewController.h"
#import "SubLisenViewController.h"

#define SIZE self.view.frame.size

#define k_visual @"http://c.3g.163.com/nc/video/home/%d-10.html"
#define k_audio @"http://c.3g.163.com/nc/topicset/android/radio/index.html"
@interface ViewListenViewController ()
{
    NSMutableArray *_labelArr;
    NSMutableArray *_vcArr;
    UIView *_topScrolView;
    UIScrollView *_subScrollView;
    NSArray *_urlStrArr;
}
@end

@implementation ViewListenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _vcArr = [[NSMutableArray alloc]init];
    _labelArr = [[NSMutableArray alloc]init];
    _urlStrArr = @[k_visual,k_audio];
    
    // Do any additional setup after loading the view.
    //导航器设置
    [self createNavigation];
    [self createUI];
    
}
- (void)createNavigation {

    
    UIView *TopView = [[UIView alloc]initWithFrame:CGRectMake(20, 24, 120, 40)];
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(60, 0, 60, 40)];
    button1.tag = 1;
    button2.tag = 2;
    [button1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 50, 20)];
    label1.text = @"视频";
    label1.tag = 3;
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor whiteColor];
    label1.textAlignment = NSTextAlignmentCenter;
    [_labelArr addObject:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 50, 20)];
    label2.text = @"电台";
    label2.tag = 4;
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [UIColor grayColor];
    label2.textAlignment = NSTextAlignmentCenter;
    [_labelArr addObject:label2];
    
    [button1 addSubview:label1];
    [button2 addSubview:label2];
    
    _topScrolView = [[UIView alloc]initWithFrame:CGRectMake(5, 38, 50, 2)];
    _topScrolView.backgroundColor = [UIColor whiteColor];
    
    [TopView addSubview:button1];
    [TopView addSubview:button2];
    [TopView addSubview:_topScrolView];
    
    [self.navigationController.view  addSubview:TopView];
}
#pragma mark -- createUI
- (void)createUI {
    _subScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SIZE.width, SIZE.height)];
    for (int i = 0; i<_urlStrArr.count; i++) {
        SubLisenViewController *svc = [[SubLisenViewController alloc]init];
        svc.view.frame = CGRectMake(0, 0, _subScrollView.frame.size.width, _subScrollView.frame.size.height);
        svc.urlStr = _urlStrArr[i];
        [_vcArr addObject:svc];
        //进入页面就进行刷新
        if (i == 0) {
            [svc reloadData];
        }
        [_subScrollView addSubview:svc.view];
    }
    _subScrollView.contentSize = CGSizeMake(_urlStrArr.count * self.view.frame.size.width, self.view.frame.size.height-64-49);
    
    [self.view addSubview:_subScrollView];
}


#pragma mark -- 头部视图的btn点击事件。
- (void)btnClick:(UIButton *)btn {
    for (int i = 0; i<2; i++) {
        UILabel *label = _labelArr[i];
        if (i != btn.tag - 1) {
            label.textColor = [UIColor grayColor];
        }
    }
    UILabel *lab = _labelArr[btn.tag - 1];
    lab.textColor = [UIColor whiteColor];
    if (btn.tag == 1) {
        SubLisenViewController *svc = _vcArr[0];
        [svc reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            [_topScrolView setFrame:CGRectMake(5, 38, 50, 2)];
            
        }];
    }else {
        SubLisenViewController *svc = _vcArr[1];
        [svc reloadData];
        [UIView animateWithDuration:0.3 animations:^{
            [_topScrolView setFrame:CGRectMake(65, 38, 50, 2)];
        }];
    }
}











@end
