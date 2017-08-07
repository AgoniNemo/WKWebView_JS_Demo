//
//  ViewController.m
//  WKWebView_JS_Demo
//
//  Created by Mjwon on 2017/8/7.
//  Copyright © 2017年 Nemo. All rights reserved.
//

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN [UIScreen mainScreen].bounds

#import "ViewController.h"
#import "WeakScriptMessageDelegate.h"

@interface ViewController ()<UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic ,strong) WKWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    NSString *sendToken = [NSString stringWithFormat:@"localStorage.setItem(\"accessToken\",'%@');",@"74851c23358c"];
    
    //WKUserScriptInjectionTimeAtDocumentStart：js加载前执行。
    //WKUserScriptInjectionTimeAtDocumentEnd：js加载后执行。
    //下面的injectionTime配置不要写错了
    //forMainFrameOnly:NO(全局窗口)，yes（只限主窗口）
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:sendToken injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    
    //配置js(这个很重要，不配置的话，下面注入的js是不起作用的)
    //WeakScriptMessageDelegate这个类是用来避免循环引用的
    [config.userContentController addScriptMessageHandler:[[WeakScriptMessageDelegate alloc] initWithDelegate:self] name:@"iOS"];
    //注入js
    [config.userContentController addUserScript:wkUScript];
    
    _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) configuration:config];
    
    _webview.UIDelegate = self;
    _webview.navigationDelegate = self;
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"WKWebView" ofType:@"html"];
    NSURL *rul = [NSURL fileURLWithPath:htmlPath];
    [_webview loadRequest:[NSURLRequest requestWithURL:rul]];
    
    _webview.allowsBackForwardNavigationGestures = true;
    [self.view addSubview:_webview];

    
}

#pragma mark WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    NSLog(@"提示信息：%@", message);   //js的alert框的message
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark- WKNavigationDelegate

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    
}

//开始
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%s",__func__);
    
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    NSLog(@"%s",__func__);
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSLog(@"%s",__func__);
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    NSLog(@"%s",__func__);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
