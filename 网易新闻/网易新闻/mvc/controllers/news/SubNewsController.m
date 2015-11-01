//
//  SubNewsController.m
//  网易新闻
//
//  Created by MS on 15/10/15.
//  Copyright (c) 2015年 xiaohan. All rights reserved.
//

#import "SubNewsController.h"
#import "MJRefresh.h"
#import "KVNProgress.h"
#import "HLManager.h"
#import "NewsModel.h"
#import "newsAdModel.h"
#import "NewsScrollViewCell.h"
#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "OneScrollViewCell.h"
#import "NoneScrollViewCell.h"
#import "newsImageModel.h"
#import "MoreImgViewCell.h"
#import "DetailWebViewController.h"

@interface SubNewsController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    BOOL _isRefresh;
    NSString *_urlString;
    NSMutableArray *_dataArr;
    int _countUrl;
    
}
@end

@implementation SubNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;

    
}
- (instancetype)init {
#define VALUE arc4random_uniform(256)/255.0f
    self = [super init];
    if (self) {
        //self.view.backgroundColor = [UIColor colorWithRed:VALUE green:VALUE blue:VALUE alpha:1];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
        _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh)];
        
        
        _tableView.footer.hidden = YES;
        _countUrl = 30;
        [self.view addSubview:_tableView];
    }
    return self;
}

#pragma mark -- 开始准备请求数据
- (void)reloadDataArray {
    if (_isRefresh == NO) {
        //首页不需要刷新header
//        if (![_urlType isEqualToString:@"T1348647853363"]) {
//            [_tableView.header beginRefreshing];
//        }
        [self downRefresh];//下拉刷新
        _isRefresh = YES;
    }
}

#pragma mark -- 请求网络数据结果解析
- (void)hlConnection:(HLConnection *)hc {
    if (hc.isSuccess) {
        if (hc.tag == 1) {
            _countUrl = 30;
            [_tableView.header endRefreshing];
            [self jsonDownloadData:hc];
            _tableView.footer.hidden = NO;//刷新完后，，显示footer视图

            //下拉。。
        }else {
            _countUrl += 30;
            [_dataArr removeAllObjects];
            [self jsonDownloadData:hc];
            [_tableView.footer endRefreshing];
            //..上拉
        }
    }else {
        NSLog(@"网络请求失败");
    }
    
}
#pragma mark -- json 解析
- (void)jsonDownloadData:(HLConnection *)hc {
    _dataArr = [[NSMutableArray alloc]init];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:hc.downloadData options:0 error:nil];
    if (dict) {
        for (NSDictionary *appDic in [dict objectForKey:_urlType]) {
            NewsModel *model = [[NewsModel alloc]init];
            [model setValuesForKeysWithDictionary:appDic];
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            for (NSDictionary * adsDit in [appDic objectForKey:@"ads"]) {
                newsAdModel *adModel = [[newsAdModel alloc]init];
                [adModel setValuesForKeysWithDictionary:adsDit];
                [arr addObject:adModel];
            }
            
            NSMutableArray *imgArr = [[NSMutableArray alloc]init];
            if ([appDic objectForKey:@"imgextra"]) {
                for (NSDictionary *imageDic in [appDic objectForKey:@"imgextra"]) {
                    newsImageModel *nm = [[newsImageModel alloc]init];
                    [nm setValuesForKeysWithDictionary:imageDic];
                    [imgArr addObject:nm];
                }
                model.imgextraArr = imgArr;
            }
            model.adsArray = arr;
            [_dataArr addObject:model];
        }
        [_tableView reloadData];
    }
    
}


#pragma mark -- 上拉下拉刷新
- (void)downRefresh {
    _urlString = [NSString stringWithFormat:_urlStr,_urlType,_countUrl];
    [[HLManager defaultManager] startConnectionWithUrlStr:_urlString target:self action:@selector(hlConnection:) tag:1];
}
- (void)upRefresh {
    _urlString = [NSString stringWithFormat:_urlStr,_urlType,_countUrl];
    [[HLManager defaultManager] startConnectionWithUrlStr:_urlString target:self action:@selector(hlConnection:) tag:2];
}
#pragma mark -- tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NewsModel *model = [_dataArr objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        return 220;
    }
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsModel *model = [_dataArr objectAtIndex:indexPath.row];
    
    //首页，top
    if (model.adsArray.count == 1) {
        OneScrollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneScrollViewCell"];
        if (cell == nil) {
            cell = [[OneScrollViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OneScrollViewCell"];
        }
        [cell setAdsModel:model];
        return cell;
    }
    
    //头部图片大于2时候
    if ( model.adsArray.count > 1) {
        
        NewsScrollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsScrollViewCell"];
        if (cell== nil) {
            cell = [[NewsScrollViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewsScrollViewCell"];
            [cell setAdsModel:model.adsArray];
        }
        return cell;
    }
    //没有头部图片的时候
    if (model.adsArray.count == 0 && indexPath.row==0) {
        NoneScrollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneScrollViewCell"];
        if (!cell) {
            cell = [[NoneScrollViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NoneScrollViewCell"];
        }
        [cell setAdsModel:model];
        return cell;
    }
    
    //cell 中有三张图片的时候。
    if (model.imgextraArr && model.imgextraArr.count == 2) {
        MoreImgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreImgViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreImgViewCell" owner:nil options:0]lastObject];
        }
        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc]];
        [cell.iconView2 sd_setImageWithURL:[NSURL URLWithString:[model.imgextraArr[0] imgsrc]]];
        [cell.iconView3 sd_setImageWithURL:[NSURL URLWithString:[model.imgextraArr[1] imgsrc]]];
        cell.titltLabel.text = model.title;
        //回复数量为nsnumber类型数据
        cell.replyCountLabel.text = [NSString stringWithFormat:@"跟帖:%@", model.replyCount];
        return cell;
    }
    
    
    
    
    
    
    
    
    
    
    //默认情况下的cell
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableViewCell"];
    if (cell == nil) {
//        cell = [[NewsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewsTableViewCell"];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsTableViewCell" owner:nil options:0]lastObject];
    }

    cell.typeLabel.text = model.source;
    cell.contentLabel.text = model.digest;
    cell.titleLabel.text = model.title;
    cell.timeLabel.text =  [NSString stringWithFormat:@"%@  跟帖:%@",model.ptime,model.replyCount];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc]];
    
    return cell;
}

//点击cell事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsModel *model = [_dataArr objectAtIndex:indexPath.row];
    DetailWebViewController *dvc = [[DetailWebViewController alloc]init];
    dvc.url = model.url;
    dvc.hidesBottomBarWhenPushed = YES;
        
    //退出详情页,赋值直接便推出
    _showDerailView(dvc);
    
}












//干掉网络请求
- (void)viewWillDisappear:(BOOL)animated {
    [[HLManager defaultManager] stopAllConnetionForTarget:self];

}














@end
