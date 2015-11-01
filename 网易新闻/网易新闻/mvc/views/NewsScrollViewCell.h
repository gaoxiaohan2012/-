//
//  NewsScrollViewCell.h
//  网易新闻
//
//  Created by MS on 15/10/16.
//  Copyright (c) 2015年 xiaohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "newsAdModel.h"

@interface NewsScrollViewCell : UITableViewCell<SDCycleScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *urlArr;
@property (nonatomic,strong) NSMutableArray *titleArr;

- (void)setAdsModel:(NSArray *)modelArr;


@end
