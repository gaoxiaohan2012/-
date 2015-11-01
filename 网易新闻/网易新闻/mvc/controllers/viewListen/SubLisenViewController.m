//
//  SubLisenViewController.m
//  网易新闻
//
//  Created by MS on 15/10/19.
//  Copyright (c) 2015年 xiaohan. All rights reserved.
//

#import "SubLisenViewController.h"
#import "MJRefresh.h"
#import "HLManager.h"
#import "VisualModel.h"

@interface SubLisenViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    int _count;
    BOOL _isRefreshLoad;
    NSMutableArray *_topImgArr;
}
@end

@implementation SubLisenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataArr = [[NSMutableArray alloc]init];
    _topImgArr = [[NSMutableArray alloc]init];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- 64-49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upRefresh)];
        
        _tableView.footer = footer;
        _tableView.header = header;
        _count = 10;
        
        _tableView.footer.hidden = YES;
        [self.view addSubview:_tableView];
        
    }
    return self;
}
#pragma mark -- reloadData进入页面
- (void)reloadData {
    if (_isRefreshLoad) {
        
        
    }else {
        [_tableView.header beginRefreshing];
        [self downRefresh];
        _isRefreshLoad = YES;
    }
}
#pragma mark -- 下拉，上啦
- (void)downRefresh {
       [[HLManager defaultManager] startConnectionWithUrlStr:[NSString stringWithFormat:_urlStr,_count] target:self action:@selector(hlConnection:) tag:1];
}
- (void)upRefresh {
       [[HLManager defaultManager] startConnectionWithUrlStr:[NSString stringWithFormat:_urlStr,_count] target:self action:@selector(hlConnection:) tag:2];
}

#pragma mark -- 解析
- (void)hlConnection:(HLConnection *)hc {
    if (hc.isSuccess) {
       // [_tableView.header endRefreshing];
        if (hc.tag == 1) {
            _count = 10;
            [self jsonData:hc];
        }else {
            _count += 10;
            [_dataArr removeAllObjects];
            [self jsonData:hc];
        }
        
        
    }else {
        NSLog(@"网络请求失败");
    }
}

#pragma mark -- 解析
- (void)jsonData:(HLConnection *)hc {
    NSDictionary *Dict = [NSJSONSerialization JSONObjectWithData:hc.downloadData options:0 error:nil];

    if (Dict) {
        for (NSDictionary *videoDic in [Dict objectForKey:@"videoList"]) {
            VisualModel *model = [[VisualModel alloc]init];
            [model setValuesForKeysWithDictionary:videoDic];
            [_dataArr addObject:model];
            //NSLog(@"=============%@",model.title);
            //顶部图片数据
        }
        //NSLog(@"%zd",_dataArr.count);
        [_tableView reloadData];
        [_tableView.header endRefreshing];
    }

}

#pragma mark -- tableviewdelefate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArr count];
//    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moren"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"moren"];
    }
    VisualModel *model = [_dataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.title;
    NSLog(@"++++++++%@",model.title);
//    cell.detailTextLabel.text = @"fanwogneowi";
//    cell.textLabel.text = @"fwafweafewf";
    
    return cell;
}







@end
