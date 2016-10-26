//
//  WKUIWebViewController.m
//  UIWebViewAndWKWebView
//
//  Created by HeQin on 16/8/26.
//  Copyright © 2016年 HeQin. All rights reserved.
//

#import "WKUIWebViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@interface WKUIWebViewController ()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate,UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *wkwebView;

@end

@implementation WKUIWebViewController
- (instancetype)initWithWebView:(BOOL)ios8 {
    self = [super init];
    if (self) {
        if (ios8) {
            [self.view addSubview:self.wkwebView];
        }else{
            [self.view addSubview:self.webView];
        }
    }
    return self;
}
- (WKWebView *)wkwebView {
    if (!_wkwebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];
        // 注入JS对象Native，
        // 声明WKScriptMessageHandler 协议
        [config.userContentController addScriptMessageHandler:self name:@"Native"];
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
 
        
        
        _wkwebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
        _wkwebView.UIDelegate = self;
        _wkwebView.navigationDelegate = self;
        [_wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
//        // 监听支持KVO的属性
//        [_wkwebView addObserver:self forKeyPath:@"loading" options:NSKeyValueObservingOptionNew context:nil];
//        [_wkwebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
//        [_wkwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//#warning men OC调JS
//         NSString *js = @"callJsAlert()";
//        [_wkwebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//            NSLog(@"response: %@ error: %@", response, error);
//            NSLog(@"call js alert by native");
//        }];
    }
    return _wkwebView;
}
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IOS8) {
        [self.view addSubview:self.wkwebView];
    }else{
        [self.view addSubview:self.webView];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading");
    } else if ([keyPath isEqualToString:@"title"]) {
        self.title = _wkwebView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%f",_wkwebView.estimatedProgress);
        
    }
}
#pragma mark - WKNavigationDelegate

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@",[error description]);
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"%s", __FUNCTION__);
}
//
///**
// *  在收到响应后，决定是否跳转
// *
// *  @param webView            实现该代理的webview
// *  @param navigationResponse 当前navigation
// *  @param decisionHandler    是否跳转block
// */
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
//    
//    // 如果响应的地址是百度，则允许跳转
//    if ([navigationResponse.response.URL.host.lowercaseString isEqual:@"baidu.com"]) {
//    
//        // 允许跳转
//        decisionHandler(WKNavigationResponsePolicyAllow);
//        return;
//    }
//    // 不允许跳转
//    decisionHandler(WKNavigationResponsePolicyCancel);
//}
//
///**
// *  在发送请求之前，决定是否跳转
// *
// *  @param webView          实现该代理的webview
// *  @param navigationAction 当前navigation
// *  @param decisionHandler  是否调转block
// */
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
//    
//    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
//    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
//        && ![hostname containsString:@"baidu.com"]) {
//        // 对于跨域，需要手动跳转
//        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
//        
//        // 不允许web内跳转
//        decisionHandler(WKNavigationActionPolicyCancel);
//    } else {
//
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//}
#pragma mark - WKUIDelegate

/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil] show];
    
    completionHandler(YES);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    
    
}

// 从web界面中接收到一个脚本时调用
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"Native"]) {
        NSLog(@"message.body:%@", message.body);
        //如果是自己定义的协议, 再截取协议中的方法和参数, 判断无误后在这里手动调用oc方法
        NSMutableDictionary *param = [self queryStringToDictionary:message.body];
        NSLog(@"get param:%@",[param description]);
        
        NSString *func = [param objectForKey:@"func"];
        
        //调用本地函数
        if([func isEqualToString:@"alert"])
        {
            
        }
        
    }

    NSLog(@"%@", message);
}

- (void)wkWebViewToJS {
    NSString *tempString = [NSString stringWithFormat:@"document.getElementsByName('wd')[0].value='10';"];
    [self.wkwebView evaluateJavaScript:tempString  completionHandler:^(id item, NSError * _Nullable error) {
        
    }];
}
- (NSMutableDictionary*)queryStringToDictionary:(NSString*)string {
    NSMutableArray *elements = (NSMutableArray*)[string componentsSeparatedByString:@"&"];
    NSMutableDictionary *retval = [NSMutableDictionary dictionaryWithCapacity:[elements count]];
    for(NSString *e in elements) {
        NSArray *pair = [e componentsSeparatedByString:@"="];
        [retval setObject:[pair objectAtIndex:1] forKey:[pair objectAtIndex:0]];
    }
    return retval;
}


#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{ //父类一些通用的注入标准
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context.exceptionHandler=^(JSContext *con, JSValue *exception) {
        con.exception = exception;
    };
    [context evaluateScript:@"var cmccmap = {};"];
    //注意以下context[@"方法名"]中,方法名字不能直接是-不能是cmccmap.ClientCmccMap这种的,否则js调用cmccmap.ClientCmccMap时调不到
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"HtmlCmccMap();"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
