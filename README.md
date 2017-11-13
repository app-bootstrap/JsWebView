# JsWebView

## Preview

![preview](screenshot/preview.gif)

## Usage

### Installation

copy `JsWebViewController.h`, `JsWebViewController.m` into your project.


Add the following import to the top of the file:

``` objc
#import "JsWebViewController.h"
```

### Configuration

``` objc
JsWebViewController *view = [[JsWebViewController alloc] init];
...
view.url = url;
```

### Usage

``` javascript
var callback = function() {

  $('#pushView').addEventListener('click', function() {
    JSBridge.invoke('pushView', {
      url: 'index.html'
    });
  }, false);

  $('#popView').addEventListener('click', function() {
    JSBridge.invoke('popView');
  }, false);

  $('#setTitle').addEventListener('click', function() {
    JSBridge.invoke('setTitle', 'newTitle');
  }, false);
};

document.addEventListener('JSBridgeReady', function() {
  callback();
}, false);
```

## License

The MIT License (MIT)

Copyright (c) 2015 xdf
