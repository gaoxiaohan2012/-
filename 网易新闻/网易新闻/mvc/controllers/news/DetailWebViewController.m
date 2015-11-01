//
//  DetailWebViewController.m
//  网易新闻
//
//  Created by MS on 15/10/16.
//  Copyright (c) 2015年 xiaohan. All rights reserved.
//

#import "DetailWebViewController.h"
#define k_size [UIScreen mainScreen].bounds.size

@interface DetailWebViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation DetailWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    for (UIView *view in self.navigationController.navigationBar.subviews) {
//        [view removeFromSuperview];
//    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_navigation_background"]];
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate =self;
    _webView.scalesPageToFit = YES;

    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    [_webView reload];
}


#pragma mark -- webViewdelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}



@end
