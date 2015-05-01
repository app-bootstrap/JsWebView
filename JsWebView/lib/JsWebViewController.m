//
//  JsWebViewController.m
//  JsWebView
//
//  Created by xdf on 4/29/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import "JsWebViewController.h"

@interface JsWebViewController () <UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation JsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initNavagationBar {
    self.navigationItem.title = @"loading...";
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
}

- (void)setNavagationBar {
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    self.navigationItem.title = title;
}

- (void)initView {
    [self initNavagationBar];
    [self initWebview];
}

- (void)initWebview {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.webView setScalesPageToFit: YES];
    self.webView.delegate = self;
    [self preventWebviewScroll];
    [self.view addSubview: self.webView];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString: self.url]];
    [self.webView loadRequest:request];
}

- (void)preventWebviewScroll {
    self.webView.scrollView.bounces = NO;
    UIScrollView *scollview = (UIScrollView *)[[self.webView subviews]objectAtIndex:0];
    scollview.bounces = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - webview delegate method

- (void)webViewDidStartLoad:(UIWebView *)webView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.2];
    [self.view addSubview:view];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.activityIndicator setCenter:view.center];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview: self.activityIndicator];
    [self.activityIndicator startAnimating];
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    [self setNavagationBar];

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *filePath = [bundle pathForResource:@"JSBridge" ofType:@"js"];
        NSLog(@"%@", filePath);
    NSString *javascript = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString: javascript];
    NSLog(@"webViewDidFinishLoad");
}

- (void)setTitle:(NSString *)query {
    NSMutableDictionary *dict = [self parseQuery: query];
    self.navigationItem.title = [dict objectForKey:@"title"];
}

- (void)pushView:(NSString *)query {
    NSMutableDictionary *dict = [self parseQuery: query];
    NSString *url = [dict objectForKey: @"url"];
    JsWebViewController *nextViewController = [[JsWebViewController alloc] init];
    NSString* path = [[NSBundle mainBundle] pathForResource: url ofType: @""];
    nextViewController.url = path;
    NSString *title = [dict objectForKey:@"title"];
    if (title) {
        nextViewController.navigationItem.title = title;
    }
    [self.navigationController pushViewController:nextViewController animated:YES];
}

- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableDictionary *)parseQuery:(NSString *)query {
    NSArray *queryArray = [query componentsSeparatedByString:@"&"];
    NSInteger count = [queryArray count];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    for (NSInteger i = 0 ; i < count; i++) {
        NSString *temp = [queryArray objectAtIndex:i];
        NSArray *tempArray = [temp componentsSeparatedByString:@"="];
        [dict setObject: tempArray[1] forKey: tempArray[0]];
    }
    return dict;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.mainDocumentURL;
    NSString *scheme = request.URL.scheme;
    //NSString *absoluteString = [url absoluteString];
    NSString *host = [url host];
    NSString *query = [url query];
    NSArray *methods = [NSArray arrayWithObjects:@"setTitle", @"pushView", @"popView", nil];

    if ([scheme isEqualToString: CustomProtocolScheme]) {
        NSInteger index = [methods  indexOfObject: host];
        switch (index) {
            case 0:
            [self setTitle: query];
            break;
            case 1:
            [self pushView: query];
            break;
            case 2:
            [self popView];
            break;
            default:
            break;
        }
        return NO;
    } else {
        switch (navigationType) {
            case UIWebViewNavigationTypeLinkClicked:
            NSLog(@"clicked");
            break;
            case UIWebViewNavigationTypeFormSubmitted:
            NSLog(@"submitted");
            default:
            break;
        }
        return YES;
    }
}

@end