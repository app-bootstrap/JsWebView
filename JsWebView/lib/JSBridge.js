/* 
  JSWebView.js
  JsWebView

  Created by xdf on 4/30/15.
  Copyright (c) 2015 xdf. All rights reserved.
*/

;(function(global) {
  'use strict';

  var doc = document;
  var methods = {};

  var Util = {
    slice: Array.prototype.slice
  };

  var _exec = function(host, querystring) {
    var url = 'jsbridge://' + host;

    if (querystring) {
      var qs = [];
      for (var i in querystring) {
        qs.push(i + '=' + querystring[i]);
      }
      url += '?' + encodeURIComponent(qs.join('&'));
    }
    global.location.href = url;
  };

  methods.setTitle = function() {
    var args = Util.slice.call(arguments);
    var title = args[0];

    _exec('setTitle', {
      title: title
    });
  };

  methods.pushView = function() {
    var args = Util.slice.call(arguments);

    _exec('pushView', args[0][0]);
  };

  methods.popView = function() {
    _exec('popView');
  };

  var _init = function() {
    this.methods = methods;
  };

  var _invoke = function() {
    var args = Util.slice.call(arguments);

    if (!args) {
      alert('arguments error');
    }

    var method = args.shift();

    try {
      this.methods[method].call(global, args);
    } catch(e) {
      alert(e.stack);
    }
  };

  var JSBridge = {
    init: _init,
    invoke: _invoke
  };

  JSBridge.init();

  var readyEvent = doc.createEvent('Events');
  readyEvent.initEvent('JSBridgeReady');
  doc.dispatchEvent(readyEvent);
  
  global.JSBridge = JSBridge;
})(this);
