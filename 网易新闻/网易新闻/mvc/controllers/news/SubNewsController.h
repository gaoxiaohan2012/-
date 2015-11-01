//
//  SubNewsController.h
//  网易新闻
//
//  Created by MS on 15/10/15.
//  Copyright (c) 2015年 xiaohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubNewsController : UIViewController

@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,copy) NSString *urlType;

@property (nonatomic,assign) SEL action;
@property (nonatomic,assign) id target;
//用来退出详情页
@property (nonatomic,copy) void(^showDerailView)(UIViewController *);

- (void)reloadDataArray;

@end
