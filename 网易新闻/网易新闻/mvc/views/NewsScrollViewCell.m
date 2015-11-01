//
//  NewsScrollViewCell.m
//  网易新闻
//
//  Created by MS on 15/10/16.
//  Copyright (c) 2015年 xiaohan. All rights reserved.
//

#import "NewsScrollViewCell.h"


@implementation NewsScrollViewCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.urlArr = [[NSMutableArray alloc]init];
        self.titleArr = [[NSMutableArray alloc]init];
    }
    return  self;
}
- (void)setAdsModel:(NSArray *)modelArr {
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (_urlArr.count == 0) {
        for (newsAdModel *model in modelArr) {
            [self.urlArr addObject:model.imgsrc];
            [self.titleArr addObject:model.title];
        }
    }
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 220) imageURLStringsGroup:_urlArr];
    scrollView.delegate = self;
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    scrollView.dotColor = [UIColor lightGrayColor];
    scrollView.placeholderImage = [UIImage imageNamed:@"contentview_image_default"];
    
    scrollView.titlesGroup = _titleArr;
    scrollView.titleLabelTextFont = [UIFont systemFontOfSize:13];
    scrollView.autoScrollTimeInterval = 4;
    [self.contentView addSubview:scrollView];
}




//点击头部的图片代理事件
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了top第%ld张图片",(long)index);
}



@end
