//
//  JsWebViewController.h
//  JsWebView
//
//  Created by xdf on 4/29/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CustomProtocolScheme @"jsbridge"

@interface JsWebViewController: UIViewController
@property (strong, nonatomic) NSString *url;
@end