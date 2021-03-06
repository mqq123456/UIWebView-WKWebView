//
//  WBWebViewController.m
//  WKWebView+WBWebViewConsole
//
//  Created by 吴天 on 2/13/15.
//
//  Copyright (c) 2014-present, Weibo, Corp.
//  All rights reserved.
//
//  This source code is licensed under the BSD-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "WBWebViewController.h"
#import "WBWKWebView.h"
#import "WBWebViewConsole.h"
#import "WBWebDebugConsoleViewController.h"
#import <Foundation/Foundation.h>
#import "WBWebViewUserScript.h"
#import "WBWebViewJSBridge.h"
#import "WBUITestWebViewController.h"
@interface WBWebViewController ()

@property (nonatomic, strong) WBWKWebView * webView;

@end

@implementation WBWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"WKWebView";
    
    self.webView = [[WBWKWebView alloc] initWithFrame:self.view.bounds];
    self.webView.JSBridge.interfaceName = @"WKWebViewBridge";
    self.webView.JSBridge.readyEventName = @"WKWebViewBridgeReady";
    self.webView.JSBridge.invokeScheme = @"wkwebview-bridge://invoke";
    
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://apple.com"]]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Console" style:UIBarButtonItemStylePlain target:self action:@selector(showConsole:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"UIWebView" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
}
- (void)leftBtnClick {
    WBUITestWebViewController *controller = [[WBUITestWebViewController
                                              alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self webDebugAddContextMenuItems];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self webDebugRemoveContextMenuItems];
}

- (void)showConsole:(id)sender
{
    WBWebDebugConsoleViewController * controller = [[WBWebDebugConsoleViewController alloc] initWithConsole:_webView.console];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)webDebugAddContextMenuItems
{
    UIMenuItem * item = [[UIMenuItem alloc] initWithTitle:@"Inspect Element" action:@selector(webDebugInspectCurrentSelectedElement:)];
    [[UIMenuController sharedMenuController] setMenuItems:@[item]];
}

- (void)webDebugRemoveContextMenuItems
{
    [[UIMenuController sharedMenuController] setMenuItems:nil];
}

- (void)webDebugInspectCurrentSelectedElement:(id)sender
{
    NSString * variable = @"WeiboConsoleLastSelection";
    
    [self.webView.console storeCurrentSelectedElementToJavaScriptVariable:variable completion:^(BOOL success) {
        if (success)
        {
            WBWebDebugConsoleViewController * consoleViewController = [[WBWebDebugConsoleViewController alloc] initWithConsole:self.webView.console];
            consoleViewController.initialCommand = variable;
            
            [self.navigationController pushViewController:consoleViewController animated:YES];
        }
        else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Can not get current selected element" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }];
}

@end
