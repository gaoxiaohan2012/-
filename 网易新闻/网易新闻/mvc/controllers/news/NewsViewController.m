//
//  NewsViewController.m
//  网易新闻
//
//  Created by MS on 15/10/14.
//  Copyright (c) 2015年 xiaohan. All rights reserved.
//

#import "NewsViewController.h"
#import "SubNewsController.h"

#define k_news @"http://c.m.163.com/nc/article/list/%@/0-%d.html"

@interface NewsViewController ()<UIScrollViewDelegate>
{
    UIImageView *_redView;
    UIScrollView *_TopScrollView;
    UIScrollView *_contentScrollView;
    NSMutableArray *_labelArr;
    NSMutableArray *_newsVcArr;
}



@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = self.view.bounds;
    _labelArr = [[NSMutableArray alloc]init];
    _newsVcArr = [[NSMutableArray alloc]init];
    
    _TopScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, frame.size.width, 40)];
    _TopScrollView.pagingEnabled = YES;
    _TopScrollView.showsHorizontalScrollIndicator = NO;
    _TopScrollView.userInteractionEnabled = YES;
    _TopScrollView.delegate = self;
    
    
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, frame.size.width, frame.size.height-49-40-64)];
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
//    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.contentInset = UIEdgeInsetsZero;
    _contentScrollView.userInteractionEnabled = YES;
    
    [self.view addSubview:_contentScrollView];
    [self.view addSubview:_TopScrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createNavigationBar];
    [self createUI];
}
#pragma  mark -- 定制导航条
- (void)createNavigationBar {
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [leftButton setImage:[UIImage imageNamed:@"night_contentview_loading_background"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button1 setImage:[UIImage imageNamed:@"top_navi_bell_normal"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(firstItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *secondItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button2 setImage:[UIImage imageNamed:@"top_navigation_more"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(secondItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *firstItem = [[UIBarButtonItem alloc]initWithCustomView:button2];
    self.navigationItem.rightBarButtonItems = @[firstItem,secondItem];
}
- (void)firstItemClick {
    NSLog(@"第一个item");
}
- (void)secondItemClick {
    NSLog(@"第二个item");
}

- (void)leftBarButtonItemClick {
    
}

#pragma mark -- UI界面
- (void)createUI {
    NSArray *nameArr = @[@"头条",@"娱乐",@"体育",@"财经",@"科技",@"轻松一刻",@"时尚",@"军事",@"历史",@"彩票",@"原创",@"画报",@"游戏",@"政务"];
    for (int i = 0; i < nameArr.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*50, 0, 50, 40)];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*50, 0, 50, 40-5)];
        label.text = nameArr[i];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.adjustsFontSizeToFitWidth = YES;
        label.userInteractionEnabled = YES;
        label.tag = 150+i;
        [_labelArr addObject:label];
        if (i == 0) {
            _redView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
            _redView.image = [UIImage imageNamed:@"account_logout_button"];
            [_TopScrollView addSubview:_redView];
        }
        [_TopScrollView addSubview:label];
        [_TopScrollView addSubview:button];
        
        CGRect frame = _contentScrollView.frame;
        SubNewsController *svc = [[SubNewsController alloc]init];
        svc.view.frame = CGRectMake(i*frame.size.width, 0, frame.size.width, frame.size.height);
        if (i == 0) {
            svc.urlType = @"T1348647853363";
            svc.urlStr = k_news;
            [svc reloadDataArray];
        }
        
        //用来退出详情页
        svc.showDerailView = ^(UIViewController *vc){
            [self.navigationController pushViewController:vc animated:YES];
        };
        [_newsVcArr addObject:svc];
        [_contentScrollView addSubview:svc.view];
        
    }
    _contentScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*nameArr.count, self.view.frame.size.height-40-64-49);
    _TopScrollView.contentSize = CGSizeMake(50*nameArr.count, 40);
}

- (void)buttonClick:(UIButton *)button {
    UILabel * selectedLabel = (id)[self.view viewWithTag:button.tag+150-100];
    for (UILabel *label2 in _labelArr) {
        if (label2 != selectedLabel) {
            label2.textColor = [UIColor blackColor];
        }
    }
    NSArray *arr = @[@"T1348647853363",@"T1348648517839",@"T1348649079062",@"T1348648756099",@"T1348649580692",@"T1350383429665",@"T1348650593803",@"T1348648141035",@"T1368497029546",@"T1356600029035",@"T1370583240249",@"T1422935072191",@"T1348654151579",@"T1414142214384"];
    NSInteger index = button.tag - 100;
    SubNewsController *svc = _newsVcArr[index];
    svc.urlType = arr[index];
    svc.urlStr = k_news;
    [svc reloadDataArray];
    
    
    
    selectedLabel.textColor = [UIColor redColor];
    CGFloat offset = (button.tag-100)*50;
    CGPoint offsetPoint = _TopScrollView.contentOffset;
    [UIView animateWithDuration:0.3 animations:^{
        if (offsetPoint.x == 0) {
            [_redView setFrame:CGRectMake(offset, 0, 50, 40)];
        }else {
            [_redView setFrame:CGRectMake(offset, 0, 50, 40)];
            [_TopScrollView scrollRectToVisible:CGRectMake(offset, 0, 50, 40) animated:YES];
            
        }
        //大的scrollView的移动
        CGFloat contentOffSet = (selectedLabel.tag-150)*self.view.frame.size.width;
        _contentScrollView.contentOffset = CGPointMake(contentOffSet, 0);
    }];
    
}

#pragma mark -- scrollviewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //contentView的位移
    CGFloat index = _contentScrollView.contentOffset.x/self.view.frame.size.width;

    if (scrollView == _contentScrollView) {
        _TopScrollView.contentOffset = CGPointMake(index * 50 - 100, 0);
        UILabel *selectLabel = (id)[self.view viewWithTag:index+150];
        for (UILabel *label in _labelArr) {
            if (label != selectLabel) {
                label.textColor = [UIColor blackColor];
            }
        }
        selectLabel.textColor = [UIColor redColor];
        [UIView animateWithDuration:0.3 animations:^{
            [_redView setFrame:CGRectMake(index * 50, 0, 50, 40)];
        }];
    }
    
    NSArray *arr = @[@"T1348647853363",@"T1348648517839",@"T1348649079062",@"T1348648756099",@"T1348649580692",@"T1350383429665",@"T1348650593803",@"T1348648141035",@"T1368497029546",@"T1356600029035",@"T1370583240249",@"T1422935072191",@"T1348654151579",@"T1414142214384"];

    NSInteger indexVc = (NSInteger)index;
    SubNewsController *svc = _newsVcArr[indexVc];
    svc.urlType = arr[indexVc];
    svc.urlStr = k_news;
    [svc reloadDataArray];
}



@end
