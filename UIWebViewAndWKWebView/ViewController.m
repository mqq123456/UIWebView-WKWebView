//
//  ViewController.m
//  UIWebViewAndWKWebView
//
//  Created by HeQin on 16/8/26.
//  Copyright © 2016年 HeQin. All rights reserved.
//

#import "ViewController.h"
#import "WKUIWebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    WKUIWebViewController *webView =  [[WKUIWebViewController alloc] init];
    webView.url = @"http://www.baidu.com";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webView];
   
    [self presentViewController:nav animated:YES completion:nil];
}
@end
