//
//  SubLisenViewController.h
//  网易新闻
//
//  Created by MS on 15/10/19.
//  Copyright (c) 2015年 xiaohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubLisenViewController : UIViewController

@property (nonatomic,copy) NSString *urlStr;

- (void)reloadData;
@end
